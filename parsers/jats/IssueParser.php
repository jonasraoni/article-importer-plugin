<?php
/**
 * @file parsers/jats/IssueParser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class IssueParser
 * @brief Handles parsing and importing the issues
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\plugins\importexport\articleImporter\ArticleImporterPlugin;

use APP\issue\Issue;
use PKP\db\DAORegistry;
use APP\facades\Repo;

trait IssueParser
{
    /** @var bool True if the issue was created by this instance */
    private bool $_isIssueOwner = false;

    /** @var Issue Issue instance */
    private ?Issue $_issue = null;

    /**
     * Rollbacks the operation
     */
    private function _rollbackIssue(): void
    {
        if ($this->_isIssueOwner) {
            Repo::issue()->delete($this->_issue);
        }
    }

    /**
     * Parses and retrieves the issue, if an issue with the same name exists, it will be retrieved
     */
    public function getIssue(): Issue
    {
        static $cache = [];

        if ($this->_issue) {
            return $this->_issue;
        }

        $entry = $this->getArticleEntry();
        $volume = $this->selectText('front/article-meta/volume') ?: $entry->getVolume();
        $issueNumber = $this->selectText('front/article-meta/issue') ?: $entry->getIssue();
        if ($issue = $cache[$this->getContextId()][$volume][$issueNumber] ?? null) {
            return $this->_issue = $issue;
        }

        // If this issue exists, return it
        $issues = Repo::issue()->getCollector()
	    ->filterByContextIds([$this->getContextId()])
	    ->filterByVolumes([$volume])
	    ->filterByNumbers([$issueNumber])
	    ->getMany();
        $this->_issue = $issues->first();

        if (!$this->_issue) {
            // Create a new issue
            $issue = Repo::issue()->dao->newDataObject();

	    $node = $this->selectFirst("front/article-meta/pub-date[@pub-type='collection']");
            $publicationDate = $this->getDateFromNode($node) ?? $this->getPublicationDate();

            $issue->setData('journalId', $this->getContextId());
            $issue->setData('volume', $volume);
            $issue->setData('number', $issueNumber);
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
            Repo::issue()->add($issue);

            $issueFolder = (string)$entry->getSubmissionPathInfo()->getPathInfo();
            $this->setIssueCover($issueFolder, $issue);

            $this->_isIssueOwner = true;

            $this->_issue = $issue;
        }

        return $cache[$this->getContextId()][$volume][$issueNumber] = $this->_issue;
    }

    /**
     * Retrieves the issue publication date
     */
    public function getIssuePublicationDate(): \DateTimeImmutable
    {
        return new \DateTimeImmutable($this->getIssue()->getData('datePublished'));
    }
}
