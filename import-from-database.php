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

use APP\core\PageRouter;
use APP\facades\Repo;
use APP\plugins\importexport\articleImporter\Configuration;
use APP\plugins\importexport\articleImporter\OreImporter;
use APP\submission\Submission;
use Exception;
use PKP\cliTool\CommandLineTool;
use PKP\core\Registry;
use PKP\plugins\Hook;

new CommandLineTool();

// Configuration
$contextPath = $argv[1] ?? 'default-context';
$username = $argv[2] ?? 'admin';
$editorUsername = $argv[3] ?? 'editor';
$email = $argv[4] ?? 'admin@example.com';


$capsule = new Illuminate\Database\Capsule\Manager;
$capsule->addConnection([
    'driver' => 'pgsql',
    'host' => '127.0.0.1',
    'database' => 'ore',
    'username' => 'root',
    'password' => 'abc123',
], 'source');


// Database connection - adjust connection name if needed
$connection = $capsule->getConnection('source'); // or 'pgsql' depending on your config

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
        foreach (Repo::submission()->getCollector()->filterByStatus([Submission::STATUS_PUBLISHED])->filterByContextIds([$configuration->getContext()->getId()])->getMany() as $submission) {
            if ($submission->getId() < 870) {
                continue;
            }

            $importer = new OreImporter($configuration, $connection, $submission->getId());
        }
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

