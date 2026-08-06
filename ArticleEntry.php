<?php
/**
 * @file ArticleEntry.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleEntry
 * @brief Represents an article entry with its basic identification and version management
 */

namespace APP\plugins\importexport\articleImporter;

use APP\facades\Repo;
use APP\plugins\importexport\articleImporter\exceptions\ArticleSkippedException;
use APP\publication\enums\VersionStage;
use Generator;
use PKP\publication\helpers\PublicationVersionInfo;
use SplFileInfo;

class ArticleEntry
{
    /** @var SplFileInfo The article directory */
    private SplFileInfo $_directory;
    /** @var ?int The issue's volume, null when the volume level is absent */
    private ?int $_volume;
    /** @var ?string The issue's number, null when the number level is absent */
    private ?string $_number;
    /** @var string The article's number */
    private string $_article;
    /** @var bool Whether the article holds its versions in sub-folders */
    private bool $_hasVersion = true;

    /**
     * Constructor
     *
     * @param SplFileInfo $directory The article directory
     * @param ?int $volume The issue's volume, or null when the volume level is absent
     * @param ?string $number The issue's number, or null when the number level is absent
     * @param string $article The article's number
     * @param bool $hasVersion Whether versions are kept in sub-folders. When false, the article directory itself is the single version.
     */
    public function __construct(SplFileInfo $directory, ?int $volume, ?string $number, string $article, bool $hasVersion = true)
    {
        $this->_directory = $directory;
        $this->_volume = $volume;
        $this->_number = $number;
        $this->_article = $article;
        $this->_hasVersion = $hasVersion;
    }

    /**
     * Gets all available versions as a Generator
     *
     * @return iterable<ArticleVersion> Yields ArticleVersion instances
     */
    public function getVersions(): Generator
    {
        // When versions aren't foldered, the article directory itself is the single (first) version
        if (!$this->_hasVersion) {
            yield new ArticleVersion($this, $this->_directory, 1);
            return;
        }
        foreach (glob("{$this->_directory->getPathname()}/*", GLOB_ONLYDIR) as $versionDir) {
            yield new ArticleVersion($this, new SplFileInfo($versionDir));
        }
    }

    /**
     * Retrieves the article directory
     */
    public function getDirectory(): SplFileInfo
    {
        return $this->_directory;
    }

    /**
     * Retrieves the directory that represents the issue (the parent of the article directory).
     * Used to locate issue-level assets such as the cover image.
     * Returns null when neither the volume nor the number level is present (continuous publishing, no issue).
     */
    public function getIssueDirectory(): ?SplFileInfo
    {
        if ($this->_volume === null && $this->_number === null) {
            return null;
        }
        return $this->_directory->getPathInfo();
    }

    /**
     * Retrieves the issue volume, or null when the volume level is absent
     */
    public function getVolume(): ?int
    {
        return $this->_volume;
    }

    /**
     * Retrieves the issue number, or null when the number level is absent
     */
    public function getIssue(): ?string
    {
        return $this->_number;
    }

    /**
     * Retrieves the issue number, or null when the number level is absent
     */
    public function getNumber(): ?string
    {
        return $this->_number;
    }

    /**
     * Retrieves the article number
     */
    public function getArticle(): string
    {
        return $this->_article;
    }

    /**
     * Processes the article
     */
    public function process(Configuration $configuration): void
    {
        $oreConnection = ArticleImporterPlugin::getOreConnection();
        $latestDecisionByReferee = [];
        $versionMajor = 0;
        $previouslyPassedReview = false;
        $processed = false;
        foreach ($this->getVersions() as $version) {
            $parser = $version->process($configuration);
            $publication = $parser->getPublication();
            $doi = $parser->getPublicIds()['doi'] ?? null;
            $doi = explode('.', $doi);
            $version = (int) array_pop($doi);
            $articleId = (int) array_pop($doi);
            $reports = $oreConnection
                ->table('f1000r_report as r')
                ->join('f1000r_version as v', 'r.version_id', '=', 'v.id')
                ->join('f1000r_referee_report as rr', function ($join) {
                    $join->on('rr.report_id', '=', 'r.id')
                        ->where('rr.is_coreferee', false);
                })
                ->where('v.article_id', $articleId)
                ->where('v.version_number', $version)
                ->where('v.status', 'PUBLISHED')
                ->where('r.status', 'PUBLISHED')
                ->select('r.decision')
                ->get();

            foreach ($reports as $report) {
                $latestDecisionByReferee[(int) $report->referee_id] = $report->decision;
            }

            $approvals = 0;
            $approvalsWithReservations = 0;
            foreach ($latestDecisionByReferee as $decision) {
                match ($decision) {
                    'APPROVED' => $approvals++,
                    'APPROVED_WITH_RESERVATIONS' => $approvalsWithReservations++,
                    default => null
                };
            }
            $passedReview = $approvals >= 2 || ($approvals >= 1 && $approvalsWithReservations >= 2);
            ++$versionMajor;
            if ($passedReview && !$previouslyPassedReview) {
                $previouslyPassedReview = true;
                $versionMajor = 1;
            }

            $summaryOfChanges = $oreConnection
                ->table('f1000r_version as v')
                ->where('v.article_id', $articleId)
                ->where('v.version_number', $version)
                ->where('v.status', 'PUBLISHED')
                ->value('v.update_text');

            if ($summaryOfChanges) {
                $publication->setData('summaryOfChanges', $summaryOfChanges, 'en');
            }

            $publication->setVersion(new PublicationVersionInfo($passedReview ? VersionStage::VERSION_OF_RECORD : VersionStage::PUBLISHED_MANUSCRIPT_UNDER_REVIEW, $versionMajor, 0));
            // Publishes the article
            if ($publication->getData('datePublished')) {
                Repo::publication()->publish($publication);
            }

            $reviewImporter = new ReviewImporter($configuration, $oreConnection, $version);
            $reviewImporter->createReviewsForVersions($parser->getSubmission(), $parser);

            $processed = true;
        }

        if (!$processed) {
            throw new ArticleSkippedException('No versions were processed');
        }
    }
}
