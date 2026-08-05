<?php
/**
 * @file ReviewImporter.php
 *
 * Copyright (c) 2026 Simon Fraser University
 * Copyright (c) 2026 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ReviewImporter
 *
 */

namespace APP\plugins\importexport\articleImporter;

use APP\publication\Publication;
use APP\submission\Submission;
use APP\facades\Repo;
use DateTimeImmutable;
use Exception;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use PKP\core\Core;
use PKP\decision\Decision;
use PKP\db\DAORegistry;
use PKP\security\Role;
use PKP\security\Validation;
use PKP\stageAssignment\StageAssignment;
use PKP\submission\reviewAssignment\ReviewAssignment;
use PKP\submission\reviewer\recommendation\ReviewerRecommendation;
use PKP\submission\reviewRound\authorResponse\AuthorResponse;
use PKP\submission\reviewRound\ReviewRound;
use PKP\submission\reviewRound\ReviewRoundDAO;
use PKP\submission\SubmissionComment;
use PKP\submission\SubmissionCommentDAO;
use PKP\user\User;

class ReviewImporter
{
    public const DATETIME_FORMAT = 'Y-m-d H:i:s';
    private string $locale = 'en';
    private int $contextId;

    public function __construct(private Configuration $configuration, private \Illuminate\Database\Connection $connection, private int $versionNumber)
    {
        $this->contextId = $configuration->getContext()->getId();
    }

    /**
     * Parse date string to DateTimeImmutable
     */
    private function parseDateString(?string $dateString): ?DateTimeImmutable
    {
        if (!$dateString) {
            return null;
        }

        try {
            return new DateTimeImmutable($dateString);
        } catch (Exception $e) {
            return null;
        }
    }

    /**
     * Ensures stage assignments exist for author and editor in the external review stage.
     * Required for author responses and edit decisions to work correctly.
     */
    private function assignStageAssignments(Submission $submission): void
    {
        $submissionId = $submission->getId();
        $config = $this->configuration;

        // Ensure author group can participate in external review stage
        $config->ensureAuthorGroupInStage(WORKFLOW_STAGE_ID_EXTERNAL_REVIEW);

        $authorGroupId = $config->getAuthorGroupId();
        if (!$authorGroupId) {
            throw new Exception('Author group not found');
        }

        // Assign primary author only
        $publication = $submission->getCurrentPublication();
        $authors = $publication->getData('authors');
        $primaryAuthor = $authors ? $authors->first(fn ($a) => $publication->getData('primaryContactId') === $a->getId()) : null;
        $primaryAuthor ??= $authors?->first();

        if ($primaryAuthor) {
            $email = $primaryAuthor->getData('email');
            if ($email) {
                $user = $this->getOrCreateUser(
                    $primaryAuthor->getGivenName($this->locale),
                    $primaryAuthor->getFamilyName($this->locale),
                    $email,
                    $authorGroupId
                );
                Repo::stageAssignment()->build($submissionId, $authorGroupId, $user->getId());
            }
        }

        // Fallback: if no primary author with user, use config email (enables author responses)
        $hasAuthorAssignment = StageAssignment::withSubmissionIds([$submissionId])
            ->withRoleIds([Role::ROLE_ID_AUTHOR])
            ->withStageIds([WORKFLOW_STAGE_ID_EXTERNAL_REVIEW])
            ->exists();
        if (!$hasAuthorAssignment) {
            $fallbackUser = Repo::user()->getByEmail($config->getEmail(), true);
            if ($fallbackUser) {
                Repo::stageAssignment()->build($submissionId, $authorGroupId, $fallbackUser->getId());
            }
        }

        // Assign editor to external review (for participant list, edit decisions)
        $editorGroupIdForReview = $config->getEditorGroupIdForStage(WORKFLOW_STAGE_ID_EXTERNAL_REVIEW);
        if ($editorGroupIdForReview) {
            Repo::stageAssignment()->build($submissionId, $editorGroupIdForReview, $config->getEditor()->getId());
        }
    }

    /**
     * Creates OJS reviews for each version based on the database query
     */
    public function createReviewsForVersions(Submission $submission): void
    {
        $publications = $submission->getPublishedPublications();
        $bestDoi = null;
        foreach ($publications as $publication) {
            $bestDoi = $publication->getDoi();
            // Attempt to look for a DOI created by ORE
            if (mb_stripos($bestDoi, 'europe') !== false) {
                break;
            }
        }

        if (!$bestDoi) {
            return;
        }

        $doiParts = explode('.', $bestDoi);
        $articleId = array_slice($doiParts, -2, 1)[0];

        // Execute the query to get all reviews
        $reviews = $this->connection->select(
            "SELECT
                coreferees.content AS coreferees,
                re.first_name,
                re.last_name,
                re.email,
                r.comment,
                r.published_date,
                r.decision,
                v.id AS version_id,
                r.id AS review_id,
                v.version_number,
                r.doi,
                r.areas_of_research,
                r.competing_interests,
                ar.id AS article_referee_id
            FROM f1000r_version AS v
            JOIN f1000r_report AS r ON r.version_id = v.id
            JOIN f1000r_referee_report AS rr ON rr.report_id = r.id AND rr.is_coreferee = false
            JOIN f1000r_referee AS re ON re.id = rr.referee_id
            LEFT JOIN f1000r_affiliation AS a ON a.id = re.affiliation_id
            LEFT JOIN f1000r_article_referee AS ar ON ar.article_id = v.article_id AND ar.referee_id = rr.referee_id
            LEFT JOIN LATERAL (
                SELECT json_agg(coreferee) AS content FROM (
                    SELECT json_build_object(
                        'name', re.first_name,
                        'surname', re.last_name,
                        'affiliation', STRING_AGG(
                            CONCAT(
                                i.name,
                                CASE WHEN a.place <> '' THEN ', ' || a.place ELSE '' END,
                                CASE WHEN a.state <> '' THEN ', ' || a.state ELSE '' END
                            ),
                            '; ' ORDER BY ara.id
                        ),
                        'orcid', o.orcid,
                        'email', re.email
                    ) AS coreferee
                    FROM f1000r_referee_report rr
                    JOIN f1000r_referee AS re ON re.id = rr.referee_id
                    LEFT JOIN f1000r_article_referee AS ar ON ar.article_id = v.article_id AND ar.referee_id = rr.referee_id
                    LEFT JOIN f1000r_article_referee_affiliation AS ara ON ara.article_referee_id = ar.id
                    LEFT JOIN f1000r_affiliation a ON a.id = ara.affiliation_id
                    LEFT JOIN bible_institution i ON i.id = a.institution_id
                    LEFT JOIN orcid_access_data AS o ON o.email = re.email
                    WHERE rr.report_id = r.id AND rr.is_coreferee = true
                    GROUP BY re.first_name, re.last_name, rr.position, o.orcid, re.email
                    ORDER BY rr.position
                )
            ) AS coreferees ON true
            WHERE v.article_id = ?
            AND v.version_number = ?
            AND r.decision IS NOT NULL
            AND r.status = 'PUBLISHED'
            ORDER BY v.id, rr.position, r.id
        ", [$articleId, $this->versionNumber]);

        if (empty($reviews)) {
            return;
        }

        // Ensure stage assignments for author, editor (and reviewer via ReviewAssignment) in external review
        $this->assignStageAssignments($submission);

        // Group reviews by version_number (which determines the review round)
        $reviewsByVersionNumber = [];
        foreach ($reviews as $review) {
            $versionNumber = (int) $review->version_number;
            if (!isset($reviewsByVersionNumber[$versionNumber])) {
                $reviewsByVersionNumber[$versionNumber] = [];
            }
            $reviewsByVersionNumber[$versionNumber][] = $review;
        }

        // Get reviewer user group ID
        $reviewerUserGroups = Repo::userGroup()->getByRoleIds([Role::ROLE_ID_REVIEWER], $this->contextId);
        $reviewerGroupId = $reviewerUserGroups->first()?->id;
        if (!$reviewerGroupId) {
            throw new Exception('Reviewer user group not found');
        }

        // Get review round DAO
        $reviewRoundDao = DAORegistry::getDAO('ReviewRoundDAO'); /** @var ReviewRoundDAO $reviewRoundDao */

        // Process each version (grouped by version_number)
        foreach ($reviewsByVersionNumber as $versionNumber => $versionReviews) {
            $review = reset($versionReviews);
            // Find the publication for this version
            $publication = null;
            /** @var Publication $pub */
            foreach ($publications as $pub) {
                if ($pub->getData('seq') == $versionNumber) {
                    $publication = $pub;
                    break;
                }
            }

            if (!$publication) {
                error_log("Publication not found for version number {$versionNumber}, skipping reviews");
                continue;
            }

            // Create a review round for this version using version_number as the round number
            $reviewRound = $reviewRoundDao->build(
                $submission->getId(),
                $publication->getId(),
                WORKFLOW_STAGE_ID_EXTERNAL_REVIEW,
                $versionNumber
            );

            // Group reviews by review_id to handle multiple reviewers per review
            $reviewsByReviewId = [];
            foreach ($versionReviews as $review) {
                $reviewId = $review->review_id;
                if (!isset($reviewsByReviewId[$reviewId])) {
                    $reviewsByReviewId[$reviewId] = [
                        'reviewData' => $review,
                        'reviewers' => []
                    ];
                }
                $reviewsByReviewId[$reviewId]['reviewers'][] = $review;
            }

            // Process each unique review
            foreach ($reviewsByReviewId as $reviewId => $reviewData) {
                $reviewRecord = $reviewData['reviewData'];
                $reviewers = $reviewData['reviewers'];

                // Create review assignments for each reviewer in this review
                foreach ($reviewers as $reviewerData) {
                    $reviewerUser = $this->getOrCreateUser(
                        $reviewerData->first_name,
                        $reviewerData->last_name,
                        $reviewerData->email,
                        $reviewerGroupId
                    );

                    $reviewerRecommendationId = $this->getReviewerRecommendationIdForDecision($reviewRecord->decision ?? null);

                    $doi = $reviewRecord->doi ? Repo::doi()->getCollector()->filterByIdentifier($reviewRecord->doi)->getMany()->first() : null;
                    if (!$doi && $reviewRecord->doi) {
                        $doi = Repo::doi()->newDataObject([
                            'doi' => $reviewRecord->doi,
                            'contextId' => $this->configuration->getContext()->getId()
                        ]);
                        Repo::doi()->add($doi);
                        $doi = Repo::doi()->get($doi->getId());
                    }
                    // Create new review assignment
                    $reviewAssignment = Repo::reviewAssignment()->newDataObject([
                        'submissionId' => $submission->getId(),
                        'reviewerId' => $reviewerUser->getId(),
                        'reviewRoundId' => $reviewRound->getId(),
                        'stageId' => WORKFLOW_STAGE_ID_EXTERNAL_REVIEW,
                        'round' => (int) $reviewRecord->version_number,
                        'dateAssigned' => Core::getCurrentDate(),
                        'dateCompleted' => $reviewRecord->published_date
                            ? $this->parseDateString($reviewRecord->published_date)?->format(static::DATETIME_FORMAT)
                            : Core::getCurrentDate(),
                        'status' => ReviewAssignment::REVIEW_ASSIGNMENT_STATUS_COMPLETE,
                        'dateConfirmed' => Core::getCurrentDate(),
                        'dateAcknowledged' => Core::getCurrentDate(),
                        'reviewerRecommendationId' => $reviewerRecommendationId,
                        'competingInterestsDeclared' => 1,
                        'competingInterests' => $reviewRecord->competing_interests,
                        'reviewMethod' => ReviewAssignment::SUBMISSION_REVIEW_METHOD_OPEN,
                        'isReviewPubliclyVisible' => 1,
                        'doiId' => $doi?->getId()
                    ]);

                    $reviewAssignmentId = Repo::reviewAssignment()->add($reviewAssignment);
                    $reviewAssignment = Repo::reviewAssignment()->get($reviewAssignmentId);

                    if (trim($reviewRecord->coreferees)) {
                        json_decode($reviewRecord->coreferees, true, 512, JSON_THROW_ON_ERROR);
                        $coreferees = array_map(function ($coreferee) {
                            $orcid = $coreferee['orcid'] ?? ($coreferee['email'] ? DB::scalar("
                                SELECT COALESCE(
                                    (
                                        SELECT s.setting_value
                                        FROM users u
                                        JOIN user_settings s ON s.user_id = u.user_id AND s.setting_name = 'orcid'
                                        WHERE u.email = ?
                                        LIMIT 1
                                    ),
                                    (
                                        SELECT s.setting_value
                                        FROM authors a
                                        JOIN author_settings s ON s.author_id = a.author_id AND s.setting_name = 'orcid'
                                        WHERE a.email = ?
                                        LIMIT 1
                                    )
                                ) AS orcid
                            ", [$coreferee['email'], $coreferee['email']]) : null);

                            return ($orcid ? '<a href="https://orcid.org/' . $orcid . '" target="_blank" class="d-flex align-items-center gap-1 text-decoration-none" aria-label="ORCID record of ' . htmlspecialchars($coreferee['name']) . '">' : '') . '
                                <span class="ore-grey-900 ore-label-small">
                                    ' . htmlspecialchars($coreferee['name'] . ' ' . $coreferee['surname']) . ($coreferee['affiliation'] ? ', ' . htmlspecialchars($coreferee['affiliation']) : '') . '
                                </span>
                                ' . ($orcid ? '
                                <span class="ore-label-small ore-tertiary-900">
                                    <svg class="orcid_icon" aria-hidden="true" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path fill-rule="evenodd" clip-rule="evenodd" d="M29.474 16c0 7.442-6.032 13.474-13.474 13.474S2.526 23.442 2.526 16 8.558 2.526 16 2.526 29.474 8.558 29.474 16Z" fill="#fff"></path>
                                        <path fill-rule="evenodd" clip-rule="evenodd" d="M32 16c0 8.837-7.163 16-16 16S0 24.837 0 16 7.163 0 16 0s16 7.163 16 16ZM16 29.474c7.442 0 13.474-6.032 13.474-13.474S23.442 2.526 16 2.526 2.526 8.558 2.526 16 8.558 29.474 16 29.474Z" fill="#7FAA26"></path>
                                        <path fill-rule="evenodd" clip-rule="evenodd" d="M18.22 10.973h-4.547v11.6h4.569c3.8 0 6.133-2.82 6.133-5.8 0-1.365-.469-2.815-1.478-3.925-1.013-1.115-2.557-1.875-4.676-1.875Zm-.177 9.732h-2.347v-7.864h2.264c1.521 0 2.603.46 3.304 1.167.703.709 1.046 1.688 1.046 2.765 0 .654-.2 1.641-.83 2.46-.621.808-1.677 1.473-3.437 1.473Zm-.083-8.073c3.13 0 4.558 1.898 4.558 4.141 0-2.243-1.429-4.141-4.558-4.141h-2.472 2.472Zm6.205 4.017.001.124c0 2.869-2.242 5.591-5.924 5.591h-4.36V11.182v11.182h4.36c3.682 0 5.924-2.722 5.924-5.591l-.001-.124ZM9.5 11.005v11.588h2.024V11.005H9.5Zm1.815.208v11.172-11.172H9.71h1.606ZM10.512 10.15c.7 0 1.262-.575 1.262-1.263 0-.687-.561-1.262-1.262-1.262-.7 0-1.262.563-1.262 1.262 0 .688.561 1.262 1.262 1.262Zm.614-.408a1.044 1.044 0 0 0 0 0Z" fill="#7FAA26"></path>
                                    </svg>
                                </span>
                            </a>' : '');
                        }, $reviewRecord->coreferees);
                        $reviewRecord->comment = '<strong>The review was co-authored by:</strong><br>' . implode('<br>', $coreferees) . '<br><br>' . $reviewRecord->comment;
                    }

                    $questions = $this->connection->select("select
                        q.question_description,
                        CASE r.result
                            WHEN 'np' THEN 'Not applicable'
                            WHEN 'y' THEN 'Yes'
                            WHEN 'p' THEN 'Partly'
                            WHEN 'n' THEN 'No'
                            WHEN 'd' THEN 'No source data required'
                            WHEN 'nc' THEN 'I cannot comment. A qualified statistician is required'
                        END AS result
                    from f1000r_article_question_result r
                    inner join f1000r_article_question q on q.id = r.question_id
                    inner join f1000r_version v on v.id = r.version_id
                    where r.version_id = ?
                    and r.article_referee_id = ?
                    order by q.position
                    ", [$reviewRecord->version_id, $reviewRecord->article_referee_id]);
                    $questions = array_map(fn ($question) => "<strong>{$question->question_description}</strong><br>{$question->result}", $questions);
                    if (!empty($questions)) {
                        $reviewRecord->comment .= '<br><br>' . implode('<br><br>', $questions);
                    }

                    if (trim($reviewRecord->areas_of_research)) {
                        $reviewRecord->comment .= '<br><br>' . '<strong>Reviewer Expertise:</strong><br>' . $reviewRecord->areas_of_research;
                    }

                    // Create review comment if provided
                    if (!empty($reviewRecord->comment)) {
                        $submissionCommentDao = DAORegistry::getDAO('SubmissionCommentDAO'); /** @var SubmissionCommentDAO $submissionCommentDao */
                        $comment = $submissionCommentDao->newDataObject();
                        $comment->setCommentType(SubmissionComment::COMMENT_TYPE_PEER_REVIEW);
                        $comment->setRoleId(Role::ROLE_ID_REVIEWER);
                        $comment->setAssocId($reviewAssignment->getId());
                        $comment->setSubmissionId($reviewAssignment->getSubmissionId());
                        $comment->setAuthorId($reviewAssignment->getReviewerId());
                        $comment->setComments($reviewRecord->comment);
                        $comment->setCommentTitle('');
                        $comment->setViewable(true);
                        $comment->setDatePosted(Core::getCurrentDate());
                        $submissionCommentDao->insertObject($comment);
                    }
                }

                // Create an edit decision if we have a valid decision value
                $this->createEditDecision($submission, $publication, $reviewRound, Decision::ACCEPT, $reviewRecord->published_date);
            }

            // Import author responses: approved comments linked to reports in this round
            $reportIds = array_map('intval', array_keys($reviewsByReviewId));
            if (!empty($reportIds)) {
                $this->importAuthorResponsesForRound($submission, $publication, $reviewRound, $reportIds);
            }
        }
    }

    /**
     * Fetches approved comments from F1000R for the given report IDs (f1000r_comment_report.report_id).
     * Only comments in f1000r_comment with status = 'APPROVED' are returned.
     * Each item has: text, creationDate, lastUpdated (raw from PostgreSQL).
     *
     * @param int[] $reportIds
     * @return list<object{text: string, creationDate: mixed, lastUpdated: mixed}>
     */
    private function getApprovedCommentsForReportIds(array $reportIds): array
    {
        if (empty($reportIds)) {
            return [];
        }

        $rows = $this->connection->table('f1000r_comment_report as cr')
            ->join('f1000r_comment as c', 'c.id', '=', 'cr.comment_id')
            ->whereIn('cr.report_id', $reportIds)
            ->where('c.status', '=', 'APPROVED')
            ->orderBy('c.creation_date')
            ->select(['c.text', 'c.creation_date', 'c.last_updated'])
            ->get();

        $out = [];
        foreach ($rows as $row) {
            $text = $row->text !== null ? trim((string) $row->text) : '';
            if ($text !== '') {
                $out[] = (object) [
                    'text' => $row->text,
                    'creationDate' => $row->creation_date,
                    'lastUpdated' => $row->last_updated,
                ];
            }
        }
        return $out;
    }

    /**
     * Creates or replaces author response(s) for the given review round using F1000R approved comments.
     * One AuthorResponse is created per approved comment, with createdAt/updatedAt from the PostgreSQL comment.
     */
    private function importAuthorResponsesForRound(Submission $submission, Publication $publication, ReviewRound $reviewRound, array $reportIds): void
    {
        $approvedComments = $this->getApprovedCommentsForReportIds($reportIds);
        if (empty($approvedComments)) {
            return;
        }

        // Remove existing author responses for this round so re-import stays in sync
        AuthorResponse::withReviewRoundIds([$reviewRound->getId()])->delete();

        $authorStageAssignment = StageAssignment::withSubmissionIds([$submission->getId()])
            ->withRoleIds([Role::ROLE_ID_AUTHOR])
            ->withStageIds([$reviewRound->getStageId()])
            ->get()
            ->first();
        $authorUserId = $authorStageAssignment !== null ? $authorStageAssignment->userId : null;

        if ($authorUserId === null) {
            return;
        }

        $authors = $publication->getData('authors');
        $associatedAuthorIds = $authors ? $authors->map(fn ($a) => $a->getId())->all() : [];

        foreach ($approvedComments as $comment) {
            $createdAt = $this->formatCommentDateForOjs($comment->creationDate);
            $updatedAt = $this->formatCommentDateForOjs($comment->lastUpdated ?? $comment->creationDate);

            $reviewResponse = AuthorResponse::create([
                'reviewRoundId' => $reviewRound->getId(),
                'authorResponse' => [$this->locale => $comment->text],
                'userId' => $authorUserId,
            ]);

            // Set createdAt and updatedAt from F1000R comment (AuthorResponse fillable does not include them)
            DB::table('review_round_author_responses')
                ->where('response_id', $reviewResponse->id)
                ->update([
                    'created_at' => $createdAt,
                    'updated_at' => $updatedAt,
                ]);

            if (!empty($associatedAuthorIds)) {
                $reviewResponse->associateAuthorsToResponse($associatedAuthorIds);
            }
        }
    }

    /**
     * Formats a PostgreSQL timestamp (or string) to OJS datetime string for created_at/updated_at.
     */
    private function formatCommentDateForOjs(mixed $dateValue): string
    {
        if ($dateValue === null) {
            return Core::getCurrentDate();
        }
        if ($dateValue instanceof \DateTimeInterface) {
            return $dateValue->format(static::DATETIME_FORMAT);
        }
        $parsed = $this->parseDateString((string) $dateValue);
        return $parsed ? $parsed->format(static::DATETIME_FORMAT) : Core::getCurrentDate();
    }

    /**
     * Resolve reviewerRecommendationId for the given F1000R decision.
     * Finds the ReviewerRecommendation for the context whose localized title matches the mapped recommendation title.
     *
     * @param string|null $decision F1000R decision (APPROVED, APPROVED_WITH_RESERVATIONS, NOT_APPROVED)
     * @return int|null reviewer_recommendation_id or null if not found / no decision
     */
    private function getReviewerRecommendationIdForDecision(?string $decision): ?int
    {
        if ($decision === null || $decision === '') {
            return null;
        }

        $recommendationTitle = [
            'APPROVED' => 'Approved',
            'APPROVED_WITH_RESERVATIONS' => 'Approved with Reservations',
            'NOT_APPROVED' => 'Not Approved',
        ][$decision] ?? null;
        if ($recommendationTitle === null) {
            return null;
        }

        $recommendations = ReviewerRecommendation::query()
            ->withContextId($this->contextId)
            ->get();

        foreach ($recommendations as $recommendation) {
            $title = $recommendation->getLocalizedData('title');
            if ($title === $recommendationTitle) {
                return (int) $recommendation->getKey();
            }
        }

        return null;
    }

    /**
     * Gets or creates an author user for stage assignments
     */
    private function getOrCreateUser(?string $firstName, ?string $lastName, ?string $email, int $userGroupId): ?User
    {
        if (!$email) {
            return null;
        }

        $user = Repo::user()->getByEmail($email, true);
        if ($user) {
            if (!Repo::userGroup()->userInGroup($user->getId(), $userGroupId)) {
                Repo::userGroup()->assignUserToGroup($user->getId(), $userGroupId);
            }
            return $user;
        }

        $user = Repo::user()->newDataObject();
        $user->setGivenName($firstName ?? '', $this->locale);
        $user->setFamilyName($lastName ?? '', $this->locale);
        $user->setEmail($email);
        $user->setUsername($email);
        $user->setDateRegistered(Core::getCurrentDate());
        $user->setInlineHelp(1);
        $user->setPassword(Validation::encryptCredentials($email, Str::random(16)));

        $userId = Repo::user()->add($user);
        if (!$userId) {
            return null;
        }

        Repo::userGroup()->assignUserToGroup($userId, $userGroupId);
        return Repo::user()->get($userId);
    }

    /**
     * Creates an edit decision for the review
     *
     * @param Submission $submission
     * @param Publication $publication
     * @param \PKP\submission\reviewRound\ReviewRound $reviewRound
     * @param int $decision
     * @param string|null $dateDecided
     */
    private function createEditDecision(Submission $submission, Publication $publication, $reviewRound, int $decision, ?string $dateDecided): void
    {
        // Check if decision already exists for this review round
        $existingDecisions = Repo::decision()->getCollector()
            ->filterBySubmissionIds([$submission->getId()])
            ->filterByReviewRoundIds([$reviewRound->getId()])
            ->filterByDecisionTypes([$decision])
            ->getMany();

        if ($existingDecisions->isNotEmpty()) {
            // Decision already exists, skip
            return;
        }

        $editor = $this->configuration->getEditor();
        $dateDecidedObj = $dateDecided
            ? $this->parseDateString($dateDecided)
            : new DateTimeImmutable();

        if (!$dateDecidedObj) {
            $dateDecidedObj = new DateTimeImmutable();
        }

        // Get decision type
        $decisionTypes = Repo::decision()->getDecisionTypes();
        $decisionType = null;
        foreach ($decisionTypes as $dt) {
            if ($dt->getDecision() === $decision) {
                $decisionType = $dt;
                break;
            }
        }

        if (!$decisionType) {
            error_log("Decision type not found for decision constant: {$decision}");
            return;
        }

        // Create decision object
        $decisionObj = Repo::decision()->newDataObject([
            'submissionId' => $submission->getId(),
            'publicationId' => $publication->getId(),
            'reviewRoundId' => $reviewRound->getId(),
            'decision' => $decision,
            'editorId' => $editor->getId(),
            'stageId' => $decisionType->getStageId(),
            'dateDecided' => $dateDecidedObj->format(static::DATETIME_FORMAT),
        ]);

        Repo::decision()->add($decisionObj);
    }
}
