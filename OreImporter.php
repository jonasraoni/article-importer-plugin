<?php
/**
 * @file JatsArrayImporter.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class JatsArrayImporter
 * @brief JATS import logic that queries PostgreSQL database directly

 */

/*
SELECT 'SELECT ' ||
-- STRING_AGG(column_name, ', ')
quote_literal(table_name)
|| ' FROM ' || table_name || ' WHERE ' ||
STRING_AGG('"' || column_name || '"' || ' ILIKE ' || quote_literal('%0000-0002-6769-1999%'), ' OR ') || ' UNION '
FROM information_schema.columns
WHERE data_type IN ('character', 'text', 'character varying') AND table_schema = 'public'
GROUP BY table_name;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
and table_name ilike '%contributor_role%';
*/

namespace APP\plugins\importexport\articleImporter;

use APP\author\Author;
use APP\plugins\importexport\articleImporter\Funders;
use APP\publication\enums\VersionStage;
use APP\publication\Publication;
use APP\section\Section;
use APP\submission\Submission;
use APP\core\Services;
use APP\core\Application;
use APP\facades\Repo;
use DateTimeImmutable;
use Exception;
use Illuminate\Database\Connection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use PKP\publication\helpers\PublicationVersionInfo;
use PKP\Services\PKPFileService;
use PKP\core\Core;
use PKP\i18n\LocaleConversion;
use PKP\submissionFile\SubmissionFile;
use PKP\controlledVocab\ControlledVocab;
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
use PKP\statistics\PKPStatisticsHelper;
use SplFileInfo;

class OreImporter
{
    use EntityManager;

    public const DATETIME_FORMAT = 'Y-m-d H:i:s';

    /** @var Configuration Configuration */
    private Configuration $_configuration;
    /** @var Connection Database connection */
    private Connection $_connection;
    /** @var int|string Article ID */
    private $_articleId;
    /** @var object Cached article record */
    private ?object $_article = null;
    /** @var object Cached version record */
    private ?object $_version = null;
    /** @var int Context ID */
    private int $_contextId;
    /** @var string Default locale */
    private string $_locale;
    /** @var string[] */
    private array $_usedLocales = [];
    /** @var Section Section instance */
    private ?Section $_section = null;
    /** @var Submission Submission instance */
    private ?Submission $_submission = null;
    /** @var int Keeps the count of inserted authors */
    /** @var Publication Publication instance */
    private ?Publication $_publication = null;
    private int $_authorCount = 0;

    /**
     * Constructor
     */
    public function __construct(Configuration $configuration, Connection $connection, $articleId)
    {
        $this->_configuration = $configuration;
        $this->_connection = $connection;
        $this->_articleId = $articleId;
        $context = $this->_configuration->getContext();
        $this->_contextId = $context->getId();
        $this->_locale = $context->getPrimaryLocale();

        $submissions = [Repo::submission()->get($this->_articleId)];
        foreach ($submissions as $submission) {
            $this->createReviewsForVersions($submission);
        }
    }

    /**
     * Import all articles (optionally filtered)
     *
     * @param Configuration $configuration
     * @param Connection $connection
     * @param array $filters Optional filters (e.g., ['status' => 'PUBLISHED'])
     */
    public static function importAllArticles(Configuration $configuration, Connection $connection, array $filters = []): void
    {
        $query = $connection->table('f1000r_article')->select('id');

        foreach ($filters as $key => $value) {
            $query->where($key, $value);
        }

        $articleIds = $query->pluck('id')->toArray();

        foreach ($articleIds as $articleId) {
            try {
                $importer = new self($configuration, $connection, $articleId);
                $importer->execute();
            } catch (Exception $e) {
                error_log("Failed to import article {$articleId}: " . $e->getMessage());
            }
        }
        $orcids = $connection->table('orcid_access_data')->get();
        foreach ($orcids as $orcid) {
            $authorIds = DB::table('author_settings')->where('setting_name', 'orcid')
                ->where('setting_value', 'https://orcid.org' . $orcid->orcid)
                ->get()
                ->pluck('author_id')
                ->toArray();
            foreach ($authorIds as $authorId) {
                DB::table('author_settings')
                    ->where('author_id', $authorId)
                    ->update([
                        'orcidIsVerified' => 1,
                        'orcidAccessToken' => $orcid->access_token,
                        'orcidAccessScope' => $orcid->access_scope,
                        'orcidRefreshToken' => $orcid->refresh_token,
                        'orcidAccessExpiresOn' => $orcid->expires_in,
                    ]);
            }
        }
    }

    /**
     * Executes the import for all versions
     *
     * @return Publication[] Array of imported publications (one per version)
     * @throws Exception Throws when something goes wrong, and an attempt to revert the actions will be performed
     */
    public function execute(): array
    {
        $publications = [];
        $versions = $this->getAllVersions();

        if (empty($versions)) {
            throw new Exception("No published versions found for article {$this->_articleId}");
        }

        $source_publication = null;
        foreach ($versions as $version) {
            try {
                $this->_version = $version;
                $this->_publication = null;
                $this->_authorCount = 0; // Reset author count for each version
                $version = $this->getVersion();
                $this->_locale = $this->getLocale();
                $publications[] = $this->buildPublication($source_publication);
                $source_publication = $publications[array_key_last($publications)];
            } catch (Exception $e) {
                $this->rollback();
                throw $e;
            }
        }

        $this->assignOreMetricsToLatestVersion($publications);

        return $publications;
    }

    /**
     * Fetch article metrics from Open Research Europe API.
     * URL format: https://open-research-europe.ec.europa.eu/api/metrics/total/F1000_RESEARCH/ARTICLE/{articleId}
     *
     * @return array|null Decoded JSON with articleId, numberOfViews, numberOfPdfDownloads, numberOfXmlDownloads, etc., or null on failure
     */
    private function fetchOreMetrics(int $articleId): ?array
    {
        $url = 'https://open-research-europe.ec.europa.eu/api/metrics/total/F1000_RESEARCH/ARTICLE/' . (int) $articleId;
        $context = stream_context_create([
            'http' => [
                'timeout' => 10,
                'user_agent' => 'OreImporter/OJS',
            ],
        ]);
        $raw = @file_get_contents($url, false, $context);
        if ($raw === false) {
            return null;
        }
        $data = json_decode($raw, true);
        return is_array($data) ? $data : null;
    }

    /**
     * Assign ORE API metrics to the submission, attributed to the latest version only (to avoid distorting totals).
     * Inserts into metrics_submission: article views, PDF galley views, XML galley views.
     */
    private function assignOreMetricsToLatestVersion(Publication $latestPublication, int $articleId): void
    {
        $metrics = $this->fetchOreMetrics($articleId);
        if (!$metrics) {
            return;
        }

        $views = (int) ($metrics['numberOfViews'] ?? 0);
        $pdfDownloads = (int) ($metrics['numberOfPdfDownloads'] ?? 0);
        $xmlDownloads = (int) ($metrics['numberOfXmlDownloads'] ?? 0);
        if ($views === 0 && $pdfDownloads === 0 && $xmlDownloads === 0) {
            return;
        }

        $submissionId = (int) $latestPublication->getData('submissionId');
        $contextId = $this->_contextId;
        $date = $latestPublication->getData('datePublished');
        $loadId = 'ore_import_' . $articleId . '_' . $date;

        DB::table('metrics_submission')
            ->where('context_id', $contextId)
            ->where('submission_id', $submissionId)
            ->where('load_id', 'like', 'ore_import_' . (int) $articleId . '_%')
            ->delete();

        $pdfGalleyId = null;
        $pdfSubmissionFileId = null;
        $xmlGalleyId = null;
        $xmlSubmissionFileId = null;
        foreach ($latestPublication->getData('galleys') ?? [] as $galley) {
            $sfId = $galley->getData('submissionFileId');
            if (!$sfId) {
                continue;
            }
            $file = Repo::submissionFile()->get($sfId);
            if (!$file) {
                continue;
            }
            $mime = $file->getData('mimetype') ?? '';
            if ($mime === 'application/pdf') {
                $pdfGalleyId = (int) $galley->getId();
                $pdfSubmissionFileId = (int) $sfId;
            }
            if (in_array($mime, ['application/xml', 'text/xml', 'application/jats+xml'], true)) {
                $xmlGalleyId = (int) $galley->getId();
                $xmlSubmissionFileId = (int) $sfId;
            }
        }

        $base = [
            'load_id' => $loadId,
            'context_id' => $contextId,
            'submission_id' => $submissionId,
            'date' => $date,
        ];

        if ($views > 0) {
            DB::table('metrics_submission')->insert(array_merge($base, [
                'assoc_type' => Application::ASSOC_TYPE_SUBMISSION,
                'metric' => $views,
            ]));
        }

        if ($pdfDownloads > 0) {
            DB::table('metrics_submission')->insert(array_merge($base, [
                'representation_id' => $pdfGalleyId ?: null,
                'submission_file_id' => $pdfSubmissionFileId ?: null,
                'file_type' => PKPStatisticsHelper::STATISTICS_FILE_TYPE_PDF,
                'assoc_type' => Application::ASSOC_TYPE_SUBMISSION_FILE,
                'metric' => $pdfDownloads,
            ]));
        }

        if ($xmlDownloads > 0) {
            DB::table('metrics_submission')->insert(array_merge($base, [
                'representation_id' => $xmlGalleyId ?: null,
                'submission_file_id' => $xmlSubmissionFileId ?: null,
                'file_type' => PKPStatisticsHelper::STATISTICS_FILE_TYPE_OTHER,
                'assoc_type' => Application::ASSOC_TYPE_JATS,
                'metric' => $xmlDownloads,
            ]));
        }
    }

    /**
     * Get cached article record
     */
    private function getArticle(): object
    {
        if ($this->_article === null) {
            $this->_article = $this->_connection->table('f1000r_article')
                ->where('id', $this->_articleId)
                ->first();

            if (!$this->_article) {
                throw new Exception("Article {$this->_articleId} not found");
            }
        }
        return $this->_article;
    }

    /**
     * Get all published versions for the article
     */
    private function getAllVersions(): array
    {
        return $this->_connection->table('f1000r_version')
            ->where('article_id', $this->_articleId)
            ->where('status', 'PUBLISHED')
            ->orderBy('version_number', 'asc')
            ->get()
            ->toArray();
    }

    /**
     * Get current version record (set during execute loop)
     */
    private function getVersion(): object
    {
        if ($this->_version === null) {
            throw new Exception("Version not set. This should be called during execute().");
        }
        return $this->_version;
    }

    /**
     * Retrieves the context ID
     */
    public function getContextId(): int
    {
        return $this->_contextId;
    }

    /**
     * Tries to map the given locale to the PKP standard, returns the default locale if it fails or if the parameter is null
     */
    public function getLocale(?string $locale = null): string
    {
        if ($locale && !\PKP\facades\Locale::isLocaleValid($locale)) {
            $locale = strtolower($locale);
            // Tries to convert from recognized formats
            $iso3 = LocaleConversion::getIso3FromIso1($locale) ?: LocaleConversion::getIso3FromLocale($locale);
            // If the language part of the locale is the same (ex. fr_FR and fr_CA), then gives preference to context's locale
            $locale = $iso3 == LocaleConversion::getIso3FromLocale($this->_locale) ? $this->_locale : LocaleConversion::getLocaleFrom3LetterIso((string) $iso3);
        }
        $locale = $locale ?: $this->_locale;
        return $this->_usedLocales[$locale] = $locale;
    }

    public function getUsedLocales(): array
    {
        return $this->_usedLocales;
    }

    /**
     * Retrieves the configuration instance
     */
    public function getConfiguration(): Configuration
    {
        return $this->_configuration;
    }

    /**
     * Retrieves the public IDs for the current version
     *
     * @return array Returns array, where the key is the type and value the ID
     */
    public function getPublicIds(): array
    {
        $version = $this->getVersion();
        return $this->getPublicIdsForVersion($version);
    }

    /**
     * Retrieves the public IDs for a specific version
     *
     * @param object $version Version record
     * @return array Returns array, where the key is the type and value the ID
     */
    private function getPublicIdsForVersion(object $version): array
    {
        $article = $this->getArticle();
        $ids = [];

        $ids['publisher-id'] = "{$article->volume}.{$article->publication_number}.{$article->id}.{$version->version_number}";

        if (!empty($version->doi)) {
            $ids['doi'] = $version->doi;
        }

        return $ids;
    }

    /**
     * Retrieves the publication date
     */
    public function getPublicationDate(): DateTimeImmutable
    {
        $version = $this->getVersion();
        if ($version->published) {
            $date = $this->parseDateString($version->published);
            if ($date) {
                return $date;
            }
        }
        throw new Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
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
     * Rollbacks the process
     */
    public function rollback(): void
    {
        $this->deleteTrackedEntities();
    }

    /**
     * Creates a default author for articles with no authors
     */
    protected function createDefaultAuthor(Publication $publication): Author
    {
        $author = Repo::author()->newDataObject();
        $author->setData('givenName', $this->getConfiguration()->getContext()->getName($this->getLocale()), $this->getLocale());
        $author->setData('seq', 1);
        $author->setData('publicationId', $publication->getId());
        $author->setData('email', $this->getConfiguration()->getEmail());
        $author->setData('includeInBrowse', true);
        $author->setData('primaryContact', true);
        $author->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());

        Repo::author()->add($author);
        return $author;
    }

    /**
     * Parses and retrieves the section, if a section with the same name exists, it will be retrieved
     */
    public function buildSection(): Section
    {
        if ($this->_section) {
            return $this->_section;
        }

        $sectionName = null;
        $locale = $this->getLocale();

        $sectionName = ucwords(strtolower(
            $this->_connection->table('f1000r_collection_article')
            ->join('f1000r_collection', 'f1000r_collection_article.collection_id', '=', 'f1000r_collection.id')
            ->where('f1000r_collection_article.article_id', $this->_articleId)
            ->select('f1000r_collection.name', 'f1000r_collection.alternate_language')
            ->first()?->name ?? $this->getConfiguration()->getDefaultSectionName()
        ));

        // Tries to find an entry in the cache
        if (!($section = $this->getCachedSection($sectionName))) {
            // Creates a new section
            $section = Repo::section()->newDataObject();
        }

        $section->setData('contextId', $this->getContextId());
        $section->setData('title', $sectionName, $locale);
        $section->setData('abbrev', strtoupper(substr($sectionName, 0, 3)), $locale);
        $section->setData('abstractsNotRequired', true);
        $section->setData('metaIndexed', true);
        $section->setData('metaReviewed', false);
        $section->setData('policy', __('section.default.policy'), $this->getLocale());
        $section->setData('editorRestricted', true);
        $section->setData('hideTitle', false);
        $section->setData('hideAuthor', false);

        if ($section->getId()) {
            Repo::section()->edit($section, []);
        } else {
            Repo::section()->add($section);
        }

        $this->trackEntity($section);
        $this->setCachedSection($sectionName, $section);
        return $this->_section = $section;
    }

    /**
     * Parses and retrieves the submission (shared across all versions)
     */
    public function buildSubmission(): Submission
    {
        // If already created in this instance, return it
        if ($this->_submission) {
            return $this->_submission;
        }

        $version = $this->getVersion();
        $ids = $this->getPublicIdsForVersion($version);
        foreach ($ids as $type => $id) {
            $submission = Repo::submission()->dao->getByPubId($type, $id, $this->getContextId());
            if ($submission) {
                break;
            }
        }

        if (!$submission) {
            $submission = Repo::submission()->newDataObject();
        }

        $submission->setData('contextId', $this->getContextId());
        $submission->setData('status', Submission::STATUS_PUBLISHED);
        $submission->setData('submissionProgress', '');
        $submission->setData('stageId', WORKFLOW_STAGE_ID_PRODUCTION);
        $submission->setData('sectionId', $this->buildSection()->getId());
        $submission->setData('locale', $this->getLocale());
        $date = $version->submitted ? $this->parseDateString($version->submitted) : null;
        $date = $date ?: ($version->published ? $this->parseDateString($version->published) : new DateTimeImmutable());
        $submission->setData('dateSubmitted', $date->format(static::DATETIME_FORMAT));
        // Creates the submission
        if ($submission->getId()) {
            Repo::submission()->edit($submission, []);
        } else {
            Repo::submission()->dao->insert($submission);
        }
        $this->trackEntity($submission);
        $this->assignEditor();
        return $this->_submission = $submission;
    }

    /**
     * Assign editor as participant in production and external review stages
     */
    private function assignEditor(): void
    {
        $submissionId = $this->buildSubmission()->getId();
        $editorId = $this->getConfiguration()->getEditor()->getId();

        // Production stage (required)
        Repo::stageAssignment()->build($submissionId, $this->getConfiguration()->getEditorGroupId(), $editorId);

        // External review stage (for edit decisions, participant list)
        $editorGroupIdForReview = $this->getConfiguration()->getEditorGroupIdForStage(WORKFLOW_STAGE_ID_EXTERNAL_REVIEW);
        if ($editorGroupIdForReview) {
            Repo::stageAssignment()->build($submissionId, $editorGroupIdForReview, $editorId);
        }
    }

    /**
     * Get cached submission (shared across all versions of the same article)
     */
    protected function getCachedSubmission(): ?Submission
    {
        $article = $this->getArticle();
        $volume = (int) $article->volume;
        $issue = (string) $article->publication_number;
        $articleId = (string) $article->id;
        return static::$cache['submission']["{$volume}-{$issue}-{$articleId}"] ?? null;
    }

    /**
     * Parse, import and retrieve the publication
     *
     * @param Publication|null $source_publication Previous version's publication; used to set sourcePublicationId when creating a new version
     */
    public function buildPublication(?Publication $source_publication = null): Publication
    {
        if ($this->_publication) {
            return $this->_publication;
        }

        $version = $this->getVersion();
        $article = $this->getArticle();
        $publicationDate = $this->getPublicationDate();
        $submission = $this->buildSubmission();
        $publication = Repo::publication()->getCollector()->filterByDoiIds([$version->doi])->filterBySubmissionIds([$submission->getId()])->getMany()->first();
        if (!$publication) {
            // Create the publication
            $publication = Repo::publication()->newDataObject();
            if ($source_publication !== null) {
                $publication->setData('sourcePublicationId', $source_publication->getId());
            }
        }

        $publication->setData('submissionId', $submission->getId());
        $publication->setData('status', Submission::STATUS_PUBLISHED);
        $publication->setVersion(new PublicationVersionInfo(VersionStage::VERSION_OF_RECORD, (int) $version->version_number, 0));
        $publication->setData('seq', (int) $version->version_number);
        $publication->setData('accessStatus', Submission::ARTICLE_ACCESS_OPEN);
        $publication->setData('datePublished', $publicationDate->format(static::DATETIME_FORMAT));
        $publication->setData('sectionId', $this->buildSection()->getId());
        $publication->setData('urlPath', null);

        // Set title
        $hasTitle = strlen($version->title);
        if (!$hasTitle) {
            throw new Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
        }

        $locale = $this->getLocale();
        $publication->setData('title', $version->title, $locale);

        // Set subtitle
        if ($version->subtitle) {
            $publication->setData('subtitle', $version->subtitle, $this->getLocale());
        }

        $publication->setData('language', LocaleConversion::getIso1FromLocale($this->buildSubmission()->getData('locale')));

        // Set abstract
        if ($version->abstract_text) {
            $publication->setData('abstract', $version->abstract_text, $this->getLocale());
        }
        if ($version->lay_summaries) {
            $publication->setData('plainLanguageSummary', $version->lay_summaries, $this->getLocale());
        }

        // Set public IDs
        foreach ($this->getPublicIds() as $type => $value) {
            $publication->setStoredPubId($type, $value);
        }

        // Set copyright year and holder and license permissions
        $publication->setData('copyrightYear', $publicationDate->format('Y'));
        $licenseUrl = $this->getLicenseUrl($version);
        if ($licenseUrl) {
            $publication->setData('licenseUrl', $licenseUrl);
        }

        $publication = $this->processCitations($publication);
        $this->processCategories($publication);

        // Funding: call processFundersFromAwardGroups() with award_groups when you have them (e.g. from DB/XML)
        // $this->processFundersFromAwardGroups($award_groups);

        if ($publication->getId()) {
            Repo::publication()->edit($publication, []);
        } else {
            Repo::publication()->add($publication);
        }
        $this->processKeywords($publication);
        // Reload object with keywords (otherwise they will be cleared later on)
        $publication = Repo::publication()->get($publication->getId());
        $this->processAuthors($publication);
        // Save primary author
        $publication = Repo::publication()->edit($publication, []);

        // Handle PDF galley
        $pdfPath = $this->getPdfPath($version->id);
        if ($pdfPath && file_exists($pdfPath)) {
            $this->insertPDFGalley($publication, $pdfPath);
        }

        // Process HTML files
        $htmlPaths = $this->getHtmlPaths($version->id);
        foreach ($htmlPaths as $htmlPath) {
            if (file_exists($htmlPath)) {
                $this->insertHTMLGalley($publication, $htmlPath);
            }
        }

        // // Process supplementary files
        // $supplementaryPaths = $this->getSupplementaryPaths($version->id);
        // if (!empty($supplementaryPaths)) {
        //     $this->insertSupplementaryGalleys($publication, $supplementaryPaths);
        // }

        // Publishes the article
        Repo::publication()->publish($publication);

        return $this->_publication = $publication;
    }

    /**
     * Create funders and awards from JATS-style award-group data (Funding plugin).
     * Each item: ['funderName' => string, 'funderIdentification' => string, 'awardNumbers' => string[]].
     */
    public function processFundersFromAwardGroups(array $award_groups): void
    {
        $submission = $this->buildSubmission();
        Funders::createFundersFromAwardGroups($award_groups, $submission->getId(), $this->getContextId());
    }

    /**
     * Inserts citations
     */
    private function processCitations(Publication $publication): Publication
    {
        throw new Exception('Capture from XML');
        $version = $this->getVersion();
        if ($version->citation_text) {
            $citations = array_filter(array_map('trim', explode("\n", $version->citation_text)));
            if (!empty($citations)) {
                $publication->setData('citationsRaw', implode("\n", $citations));
            }
        }
        return $publication;
    }


    /**
     * Get license URL from version
     */
    private function getLicenseUrl($version): ?string
    {
        $licenseMap = [
            'CC_BY' => 'https://creativecommons.org/licenses/by/4.0/',
            'CC_BY_NC' => 'https://creativecommons.org/licenses/by-nc/4.0/',
            'CC_BY_NC_SA' => 'https://creativecommons.org/licenses/by-nc-sa/4.0/',
            'CC_BY_SA' => 'https://creativecommons.org/licenses/by-sa/4.0/',
        ];

        $licenseType = $version->text_license_type ?? null;
        return $licenseMap[$licenseType] ?? null;
    }

    /**
     * Get PDF file path
     */
    private function getPdfPath($versionId): ?string
    {
        $upload = $this->_connection->table('f1000r_upload_info')
            ->where('version_id', $versionId)
            ->where('type', 'PDF')
            ->where('status', 'SUCCESS')
            ->orderBy('created', 'desc')
            ->first();

        if (!$upload) {
            return null;
        }

        return $this->constructFilePath($upload->target_filename, $upload->type);
    }

    /**
     * Get HTML file paths
     */
    private function getHtmlPaths($versionId): array
    {
        $uploads = $this->_connection->table('f1000r_upload_info')
            ->where('version_id', $versionId)
            ->whereIn('type', ['XML', 'ORIGINAL_XML'])
            ->where('status', 'SUCCESS')
            ->get();

        $paths = [];
        foreach ($uploads as $upload) {
            $path = $this->constructFilePath($upload->target_filename, $upload->type);
            if ($path && file_exists($path)) {
                $paths[] = $path;
            }
        }

        return $paths;
    }

    /**
     * Get supplementary file paths
     */
    private function getSupplementaryPaths($versionId): array
    {
        $uploads = $this->_connection->table('f1000r_upload_info')
            ->where('version_id', $versionId)
            ->whereIn('type', ['DATA_FILE', 'DEPENDENT_FILE'])
            ->where('status', 'SUCCESS')
            ->get();

        $paths = [];
        foreach ($uploads as $upload) {
            $path = $this->constructFilePath($upload->target_filename, $upload->type);
            if ($path && file_exists($path)) {
                $paths[] = $path;
            }
        }

        return $paths;
    }

    /**
     * Construct file path from filename and type
     */
    private function constructFilePath(string $filename, string $type): ?string
    {
        // Check if filename already contains a full path
        if (strpos($filename, '/') === 0 || strpos($filename, '\\') === 0) {
            return file_exists($filename) ? $filename : null;
        }

        // Common patterns - adjust based on your file storage:
        $basePath = env('F1000_UPLOAD_PATH', '/path/to/uploads');
        $fullPath = rtrim($basePath, '/') . '/' . $filename;
        if (file_exists($fullPath)) {
            return $fullPath;
        }

        // Option 2: Files stored by type
        $typePath = rtrim($basePath, '/') . '/' . strtolower($type) . '/' . $filename;
        if (file_exists($typePath)) {
            return $typePath;
        }

        return null;
    }

    /**
     * Inserts the PDF galley
     */
    private function insertPDFGalley(Publication $publication, string $pdfPath): void
    {
        $file = new SplFileInfo($pdfPath);
        $filename = $file->getFilename();

        // Create a galley for the article
        $newGalley = Repo::galley()->newDataObject();
        $newGalley->setData('publicationId', $publication->getId());
        $newGalley->setData('name', $filename, $this->getLocale());
        $newGalley->setData('seq', 1);
        $newGalley->setData('label', 'PDF');
        $newGalley->setData('locale', $this->getLocale());
        $newGalleyId = Repo::galley()->add($newGalley);

        // Add the PDF file and link galley with submission file
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');
        $submission = $this->buildSubmission();

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add($file->getPathname(), $submissionDir . '/' . uniqid() . '.pdf');

        $newSubmissionFile = Repo::submissionFile()->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', Application::ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        $submissionFileId = Repo::submissionFile()->add($newSubmissionFile);

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $submissionFileId);
        Repo::galley()->edit($galley, []);
    }

    /**
     * Inserts the supplementary galleys
     */
    private function insertSupplementaryGalleys(Publication $publication, array $supplementaryPaths): void
    {
        $htmlFiles = count($this->getHtmlPaths($this->getVersion()->id));
        foreach ($supplementaryPaths as $i => $filePath) {
            if (!file_exists($filePath)) {
                continue;
            }
            $file = new SplFileInfo($filePath);
            // Create a galley for the article
            $newGalley = Repo::galley()->newDataObject();
            $newGalley->setData('publicationId', $publication->getId());
            $newGalley->setData('name', $file->getBasename(), $this->getLocale());
            $newGalley->setData('seq', 2 + $htmlFiles + $i);
            $newGalley->setData('label', 'Supplement' . (count($supplementaryPaths) > 1 ? ' ' . ($i + 1) : ''));
            $newGalley->setData('locale', $this->getLocale());
            $newGalleyId = Repo::galley()->add($newGalley);

            $submission = $this->buildSubmission();
            /** @var PKPFileService $fileService */
            $fileService = Services::get('file');
            $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
            $newFileId = $fileService->add($file->getPathname(), $submissionDir . '/' . uniqid() . '.' . $file->getExtension());

            $newSubmissionFile = Repo::submissionFile()->newDataObject();
            $newSubmissionFile->setData('submissionId', $submission->getId());
            $newSubmissionFile->setData('fileId', $newFileId);
            $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
            $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
            $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
            $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
            $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
            $newSubmissionFile->setData('assocType', Application::ASSOC_TYPE_REPRESENTATION);
            $newSubmissionFile->setData('assocId', $newGalleyId);
            $newSubmissionFile->setData('name', $file->getBasename(), $this->getLocale());

            $submissionFileId = Repo::submissionFile()->add($newSubmissionFile);

            $galley = Repo::galley()->get($newGalleyId);
            $galley->setData('submissionFileId', $submissionFileId);
            Repo::galley()->edit($galley, []);
        }
    }

    /**
     * Inserts the HTML as a production ready file
     */
    private function insertHTMLGalley(Publication $publication, string $htmlPath): void
    {
        $file = new SplFileInfo($htmlPath);
        $pieces = explode('.', $file->getBasename(".{$file->getExtension()}"));
        $lang = end($pieces);
        // Create a galley of the article (i.e. a galley)
        $newGalley = Repo::galley()->newDataObject();
        $newGalley->setData('publicationId', $publication->getId());
        $newGalley->setData('name', $file->getBasename(), $this->getLocale($lang));
        $newGalley->setData('seq', 2);
        $newGalley->setData('label', 'HTML');
        $newGalley->setData('locale', $this->getLocale($lang));
        $newGalleyId = Repo::galley()->add($newGalley);

        $userId = $this->getConfiguration()->getUser()->getId();
        $submission = $this->buildSubmission();

        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $requiredFiles = [];
        $content = preg_replace_callback('/src="([^"]*)"/', function ($match) use ($file, &$requiredFiles) {
            [$match, $src] = $match;
            $src = urldecode($src);
            if (($src[0] ?? '') === '/' || strpos($src, 'data:') === 0) {
                return $match;
            }

            $realPath = "{$file->getPath()}/{$src}";
            $extension = strtolower(pathinfo($realPath, PATHINFO_EXTENSION));
            if (substr($extension, 0, 3) === 'tif') {
                echo __('plugins.importexport.articleImporter.tiffWarning', ['file' => $file]) . "\n";
            }
            if (!is_file($realPath)) {
                echo __('plugins.importexport.articleImporter.warningMissingFile', ['file' => $file, 'missingFile' => $src]) . "\n";
                return $match;
            }
            $requiredFiles[] = $realPath;
            return str_replace($src, basename($realPath), $match);
        }, file_get_contents($file->getPathname()));

        $content = preg_replace_callback('/href="([^"]*)"/', function ($href) use ($content) {
            if (filter_var($href[1], FILTER_VALIDATE_EMAIL, FILTER_FLAG_EMAIL_UNICODE)) {
                $href[0] = str_replace($href[1], "mailto:{$href[1]}", $href[0]);
            }
            if (($href[1][0] ?? '') === '#' && is_bool(strpos($content, 'id="' . substr($href[1], 1) . '"'))) {
                echo __('plugins.importexport.articleImporter.warningMissingAnchor', ['anchor' => $href[1]]) . "\n";
            }
            return $href[0];
        }, $content);

        $filename = tempnam(sys_get_temp_dir(), 'tmp');
        file_put_contents($filename, $content);

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add($filename, $submissionDir . '/' . uniqid() . '.html');
        unlink($filename);

        $newSubmissionFile = Repo::submissionFile()->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', Application::ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $file->getBasename(), $this->getLocale($lang));

        $submissionFileId = Repo::submissionFile()->add($newSubmissionFile);

        /** @var SplFileInfo */
        foreach ($requiredFiles as $path) {
            $this->createDependentFile($submission, $userId, $submissionFileId, $path);
        }

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $submissionFileId);
        Repo::galley()->edit($galley, []);
    }

    /**
     * Creates a dependent file
     */
    protected function createDependentFile(Submission $submission, int $userId, int $submissionFileId, string $filePath)
    {
        $filename = basename($filePath);
        $fileType = pathinfo($filePath, PATHINFO_EXTENSION);
        $genreId = $this->getCachedGenre($fileType)->getId();
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add($filePath, $submissionDir . '/' . uniqid() . '.' . $fileType);

        $newSubmissionFile = Repo::submissionFile()->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_DEPENDENT);
        $newSubmissionFile->setData('genreId', $genreId);
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('uploaderUserId', $userId);
        $newSubmissionFile->setData('assocType', Application::ASSOC_TYPE_SUBMISSION_FILE);
        $newSubmissionFile->setData('assocId', $submissionFileId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        // Expect properties to be stored as empty for artwork metadata
        $newSubmissionFile->setData('caption', '');
        $newSubmissionFile->setData('credit', '');
        $newSubmissionFile->setData('copyrightOwner', '');
        $newSubmissionFile->setData('terms', '');

        Repo::submissionFile()->add($newSubmissionFile);
    }

    /**
     * Process the article keywords
     */
    private function processKeywords(Publication $publication): void
    {
        $frascati = [
            //"id","ontology_id","term_name","external_id","child_count"
            20012 => [2,"Computer and information sciences","1.2",0],
            20005 => [2,"Social sciences","5",9],
            20006 => [2,"Humanities and the arts","6",5],
            20011 => [2,"Mathematics","1.1",0],
            20001 => [2,"Natural sciences","1",7],
            20057 => [2,"Social and economic geography","5.7",0],
            20058 => [2,"Media and communications","5.8",0],
            20059 => [2,"Other social sciences","5.9",0],
            20061 => [2,"History and archaeology","6.1",0],
            20062 => [2,"Languages and literature","6.2",0],
            20063 => [2,"Philosophy, ethics and religion","6.3",0],
            20064 => [2,"Arts, history of arts, performing arts, music","6.4",0],
            20065 => [2,"Other humanities","6.5",0],
            20013 => [2,"Physical sciences","1.3",0],
            20014 => [2,"Chemical sciences","1.4",0],
            20015 => [2,"Earth and related environmental sciences","1.5",0],
            20016 => [2,"Biological sciences","1.6",0],
            20017 => [2,"Other natural sciences","1.7",0],
            20201 => [2,"Civil engineering","2.1",0],
            20202 => [2,"Electrical engineering, electronic engineering, information engineering","2.2",0],
            20203 => [2,"Mechanical engineering","2.3",0],
            20204 => [2,"Chemical engineering","2.4",0],
            20205 => [2,"Materials engineering","2.5",0],
            20206 => [2,"Medical engineering","2.6",0],
            20207 => [2,"Environmental engineering","2.7",0],
            20208 => [2,"Environmental biotechnology","2.8",0],
            20209 => [2,"Industrial biotechnology","2.9",0],
            20210 => [2,"Nano-technology","2.10",0],
            20211 => [2,"Other engineering and technologies","2.11",0],
            20032 => [2,"Clinical medicine","3.2",0],
            20031 => [2,"Basic medicine","3.1",0],
            20002 => [2,"Engineering and technology","2",11],
            20003 => [2,"Medical and health sciences","3",5],
            20004 => [2,"Agricultural and veterinary sciences","4",5],
            20056 => [2,"Political science","5.6",0],
            20000 => [2,"ROOT","",6],
            20033 => [2,"Health sciences","3.3",0],
            20034 => [2,"Medical biotechnology","3.4",0],
            20035 => [2,"Other medical science","3.5",0],
            20041 => [2,"Agriculture, forestry, and fisheries","4.1",0],
            20042 => [2,"Animal and dairy science","4.2",0],
            20043 => [2,"Veterinary science","4.3",0],
            20044 => [2,"Agricultural biotechnology","4.4",0],
            20045 => [2,"Other agricultural sciences","4.5",0],
            20051 => [2,"Psychology and cognitive sciences","5.1",0],
            20052 => [2,"Economics and business","5.2",0],
            20053 => [2,"Education","5.3",0],
            20054 => [2,"Sociology","5.4",0],
            20055 => [2,"Law","5.5",0],
        ];
        $version = $this->getVersion();
        $keywords = $this->_connection->table('f1000r_version_thesaurus_term_f1000ont')
            ->where('version_id', $version->id)
            ->select('thesaurus_term_id')
            ->get();

        $locale = $this->getLocale();
        $keywordGroups = [];
        foreach ($keywords as $keyword) {
            $keyword = $frascati[$keyword->thesaurus_term_id];
            $keywordGroups[$locale][] = $keyword[2];
        }

        if (count($keywordGroups)) {
            Repo::controlledVocab()->insertBySymbolic(ControlledVocab::CONTROLLED_VOCAB_SUBMISSION_KEYWORD, $keywordGroups, Application::ASSOC_TYPE_PUBLICATION, $publication->getId());
        }
    }

    /**
     * Process the categories
     */
    private function processCategories(Publication $publication): void
    {
        if (!$this->getConfiguration()->useCategoryAsSection()) {
            return;
        }

        $collections = $this->_connection->table('f1000r_collection_article')
            ->join('f1000r_collection', 'f1000r_collection_article.collection_id', '=', 'f1000r_collection.id')
            ->where('f1000r_collection_article.article_id', $this->_articleId)
            ->select('f1000r_collection.name', 'f1000r_collection.alternate_language')
            ->get();

        if ($collections->isEmpty()) {
            return;
        }

        $categoryIds = [];
        foreach ($collections as $collection) {
            $name = $collection->name;
            if (!$name) {
                continue;
            }
            $locale = $this->getLocale($collection->alternate_language);

            // Tries to find an entry in the cache
            $path = preg_replace('[^a-z0-9\-\_.]', '', Str::of($name)->lower()->kebab()) . '-' . substr($locale, 0, 2);
            $category = $this->getCachedCategory($path);
            if (!$category) {
                // Creates a new category
                $category = Repo::category()->newDataObject();
                $category->setData('contextId', $this->getContextId());
                $category->setData('title', $name, $locale);
                $category->setData('parentId', null);
                $category->setData('path', $path);
                $category->setData('sortOption', 'datePublished-2');

                $categoryId = Repo::category()->add($category);
                $category->setId($categoryId);
                $this->trackEntity($category);
                $this->setCachedCategory($path, $category);
            }

            $categoryIds[] = $category->getId();
        }
        $publication->setData('categoryIds', $categoryIds);
    }

    /**
     * Processes all the authors
     */
    private function processAuthors(Publication $publication): void
    {
        $version = $this->getVersion();
        $authors = $this->_connection->table('f1000r_author_version')
            ->join('f1000r_author', 'f1000r_author_version.author_id', '=', 'f1000r_author.id')
            ->where('f1000r_author_version.version_id', $version->id)
            ->orderBy('f1000r_author_version.author_position')
            ->select([
                'f1000r_author.id',
                'f1000r_author.first_name',
                'f1000r_author.last_name',
                'f1000r_author.email',
                'f1000r_author_version.corresponding',
                'f1000r_author_version.author_position'
            ])
            ->get();

        $firstAuthor = null;
        foreach ($authors as $author) {
            $authorObj = $this->processAuthor($publication, $author, $version->id);
            $firstAuthor ?? $firstAuthor = $authorObj;
        }

        // If there's no authors, create a default author
        $firstAuthor ?? $firstAuthor = $this->createDefaultAuthor($publication);
        $publication->setData('primaryContactId', $firstAuthor->getId());
    }

    /**
     * Handles an author record
     */
    private function processAuthor(Publication $publication, object $author, $versionId): Author
    {
        $firstName = $author->first_name ?? '';
        $lastName = $author->last_name ?? '';
        if ($lastName && !$firstName) {
            $firstName = $lastName;
            $lastName = '';
        } elseif (!$lastName && !$firstName) {
            $firstName = $this->getConfiguration()->getContext()->getName($this->getLocale());
        }
        $email = $author->email ?? $this->getConfiguration()->getEmail();

        // Fetch ORCID
        $orcid = $this->_connection->table('f1000r_article_person_orcid')
            ->where('author_id', $author->id)
            ->value('orcid');

        // Fetch affiliations
        $affiliations = $this->_connection->table('f1000r_version_author_affiliation')
            ->join('f1000r_affiliation', 'f1000r_version_author_affiliation.affiliation_id', '=', 'f1000r_affiliation.id')
            ->leftJoin('institution', 'f1000r_affiliation.institution_id', '=', 'institution.id')
            ->where('f1000r_version_author_affiliation.version_id', $versionId)
            ->where('f1000r_version_author_affiliation.author_id', $author->id)
            ->orderBy('f1000r_version_author_affiliation.author_affiliation_position')
            ->select([
                'f1000r_affiliation.department',
                'f1000r_affiliation.place',
                'f1000r_affiliation.state',
                'f1000r_affiliation.zip_code',
                'institution.name as institution_name'
            ])
            ->get();

        $affiliationStrings = [];
        foreach ($affiliations as $aff) {
            $parts = array_filter([
                $aff->institution_name,
                $aff->department,
                $aff->place,
                $aff->state,
                $aff->zip_code
            ]);
            if (!empty($parts)) {
                $affiliationStrings[] = implode(', ', $parts);
            }
        }

        // Fetch credit roles
        $authorVersion = $this->_connection->table('f1000r_author_version')
            ->where('author_id', $author->id)
            ->where('version_id', $versionId)
            ->first();

        $creditRoles = [];
        if ($authorVersion) {
            $roles = $this->_connection->table('f1000r_author_version_contributor_role')
                ->join('f1000r_contributor_role', 'f1000r_author_version_contributor_role.contributor_role_id', '=', 'f1000r_contributor_role.id')
                ->where('f1000r_author_version_contributor_role.author_version_id', $authorVersion->id)
                ->select('f1000r_contributor_role.role_name')
                ->get();

            foreach ($roles as $role) {
                $creditRole = $this->getCreditRole($role->role_name);
                if ($creditRole) {
                    $creditRoles[] = ['role' => $creditRole];
                }
            }
        }

        $authorObj = Repo::author()->newDataObject();
        $authorObj->setData('givenName', $firstName, $this->getLocale());
        if ($lastName) {
            $authorObj->setData('familyName', $lastName, $this->getLocale());
        }

        if ($orcid) {
            $authorObj->setData('orcid', $orcid);
        }

        $authorObj->setData('email', $email);
        $authorObj->setData('affiliation', implode('; ', $affiliationStrings), $this->getLocale());
        $authorObj->setData('seq', $this->_authorCount + 1);
        $authorObj->setData('publicationId', $publication->getId());
        $authorObj->setData('includeInBrowse', true);
        $authorObj->setData('primaryContact', !$this->_authorCount);
        $authorObj->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());
        $authorObj->setData('creditRoles', $creditRoles);

        Repo::author()->add($authorObj);
        ++$this->_authorCount;
        return $authorObj;
    }

    private function getCreditRole(?string $role): ?string
    {
        $roles = [
            'https://credit.niso.org/contributor-roles/conceptualization/' => 'conceptualization',
            'https://credit.niso.org/contributor-roles/data-curation/' => 'data curation',
            'https://credit.niso.org/contributor-roles/formal-analysis/' => 'formal analysis',
            'https://credit.niso.org/contributor-roles/funding-acquisition/' => 'funding acquisition',
            'https://credit.niso.org/contributor-roles/investigation/' => 'investigation',
            'https://credit.niso.org/contributor-roles/methodology/' => 'methodology',
            'https://credit.niso.org/contributor-roles/project-administration/' => 'project administration',
            'https://credit.niso.org/contributor-roles/resources/' => 'resources',
            'https://credit.niso.org/contributor-roles/software/' => 'software',
            'https://credit.niso.org/contributor-roles/supervision/' => 'supervision',
            'https://credit.niso.org/contributor-roles/validation/' => 'validation',
            'https://credit.niso.org/contributor-roles/visualization/' => 'visualization',
            'https://credit.niso.org/contributor-roles/writing-original-draft/' => 'writing – original draft',
            'https://credit.niso.org/contributor-roles/writing-review-editing/' => 'writing – review & editing'
        ];
        return array_key_exists($role = strtolower($role ?? ''), $roles) ? $role : (array_search($role, $roles) ?: null);
    }

    /**
     * Ensures stage assignments exist for author and editor in the external review stage.
     * Required for author responses and edit decisions to work correctly.
     */
    private function assignStageAssignments(Submission $submission): void
    {
        $submissionId = $submission->getId();
        $config = $this->getConfiguration();

        // Remove existing author stage assignments for this submission in external review
        // so re-runs stay in sync (primary author may have changed)
        StageAssignment::withSubmissionIds([$submissionId])
            ->withRoleIds([Role::ROLE_ID_AUTHOR])
            ->withStageIds([WORKFLOW_STAGE_ID_EXTERNAL_REVIEW])
            ->delete();

        // Ensure author group can participate in external review stage
        $config->ensureAuthorGroupInStage(WORKFLOW_STAGE_ID_EXTERNAL_REVIEW);

        $authorGroupId = $config->getAuthorGroupId();
        if (!$authorGroupId) {
            return;
        }

        // Assign primary author only
        $publication = $submission->getCurrentPublication();
        $authors = $publication->getData('authors');
        $primaryAuthor = $authors ? $authors->first(fn ($a) => $a->getData('primaryContact')) : null;
        $primaryAuthor ??= $authors?->first();

        if ($primaryAuthor) {
            $email = $primaryAuthor->getData('email');
            if ($email) {
                $user = $this->getOrCreateAuthorUser(
                    $primaryAuthor->getGivenName($this->_locale),
                    $primaryAuthor->getFamilyName($this->_locale),
                    $email,
                    $authorGroupId
                );
                if ($user) {
                    Repo::stageAssignment()->build($submissionId, $authorGroupId, $user->getId());
                }
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
        $doi = $submission->getCurrentPublication()->getDoi();
        if (!$doi) {
            return;
        }

        $doiParts = explode('.', $doi);
        $articleId = array_slice($doiParts, -2, 1)[0];

        $this->assignOreMetricsToLatestVersion($submission->getCurrentPublication(), (int) $articleId);

        // Execute the query to get all reviews
        $reviews = $this->_connection->table('f1000r_version as v')
            ->join('f1000r_report as r', 'r.version_id', '=', 'v.id')
            ->join('f1000r_referee_report as rr', 'rr.report_id', '=', 'r.id')
            ->join('f1000r_referee as re', 're.id', '=', 'rr.referee_id')
            ->leftJoin('f1000r_affiliation as a', 'a.id', '=', 're.affiliation_id')
            ->leftJoin('f1000r_article_referee as ar', 'ar.id', '=', 'rr.article_referee_id')
            ->leftJoin('f1000r_referee as re2', 're2.id', '=', 'ar.referee_id')
            ->leftJoin('f1000r_article_referee_affiliation as ara', 'ara.article_referee_id', '=', 'ar.id')
            ->where('v.article_id', $articleId)
            ->whereNotNull('r.decision')
            ->where('r.status', 'PUBLISHED')
            ->select([
                're.first_name',
                're.last_name',
                're.email',
                'r.comment',
                'r.published_date',
                'r.decision',
                'v.id as version_id',
                'r.id as review_id',
                'v.version_number',
                'r.doi'
            ])
            ->orderBy('v.id')
            ->orderBy('r.id')
            ->orderBy('rr.position')
            ->get();

        if (empty($reviews)) {
            return;
        }

        // Ensure stage assignments for author, editor (and reviewer via ReviewAssignment) in external review
        $this->assignStageAssignments($submission);

        // Delete all existing review assignments for this submission in external review stage
        // This ensures we can re-run the import and have a synchronized database
        $existing_assignments = Repo::reviewAssignment()->getCollector()
            ->filterBySubmissionIds([$submission->getId()])
            ->filterByStageId(WORKFLOW_STAGE_ID_EXTERNAL_REVIEW)
            ->getMany();

        foreach ($existing_assignments as $assignment) {
            // Delete associated comments first
            $submission_comment_dao = DAORegistry::getDAO('SubmissionCommentDAO'); /** @var SubmissionCommentDAO $submission_comment_dao */
            $comments = $submission_comment_dao->getReviewerCommentsByReviewerId(
                $assignment->getSubmissionId(),
                $assignment->getReviewerId(),
                $assignment->getId()
            );
            while ($comment = $comments->next()) {
                $submission_comment_dao->deleteObject($comment);
            }
            Repo::reviewAssignment()->delete($assignment);
        }

        // Group reviews by version_number (which determines the review round)
        $reviews_by_version_number = [];
        foreach ($reviews as $review) {
            $version_number = (int) $review->version_number;
            if (!isset($reviews_by_version_number[$version_number])) {
                $reviews_by_version_number[$version_number] = [];
            }
            $reviews_by_version_number[$version_number][] = $review;
        }

        // Get reviewer user group ID
        $reviewer_user_groups = Repo::userGroup()->getByRoleIds([Role::ROLE_ID_REVIEWER], $this->_contextId);
        $reviewer_group_id = $reviewer_user_groups->first()?->id;
        if (!$reviewer_group_id) {
            throw new Exception('Reviewer user group not found');
        }

        // Get review round DAO
        $review_round_dao = DAORegistry::getDAO('ReviewRoundDAO'); /** @var ReviewRoundDAO $review_round_dao */

        // Process each version (grouped by version_number)
        foreach ($reviews_by_version_number as $version_number => $version_reviews) {
            $review = reset($version_reviews);
            // Find the publication for this version
            $publication = null;
            foreach ($publications as $pub) {
                if ($pub->getData('seq') == $version_number) {
                    $publication = $pub;
                    break;
                }
            }

            if (!$publication) {
                error_log("Publication not found for version number {$version_number}, skipping reviews");
                continue;
            }

            // Create a review round for this version using version_number as the round number
            $review_round = $review_round_dao->build(
                $submission->getId(),
                $publication->getId(),
                WORKFLOW_STAGE_ID_EXTERNAL_REVIEW,
                $version_number
            );

            if (!$review_round) {
                error_log("Failed to create review round for version number {$version_number}");
                continue;
            }

            // Group reviews by review_id to handle multiple reviewers per review
            $reviews_by_review_id = [];
            foreach ($version_reviews as $review) {
                $review_id = $review->review_id;
                if (!isset($reviews_by_review_id[$review_id])) {
                    $reviews_by_review_id[$review_id] = [
                        'review_data' => $review,
                        'reviewers' => []
                    ];
                }
                $reviews_by_review_id[$review_id]['reviewers'][] = $review;
            }

            // Process each unique review
            foreach ($reviews_by_review_id as $review_id => $review_data) {
                $review_record = $review_data['review_data'];
                $reviewers = $review_data['reviewers'];

                // Get the decision for this review
                $decision_value = $this->mapDecisionToOjs($review_record->decision);

                // Create review assignments for each reviewer in this review
                foreach ($reviewers as $reviewer_data) {
                    $reviewer_user = $this->getOrCreateReviewerUser(
                        $reviewer_data->first_name,
                        $reviewer_data->last_name,
                        $reviewer_data->email,
                        $reviewer_group_id
                    );

                    if (!$reviewer_user) {
                        error_log("Failed to get or create reviewer user for email: {$reviewer_data->email}");
                        continue;
                    }

                    // Check if review assignment already exists
                    $existing_assignment = Repo::reviewAssignment()->getCollector()
                        ->filterBySubmissionIds([$submission->getId()])
                        ->filterByReviewRoundIds([$review_round->getId()])
                        ->filterByReviewerIds([$reviewer_user->getId()])
                        ->getMany()
                        ->first();

                    $reviewer_recommendation_id = $this->getReviewerRecommendationIdForDecision($review_record->decision ?? null);

                    if ($existing_assignment) {
                        // Update existing assignment
                        Repo::reviewAssignment()->edit($existing_assignment, [
                            'round' => (int) $review_record->version_number,
                            'reviewerRecommendationId' => $reviewer_recommendation_id,
                            'dateCompleted' => $review_record->published_date
                                ? $this->parseDateString($review_record->published_date)?->format(static::DATETIME_FORMAT)
                                : Core::getCurrentDate(),
                            'status' => ReviewAssignment::REVIEW_ASSIGNMENT_STATUS_COMPLETE,
                            'dateConfirmed' => Core::getCurrentDate(),
                            'dateAcknowledged' => Core::getCurrentDate(),
                            'isReviewPubliclyVisible' => 1,
                            'doiId' => $review_record->doi
                        ]);
                        $review_assignment = $existing_assignment;
                    } else {
                        // Create new review assignment
                        $review_assignment = Repo::reviewAssignment()->newDataObject([
                            'submissionId' => $submission->getId(),
                            'reviewerId' => $reviewer_user->getId(),
                            'reviewRoundId' => $review_round->getId(),
                            'stageId' => WORKFLOW_STAGE_ID_EXTERNAL_REVIEW,
                            'round' => (int) $review_record->version_number,
                            'dateAssigned' => Core::getCurrentDate(),
                            'dateCompleted' => $review_record->published_date
                                ? $this->parseDateString($review_record->published_date)?->format(static::DATETIME_FORMAT)
                                : Core::getCurrentDate(),
                            'status' => ReviewAssignment::REVIEW_ASSIGNMENT_STATUS_COMPLETE,
                            'dateConfirmed' => Core::getCurrentDate(),
                            'dateAcknowledged' => Core::getCurrentDate(),
                            'reviewerRecommendationId' => $reviewer_recommendation_id,
                            'reviewMethod' => ReviewAssignment::SUBMISSION_REVIEW_METHOD_OPEN,
                            'isReviewPubliclyVisible' => 1,
                            'doiId' => $review_record->doi
                        ]);

                        $review_assignment_id = Repo::reviewAssignment()->add($review_assignment);
                        $review_assignment = Repo::reviewAssignment()->get($review_assignment_id);
                    }

                    // Create review comment if provided
                    if (!empty($review_record->comment)) {
                        $submission_comment_dao = DAORegistry::getDAO('SubmissionCommentDAO'); /** @var SubmissionCommentDAO $submission_comment_dao */
                        $submission_comments = $submission_comment_dao->getReviewerCommentsByReviewerId(
                            $review_assignment->getSubmissionId(),
                            $review_assignment->getReviewerId(),
                            $review_assignment->getId(),
                            true
                        );
                        $comment = $submission_comments->next(); /** @var SubmissionComment|null $comment */

                        if (!isset($comment)) {
                            $comment = $submission_comment_dao->newDataObject();
                        }

                        $comment->setCommentType(SubmissionComment::COMMENT_TYPE_PEER_REVIEW);
                        $comment->setRoleId(Role::ROLE_ID_REVIEWER);
                        $comment->setAssocId($review_assignment->getId());
                        $comment->setSubmissionId($review_assignment->getSubmissionId());
                        $comment->setAuthorId($review_assignment->getReviewerId());
                        $comment->setComments($review_record->comment);
                        $comment->setCommentTitle('');
                        $comment->setViewable(true);
                        $comment->setDatePosted(Core::getCurrentDate());

                        // Save or update
                        if ($comment->getId() != null) {
                            $submission_comment_dao->updateObject($comment);
                        } else {
                            $submission_comment_dao->insertObject($comment);
                        }
                    }
                }

                // Create an edit decision if we have a valid decision value
                if ($decision_value !== null) {
                    $this->createEditDecision(
                        $submission,
                        $publication,
                        $review_round,
                        $decision_value,
                        $review_record->published_date
                    );
                }
            }

            // Import author responses: approved comments linked to reports in this round
            $report_ids = array_map('intval', array_keys($reviews_by_review_id));
            if (!empty($report_ids)) {
                $this->importAuthorResponsesForRound(
                    $submission,
                    $publication,
                    $review_round,
                    $report_ids
                );
            }
        }
    }

    /**
     * Fetches approved comments from F1000R for the given report IDs (f1000r_comment_report.report_id).
     * Only comments in f1000r_comment with status = 'APPROVED' are returned.
     * Each item has: text, creation_date, last_updated (raw from PostgreSQL).
     *
     * @param int[] $reportIds
     * @return list<object{text: string, creation_date: mixed, last_updated: mixed}>
     */
    private function getApprovedCommentsForReportIds(array $reportIds): array
    {
        if (empty($reportIds)) {
            return [];
        }

        $rows = $this->_connection->table('f1000r_comment_report as cr')
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
                    'creation_date' => $row->creation_date,
                    'last_updated' => $row->last_updated,
                ];
            }
        }
        return $out;
    }

    /**
     * Creates or replaces author response(s) for the given review round using F1000R approved comments.
     * One AuthorResponse is created per approved comment, with createdAt/updatedAt from the PostgreSQL comment.
     */
    private function importAuthorResponsesForRound(
        Submission $submission,
        Publication $publication,
        ReviewRound $review_round,
        array $reportIds
    ): void {
        $approved_comments = $this->getApprovedCommentsForReportIds($reportIds);
        if (empty($approved_comments)) {
            return;
        }

        // Remove existing author responses for this round so re-import stays in sync
        AuthorResponse::withReviewRoundIds([$review_round->getId()])->delete();

        $author_stage_assignment = StageAssignment::withSubmissionIds([$submission->getId()])
            ->withRoleIds([Role::ROLE_ID_AUTHOR])
            ->withStageIds([$review_round->getStageId()])
            ->get()
            ->first();
        $author_user_id = $author_stage_assignment !== null ? $author_stage_assignment->userId : null;

        if ($author_user_id === null) {
            return;
        }

        $authors = $publication->getData('authors');
        $associated_author_ids = $authors ? $authors->map(fn ($a) => $a->getId())->all() : [];

        foreach ($approved_comments as $comment) {
            $created_at = $this->formatCommentDateForOjs($comment->creation_date);
            $updated_at = $this->formatCommentDateForOjs($comment->last_updated ?? $comment->creation_date);

            $reviewResponse = AuthorResponse::create([
                'reviewRoundId' => $review_round->getId(),
                'authorResponse' => [$this->_locale => $comment->text],
                'userId' => $author_user_id,
            ]);

            // Set createdAt and updatedAt from F1000R comment (AuthorResponse fillable does not include them)
            DB::table('review_round_author_responses')
                ->where('response_id', $reviewResponse->id)
                ->update([
                    'created_at' => $created_at,
                    'updated_at' => $updated_at,
                ]);

            if (!empty($associated_author_ids)) {
                $reviewResponse->associateAuthorsToResponse($associated_author_ids);
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
     * Maps F1000R decision values to OJS Decision constants
     *
     * @param string|null $decision
     * @return int|null
     */
    private function mapDecisionToOjs(?string $decision): ?int
    {
        if (!$decision) {
            return null;
        }

        $decision_map = [
            'NOT_APPROVED' => Decision::DECLINE,
            'APPROVED_WITH_RESERVATIONS' => Decision::PENDING_REVISIONS,
            'APPROVED' => Decision::ACCEPT,
        ];

        return $decision_map[$decision] ?? null;
    }

    /**
     * Decision to reviewer recommendation title (for matching against ReviewerRecommendation::getLocalizedData('title')).
     */
    private const DECISION_TO_RECOMMENDATION_TITLE = [
        'APPROVED' => 'Approved',
        'APPROVED_WITH_RESERVATIONS' => 'Approved with Reservations',
        'NOT_APPROVED' => 'Not Approved',
    ];

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

        $recommendationTitle = self::DECISION_TO_RECOMMENDATION_TITLE[$decision] ?? null;
        if ($recommendationTitle === null) {
            return null;
        }

        $recommendations = ReviewerRecommendation::query()
            ->withContextId($this->_contextId)
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
     *
     * @param string|null $firstName
     * @param string|null $lastName
     * @param string|null $email
     * @param int $authorGroupId
     * @return User|null
     */
    private function getOrCreateAuthorUser(?string $firstName, ?string $lastName, ?string $email, int $authorGroupId): ?User
    {
        if (!$email) {
            return null;
        }

        $user = Repo::user()->getByEmail($email, true);
        if ($user) {
            if (!Repo::userGroup()->userInGroup($user->getId(), $authorGroupId)) {
                Repo::userGroup()->assignUserToGroup($user->getId(), $authorGroupId);
            }
            return $user;
        }

        $user = Repo::user()->newDataObject();
        $user->setGivenName($firstName ?? '', $this->_locale);
        $user->setFamilyName($lastName ?? '', $this->_locale);
        $user->setEmail($email);
        $user->setUsername($email);
        $user->setDateRegistered(Core::getCurrentDate());
        $user->setInlineHelp(1);
        $user->setPassword(Validation::encryptCredentials($email, Str::random(16)));

        $userId = Repo::user()->add($user);
        if (!$userId) {
            return null;
        }

        Repo::userGroup()->assignUserToGroup($userId, $authorGroupId);
        return Repo::user()->get($userId);
    }

    /**
     * Gets or creates a reviewer user
     *
     * @param string|null $first_name
     * @param string|null $last_name
     * @param string|null $email
     * @param int $reviewer_group_id
     * @return User|null
     */
    private function getOrCreateReviewerUser(?string $first_name, ?string $last_name, ?string $email, int $reviewer_group_id): ?User
    {
        if (!$email) {
            return null;
        }

        // Try to get existing user by email
        $user = Repo::user()->getByEmail($email, true);

        if ($user) {
            // Ensure user has reviewer role
            $has_reviewer_role = Repo::userGroup()->userInGroup($user->getId(), $reviewer_group_id);

            if (!$has_reviewer_role) {
                Repo::userGroup()->assignUserToGroup($user->getId(), $reviewer_group_id);
            }

            return $user;
        }

        // Create new user
        $user = Repo::user()->newDataObject();
        $user->setGivenName($first_name ?? '', $this->_locale);
        $user->setFamilyName($last_name ?? '', $this->_locale);
        $user->setEmail($email);
        $user->setUsername($email); // Use email as username
        $user->setDateRegistered(Core::getCurrentDate());
        $user->setInlineHelp(1);

        // Generate a random password (user will need to reset it)
        $password = Str::random(16);
        $user->setPassword(Validation::encryptCredentials($email, $password));

        $user_id = Repo::user()->add($user);
        if (!$user_id) {
            return null;
        }

        // Assign reviewer role
        Repo::userGroup()->assignUserToGroup($user_id, $reviewer_group_id);

        return Repo::user()->get($user_id);
    }

    /**
     * Creates an edit decision for the review
     *
     * @param Submission $submission
     * @param Publication $publication
     * @param \PKP\submission\reviewRound\ReviewRound $review_round
     * @param int $decision
     * @param string|null $date_decided
     */
    private function createEditDecision(
        Submission $submission,
        Publication $publication,
        $review_round,
        int $decision,
        ?string $date_decided
    ): void {
        // Check if decision already exists for this review round
        $existing_decisions = Repo::decision()->getCollector()
            ->filterBySubmissionIds([$submission->getId()])
            ->filterByReviewRoundIds([$review_round->getId()])
            ->filterByDecisionTypes([$decision])
            ->getMany();

        if ($existing_decisions->isNotEmpty()) {
            // Decision already exists, skip
            return;
        }

        $editor = $this->_configuration->getEditor();
        $date_decided_obj = $date_decided
            ? $this->parseDateString($date_decided)
            : new DateTimeImmutable();

        if (!$date_decided_obj) {
            $date_decided_obj = new DateTimeImmutable();
        }

        // Get decision type
        $decision_types = Repo::decision()->getDecisionTypes();
        $decision_type = null;
        foreach ($decision_types as $dt) {
            if ($dt->getDecision() === $decision) {
                $decision_type = $dt;
                break;
            }
        }

        if (!$decision_type) {
            error_log("Decision type not found for decision constant: {$decision}");
            return;
        }

        // Create decision object
        $decision_obj = Repo::decision()->newDataObject([
            'submissionId' => $submission->getId(),
            'publicationId' => $publication->getId(),
            'reviewRoundId' => $review_round->getId(),
            'decision' => $decision,
            'editorId' => $editor->getId(),
            'stageId' => $decision_type->getStageId(),
            'dateDecided' => $date_decided_obj->format(static::DATETIME_FORMAT),
        ]);

        Repo::decision()->add($decision_obj);
    }
}
