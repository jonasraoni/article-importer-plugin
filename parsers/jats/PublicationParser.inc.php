<?php
/**
 * @file parsers/jats/PublicationParser.inc.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PublicationParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the publications
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\Jats;

use Application;
use APP\Services\SubmissionFileService;
use ArticleGalleyDAO;
use CategoryDAO;
use Core;
use DAORegistry;
use DateTimeImmutable;
use DOMDocument;
use DOMElement;
use DOMXPath;
use Exception;
use PKP\Plugins\ImportExport\ArticleImporter\EntityManager;
use PKPLocale;
use PKP\Services\PKPFileService;
use Publication;
use PublicationDAO;
use Services;
use SplFileInfo;
use Stringy\Stringy;
use Submission;
use SubmissionFileDAO;
use SubmissionKeywordDAO;
use XSLTProcessor;

trait PublicationParser
{
    use EntityManager;

    /**
     * Parse, import and retrieve the publication
     */
    public function getPublication(): Publication
    {
        $publicationDate = $this->getPublicationDate() ?: $this->getIssuePublicationDate();
        $version = $this->getArticleVersion()->getVersion();

        // Create the publication
        /** @var PublicationDAO */
        $publicationDao = DAORegistry::getDAO('PublicationDAO');
        /** @var Publication */
        $publication = $publicationDao->newDataObject();
        $publication->setData('submissionId', $this->getSubmission()->getId());
        $publication->setData('status', STATUS_PUBLISHED);
        $publication->setData('version', (int) $version);
        $publication->setData('seq', $this->getArticleVersion()->getVersion());
        $publication->setData('accessStatus', ARTICLE_ACCESS_OPEN);
        $publication->setData('datePublished', $publicationDate->format(static::DATETIME_FORMAT));
        $publication->setData('sectionId', $this->getSection()->getId());
        $publication->setData('issueId', $this->getIssue()->getId());
        $publication->setData('urlPath', null);

        // Set article pages
        $firstPage = $this->selectText('front/article-meta/fpage');
        $lastPage = $this->selectText('front/article-meta/lpage');
        if ($firstPage || $lastPage) {
            $publication->setData('pages', "{$firstPage}" . ($lastPage ? "-{$lastPage}" : ''));
        }

        $hasTitle = false;

        // Set title
        if ($node = $this->selectFirst('front/article-meta/title-group/article-title')) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            $value = $this->selectText('.', $this->clearXref($node));
            $hasTitle = strlen($value);
            $publication->setData('title', $value, $locale);
        }

        // Set subtitle
        if ($node = $this->selectFirst('front/article-meta/title-group/subtitle')) {
            $publication->setData('subtitle', $this->selectText('.', $this->clearXref($node)), $this->getLocale($node->getAttribute('xml:lang')));
        }

        // Set localized title/subtitle
        /** @var DOMElement $node  */
        foreach ($this->select('front/article-meta/title-group/trans-title-group') as $node) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            if ($value = $this->selectText('trans-title', $this->clearXref($node))) {
                $hasTitle = true;
                $publication->setData('title', $value, $locale);
            }
            if ($value = $this->selectText('trans-subtitle', $this->clearXref($node))) {
                $publication->setData('subtitle', $value, $locale);
            }
        }

        if (!$hasTitle) {
            throw new Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
        }

        $publication->setData('language', PKPLocale::getIso1FromLocale($this->getSubmission()->getData('locale')));

        // Set abstract
        /** @var DOMElement $node  */
        foreach ($this->select('front/article-meta/abstract[not(@abstract-type="plain-language-summary")]|front/article-meta/trans-abstract[not(@abstract-type="plain-language-summary")]|front/article-meta/abstract|front/article-meta/trans-abstract') as $node) {
            $value = trim($this->getTextContent($node, function ($node, $content) {
                // Transforms the known tags, the remaining ones will be stripped
                $tag = [
                    'title' => 'strong',
                    'italic' => 'em',
                    'sub' => 'sub',
                    'sup' => 'sup',
                    'p' => 'p'
                ][$node->nodeName] ?? null;
                return $tag ? "<{$tag}>{$content}</{$tag}>" : $content;
            }));
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            if ($value && !$publication->getData('abstract', $locale)) {
                $publication->setData('abstract', $value, $locale);
            }
        }

        // Set public IDs
        foreach ($this->getPublicIds() as $type => $value) {
            $publication->setData('pub-id::' . $type, $value);
        }

        // Set copyright year and holder and license permissions
        if ($copyrightHolder = $this->selectText('front/article-meta/permissions/copyright-holder')) {
            $publication->setData('copyrightHolder', $copyrightHolder, $this->getLocale());
        }
        if ($copyrightNotice = $this->selectText('front/article-meta/permissions/copyright-statement')) {
            $publication->setData('copyrightNotice', $copyrightNotice, $this->getLocale());
        }
        if ($copyrightYear = $this->selectText('front/article-meta/permissions/copyright-year')) {
            $publication->setData('copyrightYear', $copyrightYear);
        }
        if ($licenseUrl = $this->selectText('front/article-meta/permissions/license/attribute::xlink:href')) {
            $publication->setData('licenseUrl', $licenseUrl);
        }
        $publication = $this->_processCitations($publication);
        $this->setPublicationCoverImage($publication);
        $this->_processCategories($publication);

        // Inserts the publication and updates the submission
        $publication = Services::get('publication')->add($publication, Application::get()->getRequest());
        $this->_processKeywords($publication);
        // Reload object with keywords (otherwise they will be cleared later on)
        $publication = Services::get('publication')->get($publication->getId());
        $this->_processAuthors($publication);
        // Save primary author
        $publication = Services::get('publication')->edit($publication, [], Application::get()->getRequest());

        // Handle PDF galley
        $this->_insertPDFGalley($publication);

        // Store the JATS XML
        $this->_insertXMLSubmissionFile();
        // Process full text and generate HTML files
        $this->_processFullText(false);
        $this->_insertHTMLGalley($publication);
        $this->_insertSupplementaryGalleys($publication);

        // Publishes the article
        Services::get('publication')->publish($publication);

        return $publication;
    }

    /**
     * Inserts citations
     */
    private function _processCitations(Publication $publication): Publication
    {
        $citations = '';
        /** @var DOMElement $citation  */
        foreach ($this->select('/article/back/ref-list/ref') as $citation) {
            $label = $citation->getElementsByTagName('label')->item(0);
            $label = $label ? trim($label->textContent, "\n\r\t\v\0.") : '';
            $label = $label ? "{$label}. " : '';
            $citationNode = $this->convertJatsToHtml($citation->getElementsByTagName('mixed-citation')->item(0));
            $citationText = $citationNode ? $citationNode->ownerDocument->saveXML($citationNode) : '';
            $citationText = preg_replace(['/\r\n|\n\r|\r|\n/', '/\s{2,}/', '/\s+([,.])/'], [' ', ' ', '$1'], $citationText);
            $citation->textContent = "{$label}{$citationText}\n";
            $document = new DOMDocument();
            $document->preserveWhiteSpace = false;
            $document->loadXML($citation->C14N());
            $document->documentElement->normalize();
            if ($document->documentElement->textContent) {
                $citations .= $document->documentElement->textContent . "\n";
            }
        }
        if ($citations) {
            $publication->setData('citationsRaw', $citations);
        }
        return $publication;
    }

    /**
     * Inserts the XML as a production ready file
     */
    private function _insertXMLSubmissionFile(): void
    {
        $file = $this->getArticleVersion()->getMetadataFile();
        $filename = $file->getPathname();

        $genreId = GENRE_CATEGORY_DOCUMENT;
        $fileStage = SUBMISSION_FILE_PRODUCTION_READY;
        $userId = $this->getConfiguration()->getUser()->getId();

        $submission = $this->getSubmission();

        /** @var SubmissionFileService $submissionFileService */
        $submissionFileService = Services::get('submissionFile');
        /** @var \PKP\Services\PKPFileService $fileService */
        $fileService = Services::get('file');

        $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $filename,
            $submissionDir . '/' . uniqid() . '.xml'
        );

        /** @var SubmissionFileDAO $submissionFileDao */
        $submissionFileDao = DAORegistry::getDAO('SubmissionFileDAO');
        $newSubmissionFile = $submissionFileDao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $genreId);
        $newSubmissionFile->setData('fileStage', $fileStage);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('name', $file->getFilename(), $this->getLocale());

        $submissionFile = $submissionFileService->add($newSubmissionFile, Application::get()->getRequest());

        /** @var DOMElement $asset */
        foreach ($this->select('//asset|//graphic') as $asset) {
            $assetFilename = $asset->getAttribute($asset->nodeName === 'path' ? 'href' : 'xlink:href');
            $dependentFilePath = dirname($filename) . "/{$assetFilename}";
            if (file_exists($dependentFilePath)) {
                $this->_createDependentFile($submission, $userId, $submissionFile->getId(), $dependentFilePath);
            }
        }
    }

    /**
     * Creates a dependent file
     */
    protected function _createDependentFile(Submission $submission, int $userId, int $submissionFileId, string $filePath)
    {
        $filename = basename($filePath);
        $fileType = pathinfo($filePath, PATHINFO_EXTENSION);
        $genreId = $this->getCachedGenre($fileType)->getId();
        /** @var SubmissionFileService $submissionFileService */
        $submissionFileService = Services::get('submissionFile');
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');

        $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add($filePath, $submissionDir . '/' . uniqid() . '.' . $fileType);

        /** @var SubmissionFileDAO $submissionFileDao */
        $submissionFileDao = DAORegistry::getDAO('SubmissionFileDAO');
        $newSubmissionFile = $submissionFileDao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('fileStage', SUBMISSION_FILE_DEPENDENT);
        $newSubmissionFile->setData('genreId', $genreId);
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('uploaderUserId', $userId);
        $newSubmissionFile->setData('assocType', ASSOC_TYPE_SUBMISSION_FILE);
        $newSubmissionFile->setData('assocId', $submissionFileId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        // Expect properties to be stored as empty for artwork metadata
        $newSubmissionFile->setData('caption', '');
        $newSubmissionFile->setData('credit', '');
        $newSubmissionFile->setData('copyrightOwner', '');
        $newSubmissionFile->setData('terms', '');

        $submissionFileService->add($newSubmissionFile, Application::get()->getRequest());
    }

    /**
     * Inserts the PDF galley
     */
    private function _insertPDFGalley(Publication $publication): void
    {
        $file = $this->getArticleVersion()->getSubmissionFile();
        if (!$file) {
            return;
        }
        $filename = $file->getFilename();

        // Create a representation of the article (i.e. a galley)
        /** @var ArticleGalleyDAO */
        $representationDao = Application::getRepresentationDAO();
        $newRepresentation = $representationDao->newDataObject();
        $newRepresentation->setData('publicationId', $publication->getId());
        $newRepresentation->setData('name', $filename, $this->getLocale());
        $newRepresentation->setData('seq', 1);
        $newRepresentation->setData('label', 'PDF');
        $newRepresentation->setData('locale', $this->getLocale());
        $newRepresentationId = $representationDao->insertObject($newRepresentation);

        // Add the PDF file and link representation with submission file
        /** @var \APP\Services\SubmissionFileService $submissionFileService */
        $submissionFileService = Services::get('submissionFile');
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');
        $submission = $this->getSubmission();

        $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add($file->getPathname(), $submissionDir . '/' . uniqid() . '.pdf');

        /** @var SubmissionFileDAO $submissionFileDao */
        $submissionFileDao = DAORegistry::getDAO('SubmissionFileDAO');
        $newSubmissionFile = $submissionFileDao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newRepresentationId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        $submissionFile = $submissionFileService->add($newSubmissionFile, Application::get()->getRequest());

        $representation = $representationDao->getById($newRepresentationId);
        $representation->setFileId($submissionFile->getData('id'));
        $representationDao->updateObject($representation);
    }

    /**
     * Inserts the supplementary galleys
     */
    private function _insertSupplementaryGalleys(Publication $publication): void
    {
        $htmlFiles = count($this->getArticleVersion()->getHtmlFiles());
        $files = $this->getArticleVersion()->getSupplementaryFiles();
        /** @var SplFileInfo */
        foreach ($files as $i => $file) {
            // Create a representation of the article (i.e. a galley)
            /** @var ArticleGalleyDAO */
            $representationDao = Application::getRepresentationDAO();
            $newRepresentation = $representationDao->newDataObject();
            $newRepresentation->setData('publicationId', $publication->getId());
            $newRepresentation->setData('name', $file->getBasename(), $this->getLocale());
            $newRepresentation->setData('seq', 2 + $htmlFiles + $i);
            $newRepresentation->setData('label', 'Supplement' . (count($files) > 1 ? ' ' . ($i + 1) : ''));
            $newRepresentation->setData('locale', $this->getLocale());
            $newRepresentationId = $representationDao->insertObject($newRepresentation);

            $submission = $this->getSubmission();

            /** @var SubmissionFileService $submissionFileService */
            $submissionFileService = Services::get('submissionFile');
            /** @var PKPFileService $fileService */
            $fileService = Services::get('file');
            $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
            $newFileId = $fileService->add($file->getPathname(), $submissionDir . '/' . uniqid() . '.' . $file->getExtension());

            /** @var SubmissionFileDAO $submissionFileDao */
            $submissionFileDao = DAORegistry::getDAO('SubmissionFileDAO');
            $newSubmissionFile = $submissionFileDao->newDataObject();
            $newSubmissionFile->setData('submissionId', $submission->getId());
            $newSubmissionFile->setData('fileId', $newFileId);
            $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
            $newSubmissionFile->setData('fileStage', SUBMISSION_FILE_PROOF);
            $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
            $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
            $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
            $newSubmissionFile->setData('assocType', ASSOC_TYPE_REPRESENTATION);
            $newSubmissionFile->setData('assocId', $newRepresentationId);
            $newSubmissionFile->setData('name', $file->getBasename(), $this->getLocale());

            $submissionFile = $submissionFileService->add($newSubmissionFile, Application::get()->getRequest());

            $representation = $representationDao->getById($newRepresentationId);
            $representation->setFileId($submissionFile->getData('id'));
            $representationDao->updateObject($representation);
        }
    }

    /**
     * Retrieves the public IDs
     *
     * @return array Returns array, where the key is the type and value the ID
     */
    public function getPublicIds(): array
    {
        $articleEntry = $this->getArticleEntry();
        $ids = ['publisher-id' => "{$articleEntry->getVolume()}.{$articleEntry->getIssue()}.{$articleEntry->getArticle()}.{$this->getArticleVersion()->getVersion()}"];
        /** @var DOMElement $node */
        foreach ($this->select('front/article-meta/article-id') as $node) {
            $ids[strtolower($node->getAttribute('pub-id-type'))] = $this->selectText('.', $node);
        }
        return $ids;
    }

    /**
     * Retrieves the publication date
     */
    public function getPublicationDate(): DateTimeImmutable
    {
        $node = null;
        // Find the most suitable pub-date node
        /** @var DOMElement $node */
        foreach ($this->select('front/article-meta/pub-date') as $node) {
            if (in_array($node->getAttribute('pub-type'), ['given-online-pub', 'epub']) || $node->getAttribute('publication-format') == 'electronic') {
                break;
            }
        }
        if (!$date = $this->getDateFromNode($node)) {
            throw new Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
        }
        return $date;
    }

    /**
     * Inserts the HTML as a production ready file
     */
    private function _insertHTMLGalley(Publication $publication): void
    {
        /** @var SplFileInfo */
        foreach ($this->getArticleVersion()->getHtmlFiles() as $i => $file) {
            $pieces = explode('.', $file->getBasename(".{$file->getExtension()}"));
            $lang = end($pieces);
            // Create a representation of the article (i.e. a galley)
            /** @var ArticleGalleyDAO */
            $representationDao = Application::getRepresentationDAO();
            $newRepresentation = $representationDao->newDataObject();
            $newRepresentation->setData('publicationId', $publication->getId());
            $newRepresentation->setData('name', $file->getBasename(), $this->getLocale($lang));
            $newRepresentation->setData('seq', 2 + $i);
            $newRepresentation->setData('label', 'HTML');
            $newRepresentation->setData('locale', $this->getLocale($lang));
            $newRepresentationId = $representationDao->insertObject($newRepresentation);

            $userId = $this->getConfiguration()->getUser()->getId();

            $submission = $this->getSubmission();

            /** @var SubmissionFileService $submissionFileService */
            $submissionFileService = Services::get('submissionFile');
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

            $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
            $newFileId = $fileService->add($filename, $submissionDir . '/' . uniqid() . '.html');
            unlink($filename);

            /** @var SubmissionFileDAO $submissionFileDao */
            $submissionFileDao = DAORegistry::getDAO('SubmissionFileDAO');
            $newSubmissionFile = $submissionFileDao->newDataObject();
            $newSubmissionFile->setData('submissionId', $submission->getId());
            $newSubmissionFile->setData('fileId', $newFileId);
            $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
            $newSubmissionFile->setData('fileStage', SUBMISSION_FILE_PROOF);
            $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
            $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
            $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
            $newSubmissionFile->setData('assocType', ASSOC_TYPE_REPRESENTATION);
            $newSubmissionFile->setData('assocId', $newRepresentationId);
            $newSubmissionFile->setData('name', $file->getBasename(), $this->getLocale($lang));

            $submissionFile = $submissionFileService->add($newSubmissionFile, Application::get()->getRequest());

            /** @var SplFileInfo */
            foreach ($requiredFiles as $path) {
                $this->_createDependentFile($submission, $userId, $submissionFile->getId(), $path);
            }

            $representation = $representationDao->getById($newRepresentationId);
            $representation->setFileId($submissionFile->getData('id'));
            $representationDao->updateObject($representation);
        }
    }

    /**
     * Process the article keywords
     */
    private function _processKeywords(Publication $publication): void
    {
        /** @var SubmissionKeywordDAO */
        $submissionKeywordDAO = DAORegistry::getDAO('SubmissionKeywordDAO');
        $keywords = [];
        /** @var DOMElement $node */
        foreach ($this->select('front/article-meta/kwd-group') as $node) {
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
            foreach ($this->select('kwd', $node) as $node) {
                $keywords[$locale][] = $this->selectText('.', $node);
            }
        }
        if (count($keywords)) {
            $submissionKeywordDAO->insertKeywords($keywords, $publication->getId());
        }
    }

    /**
     * Process the categories
     */
    private function _processCategories(Publication $publication): void
    {
        $categoryIds = [];
        /** @var DOMElement $node */
        foreach ($this->select('front/article-meta/article-categories/subj-group') as $node) {
            $name = $this->selectText('subject', $node);
            $locale = $this->getLocale($node->getAttribute('xml:lang'));

            // Tries to find an entry in the cache
            $category = $this->getCachedCategory($name, $locale);
            if (!$category) {
                // Creates a new category
                /** @var CategoryDAO */
                $categoryDao = DAORegistry::getDAO('CategoryDAO');
                $category = $categoryDao->newDataObject();
                $category->setData('contextId', $this->getContextId());
                $category->setData('title', $name, $locale);
                $category->setData('parentId', null);
                $category->setData('path', Stringy::create($name)->toLowerCase()->dasherize()->regexReplace('[^a-z0-9\-\_.]', '') . '-' . substr($locale, 0, 2));
                $category->setData('sortOption', 'datePublished-2');

                $categoryDao->insertObject($category);
                $this->trackEntity($category);
                $this->setCachedCategory($name, $locale, $category);
            }

            $categoryIds[] = $category->getId();
        }
        $publication->setData('categoryIds', $categoryIds);
    }

    /**
     * Process the full text and generate HTML files
     */
    private function _processFullText(bool $overwrite = false): void
    {
        static $xslt;

        if (!$this->getConfiguration()->shouldGenerateHtml()) {
            return;
        }

        $file = $this->getArticleVersion()->getSubmissionFile();
        if (!$file) {
            return;
        }

        if (!$this->selectFirst('/article/body') || (!$overwrite && count($this->getArticleVersion()->getHtmlFiles()))) {
            return;
        }

        libxml_use_internal_errors(true);
        if (!$xslt) {
            $document = new DOMDocument('1.0', 'utf-8');
            $document->load(__DIR__ . '/xslt/jats-html.xsl');
            $xslt = new XSLTProcessor();
            $xslt->registerPHPFunctions();
            $xslt->importStyleSheet($document);
        }

        $metadata = $this->getArticleVersion()->getMetadataFile();
        $xml = new DOMDocument('1.0', 'utf-8');
        $xml->load($metadata);
        $xpath = new DOMXPath($xml);
        $xpath->registerNamespace('xlink', 'http://www.w3.org/1999/xlink');
        $defaultLang = $xml->documentElement->getAttributeNS('http://www.w3.org/XML/1998/namespace', 'lang') ?: $this->getLocale();
        $langs = [$defaultLang => 0];
        /** @var DOMElement $sec */
        foreach ($this->select("body//sec[@xml:lang!='{$defaultLang}']", null, $xpath) as $sec) {
            $langs[$sec->getAttributeNS('http://www.w3.org/XML/1998/namespace', 'lang')] = 0;
        }
        foreach (array_keys($langs) as $lang) {
            $xml = new DOMDocument('1.0', 'utf-8');
            $xml->load($metadata);
            $xpath = new DOMXPath($xml);
            $xpath->registerNamespace('xlink', 'http://www.w3.org/1999/xlink');

            /** @var DOMElement $contribNode */
            foreach ($this->select('//contrib-group/contrib', null, $xpath) as $contribNode) {
                $affiliations = [];
                $xrefs = [];
                /** @var DOMElement */
                foreach ($contribNode->getElementsByTagName('xref') as $xref) {
                    $id = $xref->getAttribute('rid');
                    switch ($xref->getAttribute('ref-type')) {
                        case 'fn':
                            /** @var DOMElement $node */
                            if ($node = $this->selectFirst("//back/fn-group/fn[@id='{$id}']", null, $xpath)) {
                                $node = $node->cloneNode(true);
                                /** @var DOMElement */
                                foreach (iterator_to_array($node->getElementsByTagName('label')) as $label) {
                                    $label->parentNode->removeChild($label);
                                }
                                $this->convertJatsToHtml($node);
                                $bioNode = $node->ownerDocument->createElement('bio');
                                foreach (iterator_to_array($node->childNodes) as $childNode) {
                                    $bioNode->appendChild($childNode);
                                }
                                $xrefs[] = $xref;
                                $contribNode->appendChild($bioNode);
                            }
                            break;

                        case 'aff':
                            if ($affiliation = trim($this->selectText("../../aff[@id='{$id}']", $xref, $xpath))) {
                                $affiliations[] = $affiliation;
                            }
                            $xrefs[] = $xref;
                            break;
                    }
                }
                if (count($affiliations)) {
                    $node = $contribNode->ownerDocument->createElement('aff', implode('; ', $affiliations));
                    $contribNode->appendChild($node);
                }
                foreach($xrefs as $xref) {
                    $xref->parentNode->removeChild($xref);
                }
            }

            if (count($langs) > 1) {
                $filter = "body//sec[@xml:lang!='{$lang}']";
                if ($defaultLang !== $lang) {
                    $filter .= " | body//sec[not(@xml:lang)]";
                }
                $isSharedFnGroup = count($this->select('back/fn-group', null, $xpath)) !== count($langs);
                if (!$isSharedFnGroup) {
                    $filter .= " | back/fn-group[@xml:lang!='{$lang}']";
                    if ($defaultLang !== $lang) {
                        $filter .= " | back/fn-group[not(@xml:lang)]";
                    }
                }
                foreach (iterator_to_array($this->select($filter, null, $xpath)) as $node) {
                    $node->parentNode->removeChild($node);
                }
            }

            $switch = function (DOMElement $main, DOMElement $translation): void {
                $namespace = 'http://www.w3.org/XML/1998/namespace';
                $mainNodes = iterator_to_array($main->childNodes);
                $translationNodes = iterator_to_array($translation->childNodes);
                foreach ($mainNodes as $node) {
                    $translation->appendChild($node);
                }
                foreach ($translationNodes as $node) {
                    $main->appendChild($node);
                }

                $translationLang = $translation->parentNode->getAttributeNS($namespace, 'lang');
                $translation->parentNode->setAttributeNS($namespace, 'lang', $main->getAttributeNS($namespace, 'lang'));
                $main->setAttributeNS($namespace, 'lang', $translationLang);
            };
            if (
                ($title = $this->selectFirst("/article/front/article-meta/title-group/article-title[@xml:lang!='{$lang}']", null, $xpath))
                && ($translatedTitle = $this->selectFirst("/article/front/article-meta/title-group/trans-title-group[@xml:lang='{$lang}']/trans-title", null, $xpath))
            ) {
                $switch($title, $translatedTitle);
            }
            if (
                ($title = $this->selectFirst("/article/front/article-meta/title-group/subtitle[@xml:lang!='{$lang}']", null, $xpath))
                && ($translatedTitle = $this->selectFirst("/article/front/article-meta/title-group/trans-title-group[@xml:lang='{$lang}']/trans-subtitle", null, $xpath))
            ) {
                $switch($title, $translatedTitle);
            }
            $xml->documentElement->setAttributeNS('http://www.w3.org/XML/1998/namespace', 'lang', $lang);

            /** @var DOMElement $xref */
            foreach (iterator_to_array($this->select("//xref", null, $xpath)) as $xref) {
                if (!$this->selectFirst("//*[@id='" . $xref->getAttribute('rid') . "']", null, $xpath)) {
                    echo "Dropped invalid xref to: " . $xref->getAttribute('rid') . "\n";
                    $xref->parentNode->removeChild($xref);
                }
            }

            $output = $xslt->transformToXML($xml);

            if ($output === false) {
                throw new Exception("Failed to create HTML file from JATS XML: \n" . print_r(libxml_get_errors(), true));
            }
            $path = $metadata->getPathInfo() . '/' . $metadata->getBasename($metadata->getExtension()) . "{$lang}.html";

            file_put_contents($path, $output);
        }
    }
}
