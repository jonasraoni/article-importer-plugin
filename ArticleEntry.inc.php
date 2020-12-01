<?php
/**
 * @file plugins/importexport/articleImporter/ArticleEntry.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleEntry
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Glues together the volume/issue/article numbers and the article files
 */

namespace PKP\Plugins\ImportExport\ArticleImporter;

use \PKP\Plugins\ImportExport\ArticleImporter\Exceptions\{InvalidDocTypeException, NoSuitableParserException};

class ArticleEntry {
	/** @var \SplFileInfo[] List of files */
	private $_files = [];
	/** @var int The article's number */
	private $_volume;
	/** @var int The issue's number */
	private $_issue;
	/** @var int The issue's volume */
	private $_article;

	/**
	 * Constructor
	 * @param int $volume The issue's volume
	 * @param int $issue The issue's number
	 * @param int $article The article's number
	 */
	public function __construct(int $volume, int $issue, int $article)
	{
		$this->_volume = $volume;
		$this->_issue = $issue;
		$this->_article = $article;
	}

	/**
	 * Adds a file to the list
	 * @param \SplFileInfo $file
	 */
	public function addFile(\SplFileInfo $file): void
	{
		$this->_files[] = $file;
	}

	/**
	 * Retrieves the file list
	 * @return \SplFileInfo[]
	 */
	public function getFiles(): array
	{
		return $this->_files;
	}

	/**
	 * Retrieves the issue volume
	 * @return int
	 */
	public function getVolume(): int
	{
		return $this->_volume;
	}

	/**
	 * Retrieves the issue number
	 * @return int
	 */
	public function getIssue(): int
	{
		return $this->_issue;
	}

	/**
	 * Retrieves the article number
	 * @return int
	 */
	public function getArticle(): int
	{
		return $this->_article;
	}

	/**
	 * Returns the path to the folder containing the article files
	 * @return string
	 */
	public function getSubmissionPath(): string
	{
		return dirname($this->getSubmissionFile()->getPathname());
	}

	/**
	 * Retrieves the submission file
	 * @throws \Exception Throws if there's more than one submission file
	 * @return \SplFileInfo
	 */
	public function getSubmissionFile(): \SplFileInfo
	{
		$count = count($paths = array_filter($this->_files, function ($path) {
			return preg_match('/\.pdf$/i', $path);
		}));
		if ($count != 1) {
			throw new \Exception(__('plugins.importexport.articleImporter.unexpectedGalley', ['count' => $count]));
		}
		return reset($paths);
	}

	/**
	 * Retrieves the metadata file
	 * @throws \Exception Throws if there's more than one metadata file
	 * @return \SplFileInfo
	 */
	public function getMetadataFile(): \SplFileInfo
	{
		$count = count($paths = array_filter($this->_files, function ($path) {
			return preg_match('/\.(meta|xml)$/i', $path);
		}));
		if ($count != 1) {
			throw new \Exception(__('plugins.importexport.articleImporter.unexpectedMetadata', ['count' => $count]));
		}
		return reset($paths);
	}

	/**
	 * Processes the entry
	 * @throws NoSuitableParserException Throws if no parser could understand the format
	 * @return BaseParser
	 */
	public function process(Configuration $configuration): BaseParser
	{
		foreach ($configuration->getParsers() as $parser) {
			try {
				$instance = new $parser($configuration, $this);
				$instance->execute();
				return $instance;
			}
			catch (InvalidDocTypeException $e) {
				// If the parser cannot understand the format, try the next
				continue;
			}
		}
		// If no parser could understand the format
		throw new NoSuitableParserException(__('plugins.importexport.articleImporter.invalidDoctype'));
	}
}
