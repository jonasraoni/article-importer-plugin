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

    public function __construct(string $path, bool $hasVersion = true)
    {
        $this->path = $path;
        $this->hasVersion = $hasVersion;
    }

    /**
     * Retrieves the iterator
     * @return iterable<ArticleEntry>
     */
    public function getIterator(): Generator
    {
        // volume/issue/article
        foreach (glob("{$this->path}/*/*/*", GLOB_ONLYDIR) as $path) {
            yield new ArticleEntry(new SplFileInfo($path), $this->hasVersion);
        }
    }
}
