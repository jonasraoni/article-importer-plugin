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
    /** @var int The issue's volume */
    private int $_volume = 0;
    /** @var string The issue's number */
    private int $_issue = 0;
    /** @var string The article's number */
    private int $_article = 0;

    /**
     * Constructor
     *
     * @param SplFileInfo $directory The article directory
     */
    public function __construct(SplFileInfo $directory)
    {
        $this->_directory = $directory;
        foreach ([&$this->_article, &$this->_issue, &$this->_volume] as &$item) {
            $item = $directory->getFilename();
            $directory = $directory->getPathInfo();
        }
    }

    /**
     * Gets all available versions as a Generator
     *
     * @return iterable<ArticleVersion> Yields ArticleVersion instances
     */
    public function getVersions(): Generator
    {
        foreach (glob("{$this->_directory->getPathname()}/*", GLOB_ONLYDIR) as $versionDir) {
            yield new ArticleVersion($this, new SplFileInfo($versionDir));
        }
    }

    /**
     * Retrieves the issue volume
     */
    public function getVolume(): int
    {
        return (int) $this->_volume;
    }

    /**
     * Retrieves the issue number
     */
    public function getIssue(): string
    {
        return $this->_issue;
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
        $approvals = 0;
        $approvalsWithReservations = 0;
        $versionMajor = 0;
        $previouslyPassedReview = false;
        $processed = false;
        foreach ($this->getVersions() as $version) {
            $parser = $version->process($configuration);
            $publication = $parser->getPublication();
            $doi = $parser->getPublicIds()['doi'] ?? null;
            $doi = explode('.', $doi);
            $version = array_pop($doi);
            $articleId = array_pop($doi);
            $reports = $oreConnection
                ->table('f1000r_report as r')
                ->leftJoin('f1000r_version as v', 'r.version_id', '=', 'v.id')
                ->where('v.article_id', $articleId)
                ->where('v.version_number', $version)
                ->where('v.status', 'PUBLISHED')
                ->where('r.status', 'PUBLISHED')
                ->select('r.decision')
                ->get();

            foreach ($reports as $report) {
                match ($report->decision) {
                    'APPROVED' => $approvals++,
                    'APPROVED_WITH_RESERVATIONS' => $approvalsWithReservations++,
                    default => null
                };
            }
            $passedReview = $approvals >= 2 || ($approvals >= 1 && $approvalsWithReservations >= 2);
            ++$versionMajor;
            if ($passedReview && !$previouslyPassedReview) {
                $previouslyPassedReview = true;
                $publication->setVersion(new PublicationVersionInfo(VersionStage::PUBLISHED_MANUSCRIPT_UNDER_REVIEW, $versionMajor, 0));
                // Publishes the article
                $doi = $publication->getData('doiObject');
                $publication->setData('doiObject', null);
                Repo::publication()->publish($publication);
                $versionMajor = 1;
                $publicationId = Repo::publication()->version($publication, VersionStage::VERSION_OF_RECORD, false);
                $publication = Repo::publication()->get($publicationId);
                $publication->setData('doiObject', $doi);
            }

            $publication->setVersion(new PublicationVersionInfo($passedReview ? VersionStage::VERSION_OF_RECORD : VersionStage::PUBLISHED_MANUSCRIPT_UNDER_REVIEW, $versionMajor, 0));
            // Publishes the article
            Repo::publication()->publish($publication);

            $processed = true;
        }

        if (!$processed) {
            throw new ArticleSkippedException('No versions were processed');
        }
    }
}
