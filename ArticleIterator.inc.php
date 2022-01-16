<?php
/**
 * @file plugins/importexport/articleImporter/ArticleIterator.inc.php
 *
 * Copyright (c) 2014-2022 Simon Fraser University
 * Copyright (c) 2000-2022 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleIterator
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Article iterator, responsible to navigate through the volume/issue/article structure and group the article files.
 */

namespace PKP\Plugins\ImportExport\ArticleImporter;

class ArticleIterator extends \ArrayIterator
{
    /**
     * Constructor
     *
     * @param string $path The base import path
     */
    public function __construct(string $path)
    {
        parent::__construct($this->_getEntries($path));
    }

    /**
     * Retrieves a list of ArticleEntry with the paths that follow the folder convention
     *
     * @return ArticleEntry[]
     */
    private function _getEntries(string $path): array
    {
        $directoryIterator = new \RecursiveDirectoryIterator($path);
        $recursiveIterator = new \RecursiveIteratorIterator($directoryIterator, \RecursiveIteratorIterator::SELF_FIRST);
        // Ignores deeper folders
        $recursiveIterator->setMaxDepth(3);
        $articleEntries = [];
        foreach ($recursiveIterator as $file) {
            // Capture all files in the article folder, even though we just need the xml and pdf
            if ($recursiveIterator->getDepth() == 3 && $file->isFile()) {
                // Gets the three nearest parent folders of the file (article > issue > volume) and tries to extract a number/ID from each of them
                [$article, $issue, $volume] = array_map(function ($item) use ($file) {
                    // Fails if the folder doesn't have a number
                    if (!preg_match('/\d+/', $item->getFilename(), $order)) {
                        throw new \Exception(__('plugins.importexport.articleImporter.invalidStructure', ['path' => $file->getPath()]));
                    }
                    return array_shift($order);
                }, [$article = $file->getPathinfo(), $issue = $article->getPathinfo(), $volume = $issue->getPathinfo()]);

                $key = "${volume}-${issue}-${article}";
                ($articleEntries[$key] ?? $articleEntries[$key] = new ArticleEntry($volume, $issue, $article))
                    ->addFile($file);
            }
        }
        // Sorts the entries by key (at this point made up of "volume-issue-article")
        ksort($articleEntries, \SORT_NATURAL);

        return $articleEntries;
    }
}
