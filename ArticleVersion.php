<?php
/**
 * @file ArticleVersion.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleVersion
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Represents a specific version of an article with its associated files
 */

namespace APP\plugins\importexport\articleImporter;

use APP\plugins\importexport\articleImporter\exceptions\InvalidDocTypeException;
use APP\plugins\importexport\articleImporter\exceptions\NoSuitableParserException;
use Exception;
use FilesystemIterator;
use SplFileInfo;

class ArticleVersion
{
    /** @var ArticleEntry The parent article entry */
    private ArticleEntry $_articleEntry;
    /** @var SplFileInfo The version directory */
    private SplFileInfo $_directory;
    /** @var ?int Explicit version number, used when there's no version folder to derive it from */
    private ?int $_version;

    /**
     * Constructor
     *
     * @param ArticleEntry $articleEntry The parent article entry
     * @param SplFileInfo $directory The version directory (or the article directory when versions are not foldered)
     * @param ?int $version Explicit version number, falls back to the directory name when null
     */
    public function __construct(ArticleEntry $articleEntry, SplFileInfo $directory, ?int $version = null)
    {
        $this->_articleEntry = $articleEntry;
        $this->_directory = $directory;
        $this->_version = $version;
    }

    /**
     * Gets all files for this version
     *
     * @return SplFileInfo[] List of files
     */
    public function getFiles(): array
    {
        return array_values(iterator_to_array(new FilesystemIterator($this->_directory)));
    }

    /**
     * Gets the metadata file
     *
     * @return SplFileInfo The metadata file
     * @throws Exception If no metadata file is found
     */
    public function getMetadataFile(): SplFileInfo
    {
        $count = count($paths = array_filter($this->getFiles(), function ($path) {
            return preg_match('/\.xml$/i', $path);
        }));
        if ($count != 1) {
            throw new Exception(__('plugins.importexport.articleImporter.unexpectedMetadata', ['count' => $count]));
        }
        return reset($paths);
    }

    /**
     * Gets the submission file
     *
     * @return SplFileInfo|null The submission file or null if not found
     * @throws Exception If multiple submission files are found
     */
    public function getSubmissionFile(): ?SplFileInfo
    {
        $count = count($paths = array_filter($this->getFiles(), function ($path) {
            return preg_match('/\.pdf$/i', $path);
        }));
        if ($count > 1) {
            throw new Exception(__('plugins.importexport.articleImporter.unexpectedGalley', ['count' => $count]));
        }
        return reset($paths) ?: null;
    }

    /**
     * Gets the HTML files
     *
     * @return SplFileInfo[] List of HTML files
     */
    public function getHtmlFiles(): array
    {
        return array_values(array_filter($this->getFiles(), function ($path) {
            return preg_match('/\.html?$/i', $path);
        }));
    }

    /**
     * Gets the supplementary files
     *
     * @return SplFileInfo[] List of supplementary files
     */
    public function getSupplementaryFiles(): array
    {
        $metadataFile = $this->getMetadataFile();
        return is_dir($path = $metadataFile->getPathInfo() . '/supplementary')
            ? array_values(iterator_to_array(new FilesystemIterator($path)))
            : [];
    }

    /**
     * Gets the cover file
     *
     * @return SplFileInfo|null The cover file or null if not found
     * @throws Exception If multiple cover files are found
     */
    public function getSubmissionCoverFile(): ?SplFileInfo
    {
        $count = count($paths = array_filter($this->getFiles(), function ($path) {
            return preg_match('/cover\.[a-z]{3}/i', $path);
        }));
        if ($count > 1) {
            throw new Exception(__('plugins.importexport.articleImporter.unexpectedMetadata', ['count' => $count]));
        }
        return reset($paths) ?: null;
    }

    /**
     * Processes the version
     *
     * @throws NoSuitableParserException Throws if no parser could understand the format
     */
    public function process(Configuration $configuration): BaseParser
    {
        /** @var BaseParser */
        foreach ($configuration->getParsers() as $parser) {
            try {
                $instance = new $parser($configuration, $this);
                $instance->execute();
                return $instance;
            } catch (InvalidDocTypeException $e) {
                // If the parser cannot understand the format, try the next
                continue;
            }
        }
        // If no parser could understand the format
        throw new NoSuitableParserException(__('plugins.importexport.articleImporter.invalidDoctype'));
    }

    /**
     * Gets the parent article entry
     *
     * @return ArticleEntry The parent article entry
     */
    public function getArticleEntry(): ArticleEntry
    {
        return $this->_articleEntry;
    }

    /**
     * Gets the version directory path
     *
     * @return SplFileInfo The version directory
     */
    public function getPath(): SplFileInfo
    {
        return $this->_directory;
    }

    /**
     * Gets the version
     */
    public function getVersion(): int
    {
        return $this->_version ?? (int) $this->_directory->getFilename();
    }
}
