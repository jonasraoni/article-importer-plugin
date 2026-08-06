<?php
/**
 * @file ArticleImporterPlugin.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleImporterPlugin
 * @brief ArticleImporter XML import plugin
 */

namespace APP\plugins\importexport\articleImporter;

use APP\journal\JournalDAO;
use APP\notification\Notification;
use APP\plugins\importexport\articleImporter\exceptions\ArticleSkippedException;
use APP\plugins\importexport\articleImporter\parsers\jats\Parser;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use PKP\core\Registry;
use PKP\db\DAORegistry;
use PKP\plugins\Hook;
use APP\core\Application;
use APP\core\PageRouter;
use PKP\plugins\PluginRegistry;
use PKP\plugins\ImportExportPlugin;
use APP\facades\Repo;
use Throwable;

class ArticleImporterPlugin extends ImportExportPlugin
{
    private static $oreConnection;
    public static function getOreConnection(): \Illuminate\Database\Connection
    {
        if (static::$oreConnection) {
            return static::$oreConnection;
        }

        $capsule = new \Illuminate\Database\Capsule\Manager;
        $capsule->addConnection([
            'driver' => 'pgsql',
            'host' => getenv('F1000_DB_HOST') ?: '127.0.0.1',
            'database' => getenv('F1000_DB_NAME') ?: 'ore',
            'username' => getenv('F1000_DB_USER') ?: 'root',
            'password' => getenv('F1000_DB_PASS') ?: 'password',
        ], 'source');
        return static::$oreConnection = $capsule->getConnection('source');
    }

    /**
     * @copydoc ImportExportPlugin::getDescription()
     */
    public function executeCLI($scriptName, &$args): void
    {
        // Extend memory and execution time limits
        ini_set('memory_limit', -1);
        ini_set('assert.exception', 0);
        // Disable the time limit
        set_time_limit(0);

        if (in_array('--cleanup', $args)) {
            $this->cleanup();
            exit(0);
        }

        // Expects 5 non-empty arguments
        if (count(array_filter($args, 'strlen')) < 5) {
            $this->usage($scriptName);
            return;
        }

        // Map arguments to variables
        [$contextPath, $username, $editorUsername, $email, $importPath] = $args;

        // Parse command-line flags
        $generateHtml = !in_array('--no-html', $args);
        $useCategoryAsSection = in_array('--use-category-as-section', $args);
        $hasVersion = !in_array('--no-version', $args);
        $hasVolume = !in_array('--no-volume', $args);
        $hasNumber = !in_array('--no-number', $args);
        $preloadHtml = in_array('--preload-html', $args);

        $this->resetAutoIncrements();

        $count = $imported = $failed = $skipped = 0;
        try {
            $configuration = new Configuration(
                [parsers\aPlusPlus\Parser::class, parsers\jats\Parser::class],
                $contextPath,
                $username,
                $editorUsername,
                $email,
                $importPath,
                'Articles',
                $generateHtml,
                $useCategoryAsSection,
                $hasVersion,
                $hasVolume,
                $hasNumber,
                $preloadHtml
            );

            $this->_writeLine(__('plugins.importexport.articleImporter.importStart'));

            // FIXME: This attaches the associated user to the request and is a workaround for no users being present when running CLI tools.
            $user = $configuration->getUser();
            Registry::set('user', $user);

            /** @var JournalDAO */
            $journalDao = DAORegistry::getDAO('JournalDAO');
            $journal = $journalDao->getByPath($contextPath);
            // Set global context
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

            PluginRegistry::loadCategory('pubIds', true, $configuration->getContext()->getId());

            // Iterates through all the found article entries, already sorted by ascending volume > issue > article.
            // Multi-version importers set sourcePublicationId when creating versions 2+ (OreImporter, JATS and aPlusPlus PublicationParsers).
            $iterator = $configuration->getArticleIterator();
            $count = 0;
            /** @var ArticleEntry */
            foreach ($iterator as $entry) {
                ++$count;
                $article = implode('-', array_filter([$entry->getVolume(), $entry->getIssue(), $entry->getArticle()], fn ($part) => $part !== null && $part !== ''));
                try {
                    if ($configuration->shouldPreloadHtml()) {
                        foreach ($entry->getVersions() as $version) {
                            $parser = new Parser($configuration, $version);
                            $parser->ensureMetadataIsValidAndParse()
                                ->downloadHtml();
                            ++$imported;
                        }
                        continue;
                    }
                    // Process the article
                    $entry->process($configuration);
                    ++$imported;
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleImported', ['article' => $article]));
                } catch (ArticleSkippedException $e) {
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleSkipped', ['article' => $article, 'message' => $e]));
                    ++$skipped;
                } catch (Throwable $e) {
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleSkipped', ['article' => $article, 'message' => $e]));
                    ++$failed;
                }
            }

            // Resequences issue orders
            if ($imported) {
                $this->resequenceIssues($configuration);
            }

            $this->_writeLine('Processing Orcids');
            $this->processOrcids();
            $this->_writeLine('Including extra data for reviewers');
            $this->fillReviewerIdentityFromAuthor($configuration->getContext()->getId());
            DB::update("UPDATE user_user_groups SET date_start = NULL");

            $this->_writeLine(__('plugins.importexport.articleImporter.importEnd'));
        } catch (Throwable $e) {
            $this->_writeLine(__('plugins.importexport.articleImporter.importError', ['message' => $e]));
        }
        $this->_writeLine(__('plugins.importexport.articleImporter.importStatus', ['count' => $count, 'imported' => $imported, 'failed' => $failed, 'skipped' => $skipped]));
    }

    /**
     * Import Orcids
     */
    public function processOrcids(): void
    {
        $orcids = static::getOreConnection()->table('orcid_access_data')
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
    }

    /**
     * Cleanup the database
     */
    public function cleanup(): void
    {
        $this->_writeLine('Deleting jobs');
        DB::delete('DELETE FROM failed_jobs');
        DB::delete('DELETE FROM jobs');

        $this->_writeLine('Deleting submissions');
        foreach (DB::select('SELECT submission_id FROM submissions') as $row) {
            try {
                $submission = Repo::submission()->get($row->submission_id);
                Repo::submission()->delete($submission);
            } catch (Throwable $e) {
                $this->_writeLine($e);
            }
        }

        $this->_writeLine('Cleaning tombstones');
        DB::delete(
            'DELETE dot
            FROM data_object_tombstones dot
            LEFT JOIN submissions s ON dot.data_object_id = s.submission_id
            WHERE s.submission_id IS NULL'
        );

        $this->_writeLine('Cleaning notifications');
        Notification::query()->delete();

        $this->_writeLine('Cleaning events');
        Repo::eventLog()->deleteMany(Repo::eventLog()->getCollector());

        $this->_writeLine('Cleanup done');
    }

    /**
     * Looks up an existing author matching the given email and extracts identity
     * data (all ORCID OAuth fields and a flattened, localized affiliation string)
     * for reuse on a user.
     */
    public function fillReviewerIdentityFromAuthor(int $contextId): void
    {
        /**
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

        foreach (Repo::user()->getCollector()->filterByContextIds([$contextId])->getMany() as $user) {
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
    }

    /**
     * Resequences the issues
     */
    public function resequenceIssues(Configuration $configuration): void
    {
        $contextId = $configuration->getContext()->getId();

        // Retrieves issue IDs sorted by volume and number
        $issueCollector = Repo::issue()->getCollector();
        $rsIssues = $issueCollector->filterByContextIds([$contextId])
            ->filterByPublished(true)
            ->orderBy($issueCollector::ORDERBY_SEQUENCE)
            ->getQueryBuilder()
                ->orderBy('volume', 'DESC')
                ->orderByRaw('CAST(number AS UNSIGNED) DESC')
                ->select('i.issue_id')
                ->pluck('i.issue_id');
        // Continuous publishing: nothing to resequence when there are no issues
        if ($rsIssues->isEmpty()) {
            return;
        }
        $sequence = 0;
        $latestIssue = null;
        foreach ($rsIssues as $id) {
            $latestIssue || ($latestIssue = $id);
            Repo::issue()->dao->deleteCustomIssueOrdering($id);
            Repo::issue()->dao->insertCustomIssueOrder($contextId, $id, ++$sequence);
        }

        // Sets latest issue as the current one
        $latestIssue = Repo::issue()->get($latestIssue);
        $latestIssue->setData('current', true);
        Repo::issue()->updateCurrent($contextId, $latestIssue);
    }

    /**
     * Outputs a message with a line break
     */
    private function _writeLine(?string $message): void
    {
        echo $message, PHP_EOL;
        flush();
    }

    /**
     * @copydoc Plugin::register()
     */
    public function register($category, $path, $mainContextId = null): bool
    {
        $success = parent::register($category, $path);
        $this->addLocaleData();
        return $success;
    }

    /**
     * @copydoc Plugin::getName()
     */
    public function getName(): string
    {
        $class = explode('\\', __CLASS__);
        return end($class);
    }

    /**
     * @copydoc Plugin::getDisplayName()
     */
    public function getDisplayName(): string
    {
        return __('plugins.importexport.articleImporter.displayName');
    }

    /**
     * @copydoc Plugin::getDescription()
     */
    public function getDescription(): string
    {
        return __('plugins.importexport.articleImporter.description');
    }

    /**
     * @copydoc ImportExportPlugin::usage()
     */
    public function usage($scriptName): void
    {
        $this->_writeLine(__('plugins.importexport.articleImporter.cliUsage', ['scriptName' => $scriptName, 'pluginName' => $this->getName()]));
    }

    /**
     * Reset the auto increment fields
     */
    public static function resetAutoIncrements(): void
    {
        $database = DB::getDatabaseName();
        // Find every table that actually has an AUTO_INCREMENT column, along with the name of that column.
        $tables = DB::select("
            SELECT TABLE_NAME AS `table`, COLUMN_NAME AS `column`
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = ?
            AND EXTRA = 'auto_increment'
        ", [$database]);
        foreach ($tables as $row) {
            $table = $row->table;
            $column = $row->column;
            $maxId = DB::table($table)->max($column) ?? 0;
            $nextId = $maxId + 1;
            DB::statement("ALTER TABLE `{$table}` AUTO_INCREMENT = {$nextId}");
        }
    }
}
