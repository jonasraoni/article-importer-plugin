<?php
/**
 * @file plugins/importexport/articleImporter/BaseParser.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BaseParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Base class that parsers should extend
 */

namespace PKP\Plugins\ImportExport\ArticleImporter;

use \PKP\Plugins\ImportExport\ArticleImporter\Exceptions\{InvalidDocTypeException, AlreadyExistsException};

abstract class BaseParser {
	/** @var Configuration Configuration */
	private $_configuration;
	/** @var ArticleEntry Article entry */
	private $_entry;
	/** @var \DOMDocument The DOMDocument instance for the XML metadata */
	private $_document;
	/** @var \DOMXPath The DOMXPath instance for the XML metadata */
	private $_xpath;
	/** @var int Context ID */
	private $_contextId;
	/** @var string Default locale, grabbed from the context */
	private $_locale;
	/** @var int[] cache of genres by context id and extension */
	private $_cachedGenres;

	/**
	 * Constructor
	 * @param Configuration $configuration
	 * @param ArticleEntry $entry
	 */
	public function __construct(Configuration $configuration, ArticleEntry $entry)
	{
		$this->_configuration = $configuration;
		$this->_entry = $entry;
		$context = $this->_configuration->getContext();
		$this->_contextId = $context->getId();
		$this->_locale = $context->getPrimaryLocale();
	}

	/**
	 * Parses the publication
	 * @return \Publication
	 */
	public abstract function getPublication(): \Publication;

	/**
	 * Parses the issue
	 * @return \Issue
	 */
	public abstract function getIssue(): \Issue;

	/**
	 * Parses the submission
	 * @return \Submission
	 */
	public abstract function getSubmission(): \Submission;

	/**
	 * Parses the section
	 * @return \Section
	 */
	public abstract function getSection(): \Section;

	/**
	 * Retrieves the public IDs
	 * @return array Returns array, where the key is the type and value the ID
	 */
	public abstract function getPublicIds(): array;

	/**
	 * Rollbacks the process
	 */
	public abstract function rollback(): void;

	/**
	 * Retrieves the DOCTYPE
	 * @return array \DOMDocumentType[]
	 */
	public abstract function getDocType(): array;

	/**
	 * Executes the parser
	 * @throws \Exception Throws when something goes wrong, and an attempt to revert the actions will be performed
	 */
	public function execute(): void
	{
		try {
			$this
				->_ensureMetadataIsValidAndParse()
				->_ensureSubmissionDoesNotExist()
				->getPublication();
		}
		catch (\Exception $e) {
			$this->rollback();
			throw $e;
		}
	}

	/**
	 * Validates the metadata file and try to parse the XML
	 * @throws \Exception Throws when there's an error to parse the XML
	 * @return Parser
	 */
	private function _ensureMetadataIsValidAndParse(): self
	{
		// Tries to parse the XML
		$this->_document = new \DOMDocument();
		if (!$this->_document->load($this->getArticleEntry()->getMetadataFile()->getPathname())) {
			throw new \Exception(__('plugins.importexport.jats.failedToParseXMLDocument'));
		}

		// Checks whether the loaded document is supported by the parser (the doctype should match)
		$docType = $this->_document->doctype;
		$supportedDocTypes = $this->getDocType();
		$found = false;
		foreach ($supportedDocTypes as $supportedDocType) {
			if ([$docType->systemId, $docType->publicId, $docType->name] == [$supportedDocType->systemId, $supportedDocType->publicId, $supportedDocType->name]) {
				$found = true;
				break;
			}
		}
		if (!$found) {
			throw new InvalidDocTypeException(__('plugins.importexport.articleImporter.invalidDoctype'));
		}

		$this->_xpath = new \DOMXPath($this->_document);
		return $this;
	}

	/**
	 * Evaluates and retrieves the given XPath expression
	 * @param string $path XPath expression
	 * @param \DOMNode $context Optional context node
	 * @return mixed
	 */
	public function evaluate(string $path, ?\DOMNode $context = null)
	{
		return $this->_xpath->evaluate($path, $context);
	}

	/**
	 * Evaluates and retrieves the given XPath expression as a trimmed and tag stripped string
	 * The path is expected to target a single node
	 * @param string $path XPath expression
	 * @param \DOMNode $context Optional context node
	 * @return string
	 */
	public function selectText(string $path, ?\DOMNode $context = null): string
	{
		return \strip_tags(\trim($this->evaluate("string($path)", $context)));
	}

	/**
	 * Retrieves the nodes that match the given XPath expression
	 * @param string $path XPath expression
	 * @param \DOMNode $context Optional context node
	 * @return \DOMNodeList
	 */
	public function select(string $path, ?\DOMNode $context = null): \DOMNodeList
	{
		return $this->_xpath->query($path, $context);
	}

	/**
	 * Query the given XPath expression and retrieves the first item
	 * @param string $path XPath expression
	 * @param \DOMNode $context Optional context node
	 * @return object|null
	 */
	public function selectFirst(string $path, ?\DOMNode $context = null): ?object
	{
		return $this->select($path, $context)->item(0);
	}

	/**
	 * Checks if the submission isn't already registered using the public IDs
	 * @throws \Exception Throws when a submission with the same public ID is found
	 * @return Parser
	 */
	public function _ensureSubmissionDoesNotExist(): self
	{
		foreach ($this->getPublicIds() as $type => $id) {
			if (\Application::getSubmissionDAO()->getByPubId($type, $id, $this->getContextId())) {
				throw new AlreadyExistsException(__('plugins.importexport.articleImporter.alreadyExists', ['type' => $type, 'id' => $id]));
			}
		}
		return $this;
	}

	/**
	 * Retrieves the context ID
	 * @return int
	 */
	public function getContextId(): int
	{
		return $this->_contextId;
	}

	/**
	 * Tries to map the given locale to the PKP standard, returns the default locale if it fails or if the parameter is null
	 * @param string $locale
	 * @return string
	 */
	public function getLocale(?string $locale = null): string
	{
		if ($locale && !\PKPLocale::isLocaleValid($locale)) {
			$locale = strtolower($locale);
			// Tries to convert from recognized formats
			$iso3 = \PKPLocale::getIso3FromIso1($locale) ?: \PKPLocale::getIso3FromLocale($locale);
			// If the language part of the locale is the same (ex. fr_FR and fr_CA), then gives preference to context's locale
			$locale = $iso3 == \PKPLocale::getIso3FromLocale($this->_locale) ? $this->_locale : \PKPLocale::getLocaleFromIso3($iso3);
		}
		return $locale ?: $this->_locale;
	}

	/**
	 * Retrieves the configuration instance
	 * @return Configuration
	 */
	public function getConfiguration(): Configuration
	{
		return $this->_configuration;
	}

	/**
	 * Retrieves the article entry instance
	 * @return ArticleEntry
	 */
	public function getArticleEntry(): ArticleEntry
	{
		return $this->_entry;
	}

	/**
	 * Includes a section into the issue custom order
	 * @param \Section $section
	 */
	public function includeSection(\Section $section): void
	{
		static $cache = [];

		// If the section wasn't included into the issue yet
		if (!isset($cache[$this->getIssue()->getId()][$section->getId()])) {
			// Adds it to the list
			$cache[$this->getIssue()->getId()][$section->getId()] = true;
			$sectionDao = \Application::getSectionDAO();
			// Checks whether the section is already present in the issue
			if (!$sectionDao->getCustomSectionOrder($this->getIssue()->getId(), $section->getId())) {
				$sectionDao->insertCustomSectionOrder($this->getIssue()->getId(), $section->getId(), count($cache[$this->getIssue()->getId()]));
			}
		}
	}

	/**
	 * Manually evaluates the textContent of the node with the help of a transformation callback
	 * @param \DOMNode|null $node
	 * @param callable $callback The callback will receive two arguments, the current node being parsed and the already transformed textContent of it
	 */
	public function getTextContent(?\DOMNode $node, callable $callback){
		if (!$node) {
			return null;
		}
		if ($node instanceof \DOMText) {
			return htmlspecialchars($node->textContent, ENT_HTML5 | ENT_NOQUOTES);
		}
		$data = '';
		foreach($node->childNodes ?? [] as $child) {
			$data .= $this->getTextContent($child, $callback);
		}
		return $callback($node, $data);
	}

	/**
	 * Looks in $issueFolder for a cover image, and applies it to $issue if found
	 * @param string $issueFolder
	 * @param \Issue $issue
	 * @return void
	 */
	public function setIssueCover(string $issueFolder, \Issue &$issue) {
		$issueDao = \DAORegistry::getDAO('IssueDAO');
		$issueCover = null;
		foreach ($this->getConfiguration()->getImageExtensions() as $ext) {
			$checkFile = $issueFolder.DIRECTORY_SEPARATOR.$this->getConfiguration()->getIssueCoverFilename().'.'.$ext;
			if (file_exists($checkFile)) {
				$issueCover = $checkFile;
				break;
			}
		}
		if ($issueCover) {
			import('classes.file.PublicFileManager');
			$publicFileManager = new \PublicFileManager();
			$fileparts = explode('.', $issueCover);
			$ext = array_pop($fileparts);
			$newFileName = 'cover_issue_' . $issue->getId() . '_' . $this->getLocale() . '.' . $ext;
			$publicFileManager->copyContextFile($this->getContextId(), $issueCover, $newFileName);
			$issue->setCoverImage($newFileName, $this->getLocale());
			$issueDao->updateObject($issue);	
		}
	}
	

	/**
	 * Find a Genre ID for a context and extension
	 * @param $contextId
	 * @param $extension
	 * @return int
	 */
	protected function _getGenreId($contextId, $extension) {

		if (isset($this->_cachedGenres[$contextId][$extension])) {
			return $this->_cachedGenres[$contextId][$extension];
		}

		$genreDao = \DAORegistry::getDAO('GenreDAO');
		if (in_array($extension, $this->getConfiguration()->getImageExtensions())) {
			$genre = $genreDao->getByKey('IMAGE', $contextId);
			$genreId = $genre->getId();
		} else {
			$genre = $genreDao->getByKey('MULTIMEDIA', $contextId);
			$genreId = $genre->getId();
		}
		$this->_cachedGenres[$contextId][$extension] = $genreId;
		return $genreId;
	}

	/**
	 * Creates a default author for articles with no authors
	 * @param \Publication $publication
	 * @return \Author
	 */
	protected function _createDefaultAuthor(\Publication $publication): \Author
	{
		$authorDao = \DAORegistry::getDAO('AuthorDAO');
		$author = $authorDao->newDataObject();
		$author->setData('givenName', $this->getConfiguration()->getContext()->getName($this->getLocale()), $this->getLocale());
		$author->setData('seq', 1);
		$author->setData('publicationId', $publication->getId());
		$author->setData('email', $this->getConfiguration()->getEmail());
		$author->setData('includeInBrowse', true);
		$author->setData('primaryContact', true);
		$author->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());

		$authorDao->insertObject($author);
		return $author;
	}

}
