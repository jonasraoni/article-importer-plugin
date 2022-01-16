<?php
/**
 * @file plugins/importexport/articleImporter/parsers/aPlusPlus/IssueParser.inc.php
 *
 * Copyright (c) 2014-2022 Simon Fraser University
 * Copyright (c) 2000-2022 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class IssueParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the issues
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\APlusPlus;

use PKP\Plugins\ImportExport\ArticleImporter\ArticleImporterPlugin;

trait IssueParser
{
    /** @var bool True if the issue was created by this instance */
    private $_isIssueOwner;
    /** @var \Issue Issue instance */
    private $_issue;

    /**
     * Rollbacks the operation
     */
    private function _rollbackIssue(): void
    {
        if ($this->_isIssueOwner) {
            \DAORegistry::getDAO('IssueDAO')->deleteObject($this->_issue);
        }
    }

    /**
     * Parses and retrieves the issue, if an issue with the same name exists, it will be retrieved
     */
    public function getIssue(): \Issue
    {
        static $cache = [];

        if ($this->_issue) {
            return $this->_issue;
        }

        $entry = $this->getArticleEntry();
        if ($issue = $cache[$this->getContextId()][$entry->getVolume()][$entry->getIssue()] ?? null) {
            return $this->_issue = $issue;
        }

        // If this issue exists, return it
        $issues = \Services::get('issue')->getMany([
            'contextId' => $this->getContextId(),
            'volumes' => $entry->getVolume(),
            'numbers' => $entry->getIssue()
        ]);
        $this->_issue = $issues->current();

        if (!$this->_issue) {
            // Create a new issue
            $issueDao = \DAORegistry::getDAO('IssueDAO');
            $issue = $issueDao->newDataObject();

            $publicationDate = $this->getDateFromNode($this->selectFirst('Journal/Volume/Issue/IssueInfo/IssueHistory/OnlineDate'))
                ?: $this->getDateFromNode($this->selectFirst('Journal/Volume/Issue/IssueInfo/IssueHistory/CoverDate'))
                ?: $this->getPublicationDate();

            $issue->setData('journalId', $this->getContextId());
            $issue->setData('volume', $entry->getVolume());
            $issue->setData('number', $entry->getIssue());
            $issue->setData('year', (int) $publicationDate->format('Y'));
            $issue->setData('published', true);
            $issue->setData('current', false);
            $issue->setData('datePublished', $publicationDate->format(ArticleImporterPlugin::DATETIME_FORMAT));
            $issue->setData('accessStatus', \ISSUE_ACCESS_OPEN);
            $issue->setData('showVolume', true);
            $issue->setData('showNumber', true);
            $issue->setData('showYear', true);
            $issue->setData('showTitle', false);
            $issue->stampModified();
            $issueDao->insertObject($issue);

            $issueFolder = (string)$entry->getSubmissionPathInfo()->getPathInfo();
            $this->setIssueCover($issueFolder, $issue);

            $this->_isIssueOwner = true;

            $this->_issue = $issue;
        }

        return $cache[$this->getContextId()][$entry->getVolume()][$entry->getIssue()] = $this->_issue;
    }

    /**
     * Retrieves the issue publication date
     */
    public function getIssuePublicationDate(): \DateTimeImmutable
    {
        return new \DateTimeImmutable($this->getIssue()->getData('datePublished'));
    }
}
