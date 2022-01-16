<?php
/**
 * @file plugins/importexport/articleImporter/parsers/aPlusPlus/SubmissionParser.inc.php
 *
 * Copyright (c) 2014-2022 Simon Fraser University
 * Copyright (c) 2000-2022 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SubmissionParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the submissions
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\APlusPlus;

use PKP\Plugins\ImportExport\ArticleImporter\ArticleImporterPlugin;

trait SubmissionParser
{
    /** @var \Submission Submission instance */
    private $_submission;

    /**
     * Rollbacks the operation
     */
    private function _rollbackSubmission(): void
    {
        if ($this->_submission) {
            \Application::getSubmissionDAO()->deleteObject($this->_submission);
        }
    }

    /**
     * Parses and retrieves the submission
     */
    public function getSubmission(): \Submission
    {
        if ($this->_submission) {
            return $this->_submission;
        }

        $article = \Application::getSubmissionDAO()->newDataObject();
        $article->setData('contextId', $this->getContextId());
        $article->setData('status', \STATUS_PUBLISHED);
        $article->setData('submissionProgress', 0);
        $article->setData('stageId', \WORKFLOW_STAGE_ID_PRODUCTION);
        $article->setData('sectionId', $this->getSection()->getId());
        $date = $this->getDateFromNode($this->selectFirst('Journal/Volume/Issue/Article/ArticleInfo/ArticleHistory/RegistrationDate')) ?: $this->getPublicationDate();
        $article->setData('dateSubmitted', $date->format(ArticleImporterPlugin::DATETIME_FORMAT));

        // Creates the submission
        $this->_submission = \Services::get('submission')->add($article, \Application::get()->getRequest());

        $this->_processKeywords();
        $this->_assignEditor();

        return $this->_submission;
    }

    /**
     * Assign editor as participant in production stage
     */
    private function _assignEditor(): void
    {
        $stageAssignmentDao = \DAORegistry::getDAO('StageAssignmentDAO');
        $stageAssignmentDao->build($this->getSubmission()->getId(), $this->getConfiguration()->getEditorGroupId(), $this->getConfiguration()->getEditor()->getId());
    }

    /**
     * Process the article keywords
     */
    private function _processKeywords(): void
    {
        $submissionKeywordDAO = \DAORegistry::getDAO('SubmissionKeywordDAO');
        $keywords = [];
        foreach ($this->select('Journal/Volume/Issue/Article/ArticleHeader/KeywordGroup') as $node) {
            $locale = $this->getLocale($node->getAttribute('Language'));
            foreach ($this->select('Keyword', $node) as $node) {
                $keywords[$locale][] = $this->selectText('.', $node);
            }
        }
        if (count($keywords)) {
            $submissionKeywordDAO->insertKeywords($keywords, $this->getSubmission()->getId());
        }
    }
}
