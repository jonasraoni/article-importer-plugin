<?php
/**
 * @file parsers/jats/PublicationParser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PublicationParser
 * @brief Handles parsing and importing the publications
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\plugins\importexport\articleImporter\ArticleImporterPlugin;

use APP\Services\SubmissionFileService;
use FilesystemIterator;
use PKP\Services\PKPFileService;
use APP\publication\Publication;
use PKP\file\TemporaryFile;
use PKP\db\DAORegistry;
use APP\core\Services;
use PKP\core\Core;
use APP\core\Application;
use PKP\i18n\LocaleConversion;
use PKP\submission\Genre;
use PKP\plugins\PluginRegistry;
use PKP\submissionFile\SubmissionFile;
use PKP\file\TemporaryFileManager;
use PKP\core\PKPString;
use APP\facades\Repo;
use PKP\controlledVocab\ControlledVocab;

trait PublicationParser
{
    /**
     * Parse, import and retrieve the publication
     */
    public function getPublication(): Publication
    {
        $publicationDate = $this->getPublicationDate() ?: $this->getIssuePublicationDate();

        // Create the publication
        $publication = Repo::publication()->dao->newDataObject();
	$publication->setData('submissionId', $this->getSubmission()->getId());
        $publication->setData('status', \STATUS_PUBLISHED);
        $publication->setData('version', 1);
	$publication->setData('seq', $this->getSubmission()->getId());
        $publication->setData('accessStatus', \ARTICLE_ACCESS_OPEN);
        $publication->setData('datePublished', $publicationDate->format(ArticleImporterPlugin::DATETIME_FORMAT));
        $publication->setData('sectionId', $this->getSection()->getId());
        $publication->setData('issueId', $this->getIssue()->getId());
        $publication->setData('urlPath', null);

        // Set article pages
        $firstPage = $this->selectText('front/article-meta/fpage');
        $lastPage = $this->selectText('front/article-meta/lpage');
        if ($firstPage || $lastPage) {
            $publication->setData('pages', "${firstPage}" . ($lastPage ? "-${lastPage}" : ''));
        }

        $hasTitle = false;

        // Set title
        if ($node = $this->selectFirst('front/article-meta/title-group/article-title')) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            $value = $this->selectText('.', $node);
            $hasTitle = strlen($value);
            $publication->setData('title', $value, $locale);
        }

        // Set subtitle
        if ($node = $this->selectFirst('front/article-meta/title-group/subtitle')) {
            $publication->setData('subtitle', $this->selectText('.', $node), $this->getLocale($node->getAttribute('xml:lang')));
        }

        // Set localized title/subtitle
        foreach ($this->select('front/article-meta/title-group/trans-title-group') as $node) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            if ($value = $this->selectText('trans-title', $node)) {
                $hasTitle = true;
                $publication->setData('title', $value, $locale);
            }
            if ($value = $this->selectText('trans-subtitle', $node)) {
                $publication->setData('subtitle', $value, $locale);
            }
        }

        if (!$hasTitle) {
            throw new \Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
        }

        $publication->setData('language', LocaleConversion::getIso1FromLocale($this->getSubmission()->getData('locale')));

        // Set abstract
        foreach ($this->select('front/article-meta/abstract|front/article-meta/trans-abstract') as $node) {
            $value = trim($this->getTextContent($node, function ($node, $content) {
                // Transforms the known tags, the remaining ones will be stripped
                $tag = [
                    'title' => 'strong',
                    'italic' => 'em',
                    'sub' => 'sub',
                    'sup' => 'sup',
                    'p' => 'p'
                ][$node->nodeName] ?? null;
                return $tag ? "<${tag}>${content}</${tag}>" : $content;
            }));
            if ($value) {
                $publication->setData('abstract', $value, $this->getLocale($node->getAttribute('xml:lang')));
            }
        }

        // Set public IDs
        $pubIdPlugins = false;
        foreach ($this->getPublicIds() as $type => $value) {
            if ($type !== 'publisher-id' && !$pubIdPlugins) {
                $pubIdPlugins = PluginRegistry::loadCategory('pubIds', true, $this->getContextId());
            }
            $publication->setData('pub-id::' . $type, $value);
        }

        // Set copyright year and holder and license permissions
        $publication->setData('copyrightHolder', $this->selectText('front/article-meta/permissions/copyright-holder'), $this->getLocale());
        $publication->setData('copyrightNotice', $this->selectText('front/article-meta/permissions/copyright-statement'), $this->getLocale());
        $publication->setData('copyrightYear', $this->selectText('front/article-meta/permissions/copyright-year') ?: $publicationDate->format('Y'));
        $publication->setData('licenseUrl', $this->selectText('front/article-meta/permissions/license/attribute::xlink:href'));

        $publication = $this->_processCitations($publication);
        $this->_setCoverImage($publication);

        // Inserts the publication and updates the submission
	Repo::publication()->dao->insert($publication);
	$submission = $this->getSubmission();
	$submission->setData('currentPublicationId', $publication->getId());
	Repo::submission()->edit($submission, []);

        $this->_processKeywords($publication);
        $this->_processAuthors($publication);

        // Handle PDF galley
        $this->_insertPDFGalley($publication);

        // Record this XML itself
        $this->_insertXMLSubmissionFile($publication);

        $this->_insertHTMLGalley($publication);

        $publication = Repo::publication()->get($publication->getId());

        // Publishes the article
        Repo::publication()->publish($publication);

        return $publication;
    }

    /**
     * Inserts citations
     */
    private function _processCitations(Publication $publication): Publication
    {
        $citationText = '';
        foreach ($this->select('/article/back/ref-list/ref') as $citation) {
            $document = new \DOMDocument();
            $document->preserveWhiteSpace = false;
            $document->loadXML($citation->C14N());
            $document->documentElement->normalize();
            $citationText .= $document->documentElement->textContent . "\n";
        }
        if ($citationText) {
            $publication->setData('citationsRaw', $citationText);
        }
        return $publication;
    }

    /**
     * Inserts the XML as a production ready file
     */
    private function _insertXMLSubmissionFile(Publication $publication): void
    {
        $splfile = $this->getArticleEntry()->getMetadataFile();
        $filename = $splfile->getPathname();

        $genreId = Genre::GENRE_CATEGORY_DOCUMENT;
        $fileStage = SubmissionFile::SUBMISSION_FILE_PRODUCTION_READY;
        $userId = $this->getConfiguration()->getUser()->getId();

        $submission = $this->getSubmission();

        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $filename,
            $submissionDir . '/' . uniqid() . '.xml'
        );

        $newSubmissionFile = Repo::submissionFile()->dao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $genreId);
        $newSubmissionFile->setData('fileStage', $fileStage);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('name', $splfile->getFilename(), $this->getLocale());

        $submissionFile = Repo::submissionFile()->add($newSubmissionFile, Application::get()->getRequest());
        unset($newFileId);

        foreach ($this->select('//asset|//graphic') as $asset) {
            $assetFilename = $asset->getAttribute($asset->nodeName == 'path' ? 'href' : 'xlink:href');
            $dependentFilePath = dirname($filename) . DIRECTORY_SEPARATOR . $assetFilename;
            if (file_exists($dependentFilePath)) {
                $fileType = pathinfo($assetFilename, PATHINFO_EXTENSION);
                $genreId = $this->_getGenreId($this->getContextId(), $fileType);
                $this->_createDependentFile($genreId, $submission, $submissionFile, $userId, $fileType, $assetFilename, SubmissionFile::SUBMISSION_FILE_DEPENDENT, \ASSOC_TYPE_SUBMISSION_FILE, false, $submissionFile->getId(), false, $dependentFilePath);
            }
        }
    }

    /**
     * Creates a dependent file
     */
    protected function _createDependentFile(int $genreId, Submission $submission, SubmissionFile $submissionFile, int $userId, string $fileType, string $filename, $fileStage = false, $assocType = false, $sourceRevision = false, $assocId = false, $sourceFileId = false, string $filePath)
    {
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $filePath,
            $submissionDir . '/' . uniqid() . '.' . $fileType
        );

        $newSubmissionFile = Repo::submissionFile()->dao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('fileStage', $fileStage);
        $newSubmissionFile->setData('genreId', $genreId);
        $newSubmissionFile->setData('fileStage', $fileStage);
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('uploaderUserId', $userId);

        if (isset($assocType)) {
            $newSubmissionFile->setData('assocType', $assocType);
        }
        if (isset($assocId)) {
            $newSubmissionFile->setData('assocId', $assocId);
        }
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        // Expect properties to be stored as empty for artwork metadata
        $newSubmissionFile->setData('caption', '');
        $newSubmissionFile->setData('credit', '');
        $newSubmissionFile->setData('copyrightOwner', '');
        $newSubmissionFile->setData('terms', '');

        $insertedMediaFile = Repo::submissionFile()->add($newSubmissionFile, Application::get()->getRequest());
    }

    /**
     * Inserts the PDF galley
     */
    private function _insertPDFGalley(Publication $publication): void
    {
        $file = $this->getArticleEntry()->getSubmissionFile();
        $filename = $file->getFilename();

        // Create a galley for the article
        $newGalley = Repo::galley()->dao->newDataObject();
        $newGalley->setData('publicationId', $publication->getId());
        $newGalley->setData('name', $filename, $this->getLocale());
        $newGalley->setData('seq', 1);
        $newGalley->setData('label', 'Fulltext PDF');
        $newGalley->setData('locale', $this->getLocale());
        $newGalleyId = Repo::galley()->add($newGalley);

        // Add the PDF file and link galley with submission file
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');
        $submission = $this->getSubmission();

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $file->getPathname(),
            $submissionDir . '/' . uniqid() . '.pdf'
        );

        $newSubmissionFile = Repo::submissionFile()->dao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', \ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        Repo::submissionFile()->add($newSubmissionFile, Application::get()->getRequest());

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $newSubmissionFile->getData('id'));
        Repo::galley()->edit($galley, []);

        unset($newFileId);
    }

    /**
     * Retrieves the public IDs
     *
     * @return array Returns array, where the key is the type and value the ID
     */
    public function getPublicIds(): array
    {
        $ids = [];
        foreach ($this->select('front/article-meta/article-id') as $node) {
            $ids[strtolower($node->getAttribute('pub-id-type'))] = $this->selectText('.', $node);
        }
        return $ids;
    }

    /**
     * Retrieves the publication date
     */
    public function getPublicationDate(): \DateTimeImmutable
    {
        $node = null;
        // Find the most suitable pub-date node
        foreach ($this->select('front/article-meta/pub-date') as $node) {
            if (in_array($node->getAttribute('pub-type'), ['given-online-pub', 'epub']) || $node->getAttribute('publication-format') == 'electronic') {
                break;
            }
        }
        if (!$date = $this->getDateFromNode($node)) {
            throw new \Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
        }
        return $date;
    }

    private function _setCoverImage(\Publication $publication): void
    {
        $pfm = new TemporaryFileManager();
        $filename = $this->getArticleEntry()->getSubmissionCoverFile();
        if (!$filename) {
            return;
        }
        // Get the file extension, then rename the file.
        $fileExtension = $pfm->parseFileExtension($filename->getBasename());

        if (!$pfm->fileExists($pfm->getBasePath(), 'dir')) {
            // Try to create destination directory
            $pfm->mkdirtree($pfm->getBasePath());
        }

        $newFileName = basename(tempnam($pfm->getBasePath(), $fileExtension));
        if (!$newFileName) return;

        $pfm->copyFile($filename, $pfm->getBasePath() . "/{$newFileName}");
        /** @var TemporaryFileDAO */
        $temporaryFileDao = DAORegistry::getDAO('TemporaryFileDAO');
        /** @var TemporaryFile */
        $temporaryFile = $temporaryFileDao->newDataObject();

        $temporaryFile->setUserId(Application::get()->getRequest()->getUser()->getId());
        $temporaryFile->setServerFileName($newFileName);
        $temporaryFile->setFileType(PKPString::mime_content_type($pfm->getBasePath() . "/$newFileName", $fileExtension));
        $temporaryFile->setFileSize($filename->getSize());
        $temporaryFile->setOriginalFileName($pfm->truncateFileName($filename->getBasename(), 127));
        $temporaryFile->setDateUploaded(Core::getCurrentDate());

        $temporaryFileDao->insertObject($temporaryFile);

        $publication->setData('coverImage', [
            'dateUploaded' => (new \DateTime())->format('Y-m-d H:i:s'),
            'uploadName' => $temporaryFile->getOriginalFileName(),
            'temporaryFileId' => $temporaryFile->getId(),
            'altText' => 'Publication image'
        ], $this->getLocale());
    }

    /**
     * Inserts the HTML as a production ready file
     */
    private function _insertHTMLGalley(Publication $publication): void
    {
        $splfile = $this->getArticleEntry()->getHtmlFile();
		if (!$splfile) {
			return;
		}

        // Create a galley of the article (i.e. a galley)
        $newGalley = Repo::galley()->dao->newDataObject();
        $newGalley->setData('publicationId', $publication->getId());
        $newGalley->setData('name', $splfile->getBasename(), $this->getLocale());
        $newGalley->setData('seq', 2);
        $newGalley->setData('label', 'Fulltext HTML');
        $newGalley->setData('locale', $this->getLocale());
        $newGalleyId = Repo::galley()->add($newGalley);

        $userId = $this->getConfiguration()->getUser()->getId();

        $submission = $this->getSubmission();

        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $filename = tempnam(sys_get_temp_dir(), 'tmp');
        file_put_contents($filename, str_replace('src="images/', 'src="', file_get_contents($splfile->getPathname())));

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $filename,
            $submissionDir . '/' . uniqid() . '.html'
        );

        $newSubmissionFile = Repo::submissionFile()->dao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', \ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $splfile->getBasename(), $this->getLocale());

        $submissionFile = Repo::submissionFile()->add($newSubmissionFile, Application::get()->getRequest());

        /** @var \SplFileInfo */
        foreach (is_dir($splfile->getPath()) ? new FilesystemIterator($splfile->getPath() . '/images') : [] as $assetFilename) {
            if ($assetFilename->isDir()) {
                throw new \Exception("Unexpected directory {$assetFilename}");
            }
            $fileType = $assetFilename->getExtension();
            $genreId = $this->_getGenreId($this->getContextId(), $fileType);
            $this->_createDependentFile($genreId, $submission, $submissionFile, $userId, $fileType, $assetFilename->getBasename(), SubmissionFile::SUBMISSION_FILE_DEPENDENT, \ASSOC_TYPE_SUBMISSION_FILE, false, $submissionFile->getId(), false, $assetFilename);
        }

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $submissionFile->getData('id'));
        Repo::galley()->edit($galley);
    }

    /**
     * Process the article keywords
     */
    private function _processKeywords(Publication $publication): void
    {
        $keywords = [];
        foreach ($this->select('front/article-meta/kwd-group') as $node) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            foreach ($this->select('kwd', $node) as $node) {
                $keywords[$locale][] = $this->selectText('.', $node);
            }
        }
        if (count($keywords)) {
            Repo::controlledVocab()->insertBySymbolic(ControlledVocab::CONTROLLED_VOCAB_SUBMISSION_KEYWORD, $keywords, Application::ASSOC_TYPE_PUBLICATION, $publication->getId());
        }
    }
}
