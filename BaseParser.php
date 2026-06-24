<?php
/**
 * @file BaseParser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BaseParser
 * @brief Base class that parsers should extend
 */

namespace APP\plugins\importexport\articleImporter;

use APP\core\Application;
use APP\plugins\importexport\articleImporter\exceptions\AlreadyExistsException;
use APP\plugins\importexport\articleImporter\exceptions\InvalidDocTypeException;
use APP\publication\Publication;
use APP\issue\Issue;
use APP\submission\Submission;
use APP\section\Section;
use APP\author\Author;
use APP\file\PublicFileManager;
use APP\facades\Repo;
use DateTimeImmutable;
use DOMDocument;
use DOMNode;
use DOMNodeList;
use DOMText;
use DOMXPath;
use Exception;
use GlobIterator;
use PKP\core\Core;
use PKP\core\PKPString;
use PKP\db\DAORegistry;
use PKP\facades\Locale;
use PKP\file\TemporaryFile;
use PKP\file\TemporaryFileDAO;
use PKP\file\TemporaryFileManager;
use PKP\i18n\LocaleConversion;
use Throwable;

abstract class BaseParser
{
    use EntityManager;

    public const DATETIME_FORMAT = 'Y-m-d H:i:s';

    /** @var Configuration Configuration */
    private Configuration $_configuration;
    /** @var ArticleVersion Article version */
    protected $_version;
    /** @var ?DOMDocument The XML document */
    protected ?DOMDocument $_document = null;
    /** @var DOMXPath The DOMXPath instance for the XML metadata */
    protected ?DOMXPath $_xpath = null;
    /** @var int Context ID */
    private int $_contextId;
    /** @var string Default locale, grabbed from the submission or the context's primary locale */
    private string $_locale;
    /** @var string[] */
    private array $_usedLocales = [];

    /**
     * Constructor
     */
    public function __construct(Configuration $configuration, ArticleVersion $version)
    {
        $this->_configuration = $configuration;
        $this->_version = $version;
        $context = $this->_configuration->getContext();
        $this->_contextId = $context->getId();
        $this->_locale = $context->getPrimaryLocale();
    }

    /**
     * Parses the publication
     */
    abstract public function getPublication(): Publication;

    /**
     * Parses the issue, returns null for continuous publishing (no issue)
     */
    abstract public function getIssue(): ?Issue;

    /**
     * Parses the submission
     */
    abstract public function getSubmission(): Submission;

    /**
     * Parses the section
     */
    abstract public function getSection(): Section;

    /**
     * Retrieves the public IDs
     *
     * @return array Returns array, where the key is the type and value the ID
     */
    abstract public function getPublicIds(): array;

    /**
     * Retrieves whether the parser can deal with the underlying document
     */
    abstract public function canParse(): bool;

    /**
     * Rollbacks the process
     */
    public function rollback(): void
    {
        $this->deleteTrackedEntities();
    }

    /**
     * Executes the parser
     *
     * @throws Exception Throws when something goes wrong, and an attempt to revert the actions will be performed
     */
    public function execute(): void
    {
        try {
            $this
                ->ensureMetadataIsValidAndParse()
                ->_ensureSubmissionDoesNotExist()
                ->getPublication();
        } catch (Throwable $e) {
            $this->rollback();
            throw $e;
        }
    }

    /**
     * Replaces the URLs in the XML and HTML files by the local file names
     */
    public function replaceExternalReferences(string $content) {
        // Get all image files in the images folder
        $resources = array_map('basename', glob($this->getArticleVersion()->getPath()->getRealPath() . '/*'));
        // Replace the URLs in the content
        foreach ($resources as $filename) {
            $content = preg_replace('/\bhttps?:\/\/[^\s]*?' . preg_quote($filename, '/') . '\b/i', $filename, $content);
        }

        return $content;
    }

    /**
     * Validates the metadata file and try to parse the XML
     *
     * @throws Exception Throws when there's an error to parse the XML
     */
    public function ensureMetadataIsValidAndParse(): static
    {
        $document = new DOMDocument('1.0', 'utf-8');
        if (!$document->loadXML($this->replaceExternalReferences(file_get_contents($this->_version->getMetadataFile()->getPathname())))) {
            throw new Exception(__('plugins.importexport.articleImporter.failedToParseXMLDocument'));
        }

        $this->_document = $document;
        $this->_xpath = new DOMXPath($this->_document);
        $this->_xpath->registerNamespace('xlink', 'http://www.w3.org/1999/xlink');
        $this->_locale = $this->getLocale($this->selectText('@xml:lang'));

        if (!$this->canParse()) {
            throw new InvalidDocTypeException(__('plugins.importexport.articleImporter.invalidDoctype'));
        }

        return $this;
    }

    /**
     * Checks if the submission isn't already registered using the public IDs
     *
     * @throws Exception Throws when a submission with the same public ID is found
     */
    private function _ensureSubmissionDoesNotExist(): static
    {
        foreach ($this->getPublicIds() as $type => $id) {
            $submission = Repo::submission()->dao->getByPubId($type, $id, $this->getContextId());
            if (!$submission) {
                continue;
            }

            if ($type === 'publisher-id') {
                throw new AlreadyExistsException(__('plugins.importexport.articleImporter.alreadyExists', ['type' => $type, 'id' => $id]));
            }

            echo __('plugins.importexport.articleImporter.duplicateWarning', ['type' => $type, 'id' => $id]);
        }
        return $this;
    }

    /**
     * Evaluates and retrieves the given XPath expression
     *
     * @param string $path XPath expression
     * @param DOMNode $context Optional context node
     */
    public function evaluate(string $path, ?DOMNode $context = null, DOMXPath $xpath = null)
    {
        return ($xpath ?? $this->_xpath)->evaluate($path, $context);
    }

    /**
     * Evaluates and retrieves the given XPath expression as a trimmed and tag stripped string
     * The path is expected to target a single node
     *
     * @param string $path XPath expression
     * @param DOMNode $context Optional context node
     */
    public function selectText(string $path, ?DOMNode $context = null, DOMXPath $xpath = null): string
    {
        return strip_tags(trim($this->evaluate("string({$path})", $context, $xpath)));
    }

    /**
     * Retrieves the nodes that match the given XPath expression
     *
     * @param string $path XPath expression
     * @param DOMNode $context Optional context node
     */
    public function select(string $path, ?DOMNode $context = null, DOMXPath $xpath = null): DOMNodeList
    {
        return ($xpath ?? $this->_xpath)->query($path, $context);
    }

    /**
     * Query the given XPath expression and retrieves the first item
     *
     * @param string $path XPath expression
     * @param DOMNode $context Optional context node
     */
    public function selectFirst(string $path, ?DOMNode $context = null, DOMXPath $xpath = null): ?object
    {
        return $this->select($path, $context, $xpath)->item(0);
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
        if ($locale && !Locale::isLocaleValid($locale)) {
            $locale = strtolower($locale);
            // Tries to convert from recognized formats
            $iso3 = LocaleConversion:: getIso3FromIso1($locale) ?: LocaleConversion::getIso3FromLocale($locale);
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
     * Gets the article version
     */
    public function getArticleVersion(): ArticleVersion
    {
        return $this->_version;
    }

    /**
     * Gets the article entry
     */
    public function getArticleEntry(): ArticleEntry
    {
        return $this->_version->getArticleEntry();
    }

    /**
     * Manually evaluates the textContent of the node with the help of a transformation callback
     *
     * @param callable $callback The callback will receive two arguments, the current node being parsed and the already transformed textContent of it
     */
    public function getTextContent(?DOMNode $node, callable $callback)
    {
        if (!$node) {
            return null;
        }
        if ($node instanceof DOMText) {
            return htmlspecialchars($node->textContent, ENT_HTML5 | ENT_NOQUOTES);
        }
        $data = '';
        foreach ($node->childNodes ?? [] as $child) {
            $data .= $this->getTextContent($child, $callback);
        }
        return $callback($node, $data);
    }

    /**
     * Creates a default author for articles with no authors
     */
    protected function _createDefaultAuthor(Publication $publication): Author
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
     * Looks in $issueFolder for a cover image, and applies it to $issue if found
     */
    public function setIssueCoverImage(Issue $issue): void
    {
        $issueCover = null;
        $issueFolder = $this->getArticleEntry()->getIssueDirectory();
        if (!$issueFolder) {
            return;
        }
        foreach (new GlobIterator("{$issueFolder}/" . $this->getConfiguration()->getCoverFilename() . '.*') as $file) {
            if (in_array(strtolower($file->getExtension()), $this->getConfiguration()->getImageExtensions())) {
                $issueCover = $file;
                break;
            }
        }

        if (!$issueCover) {
            return;
        }

        $publicFileManager = new PublicFileManager();
        $newFileName = 'cover_issue_' . $issue->getId() . '_' . $this->getLocale() . '.' . $issueCover->getExtension();
        $publicFileManager->copyContextFile($this->getContextId(), $issueCover, $newFileName);
        $issue->setCoverImage($newFileName, $this->getLocale());
        Repo::issue()->edit($issue, []);
    }

    /**
     * Sets the publication cover
     */
    public function setPublicationCoverImage(Publication $publication): void
    {
        $fileManager = new TemporaryFileManager();
        $filename = $this->getArticleVersion()->getSubmissionCoverFile();
        if (!$filename) {
            return;
        }

        // Get the file extension, then rename the file.
        $fileExtension = $fileManager->parseFileExtension($filename->getBasename());

        // Try to create destination directory
        $fileManager->mkdirtree($fileManager->getBasePath());

        $newFileName = basename(tempnam($fileManager->getBasePath(), $fileExtension));
        if (!$newFileName) {
            return;
        }

        $fileManager->copyFile($filename, $fileManager->getBasePath() . "/{$newFileName}");
        /** @var TemporaryFileDAO */
        $temporaryFileDao = DAORegistry::getDAO('TemporaryFileDAO');
        /** @var TemporaryFile */
        $temporaryFile = $temporaryFileDao->newDataObject();

        $temporaryFile->setUserId(Application::get()->getRequest()->getUser()->getId());
        $temporaryFile->setServerFileName($newFileName);
        $temporaryFile->setFileType(PKPString::mime_content_type($fileManager->getBasePath() . "/$newFileName", $fileExtension));
        $temporaryFile->setFileSize($filename->getSize());
        $temporaryFile->setOriginalFileName($fileManager->truncateFileName($filename->getBasename(), 127));
        $temporaryFile->setDateUploaded(Core::getCurrentDate());

        $temporaryFileDao->insertObject($temporaryFile);

        $publication->setData('coverImage', [
            'dateUploaded' => (new DateTimeImmutable())->format(static::DATETIME_FORMAT),
            'uploadName' => $temporaryFile->getOriginalFileName(),
            'temporaryFileId' => $temporaryFile->getId(),
            'altText' => 'Publication image'
        ], $this->getLocale());
    }
}
