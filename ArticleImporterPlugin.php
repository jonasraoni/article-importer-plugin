<?php
/**
 * @file ArticleImporterPlugin.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleImporterPlugin
 * @brief ArticleImporter XML import plugin
 */

namespace APP\plugins\importexport\articleImporter;

use APP\plugins\importexport\articleImporter\exceptions\ArticleSkippedException;

use PKP\session\SessionManager;
use PKP\core\Registry;
use PKP\db\DAORegistry;
use PKP\plugins\Hook;
use APP\core\Application;
use APP\core\PageRouter;
use APP\core\Services;
use PKP\plugins\PluginRegistry;
use PKP\plugins\ImportExportPlugin;
use APP\facades\Repo;

class ArticleImporterPlugin extends ImportExportPlugin
{
    public const DATETIME_FORMAT = 'Y-m-d H:i:s';

    /**
     * @copydoc ImportExportPlugin::getDescription()
     */
    public function executeCLI($scriptName, &$args): void
    {
        ini_set('memory_limit', -1);
        SessionManager::getManager();
        // Disable the time limit
        set_time_limit(0);

        // Expects 5 non-empty arguments
        if (count(array_filter($args, 'strlen')) != 5) {
            $this->usage($scriptName);
            return;
        }

        // Map arguments to variables
        [$contextPath, $username, $editorUsername, $email, $importPath] = $args;

        $count = $imported = $failed = $skipped = 0;
        try {
            $configuration = new Configuration(
                [parsers\aPlusPlus\Parser::class, parsers\jats\Parser::class],
                $contextPath,
                $username,
                $editorUsername,
                $email,
                $importPath
            );

            $this->_writeLine(__('plugins.importexport.articleImporter.importStart'));

            // FIXME: This attaches the associated user to the request and is a workaround for no users being present
            //     when running CLI tools. This assumes that given the username supplied should be used as the
            //  authenticated user. To revisit later.
            $user = $configuration->getUser();
            Registry::set('user', $user);

            /** @var JournalDAO  */
            $journalDao = DAORegistry::getDAO('JournalDAO');
            $journal = $journalDao->getByPath($contextPath);
            // Set global context
            $request = Application::get()->getRequest();
            if (!$request->getContext()) {
                Hook::add('Router::getRequestedContextPaths', function (string $hook, array $args) use ($journal): bool {
                    $args[0] = [$journal->getPath()];
                    return false;
                });
                $router = new PageRouter();
                $router->setApplication(Application::get());
                $request->setRouter($router);
            }

            PluginRegistry::loadCategory('pubIds', true, $configuration->getContext()->getId());

            $lastIssueId = null;

            // Iterates through all the found article entries, already sorted by ascending volume > issue > article
            $iterator = $configuration->getArticleIterator();
            $count = count($iterator);
            foreach ($iterator as $entry) {
                $article = implode('-', [$entry->getVolume(), $entry->getIssue(), $entry->getArticle()]);
                try {
                    // Process the article
                    $parser = $entry->process($configuration);
                    ++$imported;
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleImported', ['article' => $article]));
                } catch (ArticleSkippedException $e) {
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleSkipped', ['article' => $article, 'message' => $e->getMessage()]));
                    ++$skipped;
                } catch (\Exception $e) {
                    $this->_writeLine(__('plugins.importexport.articleImporter.articleSkipped', ['article' => $article, 'message' => $e->getMessage()]));
                    ++$failed;
                }
            }

            // Resequences issue orders
            if ($imported) {
                $this->resequenceIssues($configuration);
            }

            $this->_writeLine(__('plugins.importexport.articleImporter.importEnd'));
        } catch (\Exception $e) {
            $this->_writeLine(__('plugins.importexport.articleImporter.importError', ['message' => $e->getMessage()]));
        }
        $this->_writeLine(__('plugins.importexport.articleImporter.importStatus', ['count' => $count, 'imported' => $imported, 'failed' => $failed, 'skipped' => $skipped]));
    }

    /**
     * Resequences the issues
     */
    public function resequenceIssues(Configuration $configuration): void
    {
        $contextId = $configuration->getContext()->getId();

        // Clears previous ordering
        Repo::issue()->dao->deleteCustomIssueOrdering($contextId);

        // Retrieves issue IDs sorted by volume and number
	$issueCollector = Repo::issue()->getCollector();
        $rsIssues = $issueCollector->filterByContextIds([$contextId])
	    ->filterByPublished(true)
	    ->orderBy($issueCollector::ORDERBY_SEQUENCE)
	    ->getQueryBuilder()
            ->orderBy('volume', 'DESC')
            ->orderBy('number', 'DESC')
            ->select('i.issue_id')
            ->pluck('i.issue_id');
        $sequence = 0;
        $latestIssue = null;
        foreach ($rsIssues as $id) {
            $latestIssue || ($latestIssue = $id);
            Repo::issue()->dao->insertCustomIssueOrder($contextId, $id, ++$sequence);
        }

        // Sets latest issue as the current one
        $latestIssue = Repo::issue()->get($latestIssue);
        $latestIssue->setData('current', true);
        Repo::issue()->updateCurrent($configuration->getContext()->getId(), $latestIssue);
    }

    /**
     * Outputs a message with a line break
     *
     * @param string $message
     */
    private function _writeLine($message): void
    {
        echo $message, \PHP_EOL;
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
