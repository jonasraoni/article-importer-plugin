<?php
/**
 * @file plugins/importexport/articleImporter/ArticleImporterPlugin.inc.php
 *
 * Copyright (c) 2014-2022 Simon Fraser University
 * Copyright (c) 2000-2022 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleImporterPlugin
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief ArticleImporter XML import plugin
 */

namespace PKP\Plugins\ImportExport\ArticleImporter;

import('lib.pkp.classes.plugins.ImportExportPlugin');
import('lib.pkp.classes.submission.SubmissionFile');
import('lib.pkp.classes.file.FileManager');

use PKP\Plugins\ImportExport\ArticleImporter\Exceptions\ArticleSkippedException;

class ArticleImporterPlugin extends \ImportExportPlugin
{
    public const DATETIME_FORMAT = 'Y-m-d H:i:s';
    /**
     * Registers a custom autoloader to handle the plugin namespace
     */
    private function useAutoLoader()
    {
        spl_autoload_register(function ($className) {
            // Removes the base namespace from the class name
            $path = explode(__NAMESPACE__ . '\\', $className, 2);
            if (!reset($path)) {
                // Breaks the remaining class name by \ to retrieve the folder and class name
                $path = explode('\\', end($path));
                $class = array_pop($path);
                $path = array_map(function ($name) {
                    return strtolower($name[0]) . substr($name, 1);
                }, $path);
                $path[] = $class;
                // Uses the internal loader
                $this->import(implode('.', $path));
            }
        });
    }

    /**
     * @copydoc ImportExportPlugin::getDescription()
     */
    public function executeCLI($scriptName, &$args): void
    {
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
                [Parsers\APlusPlus\Parser::class, Parsers\Jats\Parser::class],
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
            \Registry::set('user', $user);

            /** @var JournalDAO  */
            $journalDao = \DAORegistry::getDAO('JournalDAO');
            $journal = $journalDao->getByPath($contextPath);
            // Set global context
            $request = \Application::get()->getRequest();
            if (!$request->getContext()) {
                \HookRegistry::register('Router::getRequestedContextPaths', function (string $hook, array $args) use ($journal): bool {
                    $args[0] = [$journal->getPath()];
                    return false;
                });
                $router = new \PageRouter();
                $router->setApplication(\Application::get());
                $request->setRouter($router);
            }

            \PluginRegistry::loadCategory('pubIds', true, $configuration->getContext()->getId());

            $sectionDao = \Application::getSectionDAO();
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
        $issueDao = \DAORegistry::getDAO('IssueDAO');
        // Clears previous ordering
        $issueDao->deleteCustomIssueOrdering($contextId);

        // Retrieves issue IDs sorted by volume and number
        $rsIssues = \Services::get('issue')->getQueryBuilder([
            'contextId' => $contextId,
            'isPublished' => true,
            'orderBy' => 'seq',
            'orderDirection' => 'ASC'
        ])
            ->getQuery()
            ->orderBy('volume', 'DESC')
            ->orderBy('number', 'DESC')
            ->select('i.issue_id')
            ->pluck('i.issue_id');
        $sequence = 0;
        $latestIssue = null;
        foreach ($rsIssues as $id) {
            $latestIssue || ($latestIssue = $id);
            $issueDao->insertCustomIssueOrder($contextId, $id, ++$sequence);
        }

        // Sets latest issue as the current one
        $latestIssue = \Services::get('issue')->get($latestIssue);
        $latestIssue->setData('current', true);
        $issueDao->updateCurrent($configuration->getContext()->getId(), $latestIssue);
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
        $this->useAutoLoader();
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
