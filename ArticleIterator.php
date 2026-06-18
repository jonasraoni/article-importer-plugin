<?php
/**
 * @file ArticleIterator.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleIterator
 * @brief Article iterator, responsible to navigate through the volume/issue/article structure and group the article files.
 */

namespace APP\plugins\importexport\articleImporter;

use Generator;
use IteratorAggregate;
use SplFileInfo;

class ArticleIterator implements IteratorAggregate
{
    /** @var string The path */
    private string $path;
    /** @var bool Whether the article folders contain version sub-folders */
    private bool $hasVersion;
    /** @var bool Whether the structure contains a volume folder level */
    private bool $hasVolume;
    /** @var bool Whether the structure contains a number (issue) folder level */
    private bool $hasNumber;

    public function __construct(string $path, bool $hasVersion = true, bool $hasVolume = true, bool $hasNumber = true)
    {
        $this->path = $path;
        $this->hasVersion = $hasVersion;
        $this->hasVolume = $hasVolume;
        $this->hasNumber = $hasNumber;
    }

    /**
     * Retrieves the iterator
     * @return iterable<ArticleEntry>
     */
    public function getIterator(): Generator
    {
        // The article folder depth depends on which optional levels (volume/number) are present: [volume/][number/]article
        $depth = (int) $this->hasVolume + (int) $this->hasNumber + 1;
        $pattern = $this->path . str_repeat('/*', $depth);
        foreach (glob($pattern, GLOB_ONLYDIR) as $path) {
            $directory = new SplFileInfo($path);

            // Walk up the path to resolve the available levels (path order is volume/number/article)
            $article = $directory->getFilename();
            $parent = $directory->getPathInfo();
            $number = null;
            if ($this->hasNumber) {
                $number = $parent->getFilename();
                $parent = $parent->getPathInfo();
            }
            $volume = null;
            if ($this->hasVolume) {
                $volume = (int) $parent->getFilename();
            }

            yield new ArticleEntry($directory, $volume, $number, $article, $this->hasVersion);
        }
    }
}
