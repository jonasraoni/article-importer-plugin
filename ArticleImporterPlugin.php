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
use APP\plugins\importexport\articleImporter\exceptions\ArticleSkippedException;
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
            'password' => getenv('F1000_DB_PASS') ?: 'abc123',
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
                $useCategoryAsSection
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
                $article = implode('-', [$entry->getVolume(), $entry->getIssue(), $entry->getArticle()]);
                try {
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

            $this->_writeLine(__('plugins.importexport.articleImporter.importEnd'));
        } catch (Throwable $e) {
            $this->_writeLine(__('plugins.importexport.articleImporter.importError', ['message' => $e]));
        }
        $this->_writeLine(__('plugins.importexport.articleImporter.importStatus', ['count' => $count, 'imported' => $imported, 'failed' => $failed, 'skipped' => $skipped]));
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
}
