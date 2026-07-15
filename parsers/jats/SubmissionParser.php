<?php
/**
 * @file parsers/jats/SubmissionParser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SubmissionParser
 * @brief Handles parsing and importing the submissions
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\plugins\importexport\articleImporter\EntityManager;
use DateInterval;
use APP\submission\Submission;
use APP\facades\Repo;

trait SubmissionParser
{
    use EntityManager;

    /**
     * Parses and retrieves the submission
     */
    public function getSubmission(): Submission
    {
        if ($submission = $this->getCachedSubmission()) {
            return $submission;
        }

        $submission = Repo::submission()->newDataObject();
        $submission->setData('contextId', $this->getContextId());
        $submission->setData('status', Submission::STATUS_PUBLISHED);
        $submission->setData('submissionProgress', '');
        $submission->setData('stageId', WORKFLOW_STAGE_ID_PRODUCTION);
        $submission->setData('locale', $this->getLocale());
        $date = $this->getDateFromNode($this->selectFirst("front/article-meta/history/date[@date-type='received']")) ?: $this->getPublicationDate()->add(new DateInterval('P1D'));
        $submission->setData('dateSubmitted', $date->format(static::DATETIME_FORMAT));
        // Creates the submission
        Repo::submission()->dao->insert($submission);
        $this->trackEntity($submission);
        $this->setCachedSubmission($submission);
        $this->_assignEditor();
        return $submission;
    }

    /**
     * Assign editor as participant in production stage
     */
    private function _assignEditor(): void
    {
        Repo::stageAssignment()->build($this->getSubmission()->getId(), $this->getConfiguration()->getEditorGroupId(), $this->getConfiguration()->getEditor()->getId());
    }
}
