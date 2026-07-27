<?php
/**
 * @file import-from-database.php
 *
 * Example script for importing articles from PostgreSQL database using JatsDatabaseImporter
 *
 * Usage:
 *   php import-from-database.php [article_id] [--all] [--filter=status:PUBLISHED]
 */

require_once __DIR__ . '/../../../tools/bootstrap.php';

use APP\core\Application;
use APP\core\PageRouter;
use APP\facades\Repo;
use APP\plugins\importexport\articleImporter\ArticleImporterPlugin;
use APP\plugins\importexport\articleImporter\Configuration;
use APP\plugins\importexport\articleImporter\OreImporter;
use APP\submission\Submission;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use PKP\cliTool\CommandLineTool;
use PKP\core\Registry;
use PKP\plugins\Hook;

new CommandLineTool();

if (isset($argv[1]) && $argv[1] === '--cleanup') {
    echo "Deleting jobs\n";
    DB::delete("delete from failed_jobs");
    DB::delete("delete from jobs");

    echo "Deleting submissions\n";
    foreach (DB::select("select distinct p.submission_id from publication_settings ps inner join publications p on p.publication_id = ps.publication_id where ps.setting_name = 'pub-id::publisher-id'") as $row) {
        try {
            DB::delete("delete from review_assignments where submission_id = ?", [$row->submission_id]);
            DB::delete("delete from review_rounds where submission_id = ?", [$row->submission_id]);

            $submission = Repo::submission()->get($row->submission_id);
            echo "Deleting submission: " . $row->submission_id . "\n";
            if ($submission) {
                for ($i = 0; $i < 20; $i++) {
                    Repo::submission()->delete($submission);
                }
            }
        } catch (\Throwable $e) {
            echo "$e\n\n";
        }
    }
    echo "Cleaning tombstones\n";
    DB::delete(
        "DELETE dot
        FROM data_object_tombstones dot
        LEFT JOIN submissions s ON dot.data_object_id = s.submission_id
        WHERE s.submission_id IS NULL"
    );
    echo "Cleanup done\n";
    exit(0);
}

// Configuration
$contextPath = $argv[1] ?? throw new Exception('Context path is required');
$username = $argv[2] ?? throw new Exception('Username is required');
$editorUsername = $argv[3] ?? throw new Exception('Editor username is required');
$email = $argv[4] ?? throw new Exception('Email is required');


$connection = ArticleImporterPlugin::getOreConnection();

// Create configuration
$configuration = new Configuration(
    [], // No parsers needed for database import
    $contextPath,
    $username,
    $editorUsername,
    $email,
    '.', // No import path needed
    'Articles',
    true, // Generate HTML
    false  // Use category as section
);

$user = $configuration->getUser();
Registry::set('user', $user);

$journal = $configuration->getContext();
$request = Application::get()->getRequest();
if (!$request->getContext()) {
    Hook::add('Router::getRequestedContextPath', function (string $hook, array $args) use ($journal): bool {
        $args[0] = $journal->getPath();
        return Hook::CONTINUE;
    });
    $router = new PageRouter();
    $router->setApplication(Application::get());
    $request->setRouter($router);
}

try {
    // Check command line arguments
    if (isset($argv[5]) && $argv[5] === '--all') {
        // Import all articles
        $filters = [];

        // Parse additional filters
        foreach ($argv as $arg) {
            if (strpos($arg, '--filter=') === 0) {
                $filter = substr($arg, 9);
                [$key, $value] = explode(':', $filter, 2);
                $filters[$key] = $value;
            }
        }

        echo "Importing all articles with filters: " . json_encode($filters) . "\n";
        //OreImporter::importAllArticles($configuration, $connection, $filters);
        foreach (Repo::submission()->getCollector()->filterByContextIds([$configuration->getContext()->getId()])->orderBy(Repo::submission()->getCollector()::ORDERBY_ID)->getMany() as $submission) {
            $importer = new OreImporter($configuration, $connection, $submission->getId());
            echo 'Processed ' . $submission->getId() . "\n";
        }

        $orcids = $connection->table('orcid_access_data')
            ->selectRaw('DISTINCT ON (orcid) *')
            ->orderBy('orcid')
            ->orderByDesc('created_on')
            ->get();
        foreach ($orcids as $orcid) {
            $authorIds = DB::table('author_settings')->where('setting_name', 'orcid')
                ->where('setting_value', 'https://orcid.org/' . $orcid->orcid)
                ->get()
                ->pluck('author_id')
                ->toArray();
            $rows = [];
            foreach ($authorIds as $authorId) {
                $rows[] = ['author_id' => $authorId, 'setting_name' => 'orcidIsVerified', 'setting_value' => '1'];
                $rows[] = ['author_id' => $authorId, 'setting_name' => 'orcidAccessToken', 'setting_value' => (string) $orcid->access_token];
                $rows[] = ['author_id' => $authorId, 'setting_name' => 'orcidAccessScope', 'setting_value' => (string) $orcid->access_scope];
                $rows[] = ['author_id' => $authorId, 'setting_name' => 'orcidRefreshToken', 'setting_value' => (string) $orcid->refresh_token];
                $rows[] = ['author_id' => $authorId, 'setting_name' => 'orcidAccessExpiresOn', 'setting_value' => (string) Carbon::now()->addSeconds((int) $orcid->expires_in)];
            }
            DB::table('author_settings')->upsert(
                $rows,
                ['author_id', 'setting_name'],
                ['setting_value']
            );
        }

        /**
         * Looks up an existing author matching the given email and extracts identity
         * data (all ORCID OAuth fields and a flattened, localized affiliation string)
         * for reuse on a user.
         *
         * @param string $email
         * @return array{0: array<string, mixed>, 1: ?string} [orcidData, affiliation]
         */
        $getReviewerIdentityFromAuthor = function (string $email): array {
            // Authors store email as a column on the authors table. Prefer the most
            // recently inserted match, which is most likely to carry complete data.
            $author_id = DB::table('authors')
                ->where('email', $email)
                ->orderByDesc('author_id')
                ->value('author_id');

            if (!$author_id) {
                return [[], null];
            }

            $author = Repo::author()->get($author_id);
            if (!$author) {
                return [[], null];
            }

            // Copy the full set of ORCID fields shared via the HasOrcid trait.
            $orcidFields = ['orcid', 'orcidIsVerified', 'orcidAccessDenied', 'orcidAccessToken', 'orcidAccessScope', 'orcidRefreshToken', 'orcidAccessExpiresOn'];
            $orcidData = [];
            foreach ($orcidFields as $field) {
                $value = $author->getData($field);
                if ($value !== null) {
                    $orcidData[$field] = $value;
                }
            }

            $affiliation = $author->getLocalizedAffiliationNamesAsString('en') ?: null;

            return [$orcidData, $affiliation];
        };

        foreach (Repo::user()->getCollector()->filterByContextIds([$configuration->getContext()->getId()])->getMany() as $user) {
            // Backfill ORCID and affiliation from an existing author with the same email.
            // This covers at least the author participant; richer source data is currently obfuscated.
            [$orcidData, $affiliation] = $getReviewerIdentityFromAuthor($user->getEmail());
            $updated = false;
            if ($orcidData) {
                $user->setVerifiedOrcidOAuthData($orcidData);
                $updated = true;
            }
            if ($affiliation) {
                $user->setAffiliation($affiliation, 'en');
                $updated = true;
            }
            if ($updated) {
                Repo::user()->edit($user);
            }
        }

        DB::update("UPDATE user_user_groups SET date_start = NULL");
    } elseif (isset($argv[5])) {
        // Import specific article
        $articleId = $argv[5];
        echo "Importing article ID: {$articleId}\n";
        $importer = new OreImporter($configuration, $connection, $articleId);
        //$importer->execute();
        echo "Successfully imported\n";
    } else {
        echo "Usage:\n";
        echo "  php import-from-database.php <context_path> <username> <editor_username> <email> [article_id|--all] [--filter=key:value]\n";
        echo "\n";
        echo "Examples:\n";
        echo "  php import-from-database.php myjournal admin editor admin@example.com 12345\n";
        echo "  php import-from-database.php myjournal admin editor admin@example.com --all\n";
        echo "  php import-from-database.php myjournal admin editor admin@example.com --all --filter=status:PUBLISHED\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
    exit(1);
}

