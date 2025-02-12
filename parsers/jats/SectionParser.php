<?php
/**
 * @file parsers/jats/SectionParser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SectionParser
 * @brief Handles parsing and importing the sections
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\section\Section;
use APP\core\Application;
use APP\facades\Repo;

trait SectionParser
{
    /** @var bool True if the section was created by this instance */
    private bool $_isSectionOwner = false;

    /** @var Section Section instance */
    private ?Section $_section = null;

    /**
     * Rollbacks the operation
     */
    private function _rollbackSection(): void
    {
        if ($this->_isSectionOwner) {
            Application::getSectionDAO()->deleteObject($this->_section);
        }
    }

    /**
     * Parses and retrieves the section, if a section with the same name exists, it will be retrieved
     */
    public function getSection(): Section
    {
        static $cache = [];

        if ($this->_section) {
            return $this->_section;
        }

        $sectionName = null;
        $locale = $this->getLocale();

        // Retrieves the section name and locale
        $node = $this->selectFirst('front/article-meta/article-categories/subj-group');
        if ($node) {
            $sectionName = ucwords(strtolower($this->selectText('subject', $node)));
            $locale = $this->getLocale($node->getAttribute('xml:lang'));
        }

        // CUSTOM: Section names have two languages, splitted by "/", where the second is "en"
        $sectionName = preg_split('@\s*/\s*@', $sectionName ?: $this->getConfiguration()->getDefaultSectionName(), 2);

        $sectionNames = [];
        $sectionNames[$locale] = reset($sectionName);
        if (count($sectionName) > 1) {
            $sectionNames['en'] = end($sectionName);
        }

        // Tries to find an entry in the cache
        foreach ($sectionNames as $locale => $title) {
            if ($this->_section = $cache[$this->getContextId()][$locale][$title] ?? null) {
                break;
            }
        }

        if (!$this->_section) {
            // Tries to find an entry in the database
            foreach ($sectionNames as $locale => $title) {
                if ($this->_section = Repo::section()->getCollector()->filterByTitles([$title])->filterByContextIds([$this->getContextId()])->getMany()->first()) {
                    break;
                }
            }
        }

        if (!$this->_section) {
            // Creates a new section
            $section = Repo::section()->dao->newDataObject();
            $section->setData('contextId', $this->getContextId());

            foreach ($sectionNames as $locale => $title) {
                $section->setData('title', $title, $locale);
                $section->setData('abbrev', strtoupper(substr($title, 0, 3)), $locale);
            }
            $section->setData('abstractsNotRequired', true);
            $section->setData('metaIndexed', true);
            $section->setData('metaReviewed', false);
            $section->setData('policy', __('section.default.policy'), $this->getLocale());
            $section->setData('editorRestricted', true);
            $section->setData('hideTitle', false);
            $section->setData('hideAuthor', false);

            Repo::section()->add($section);
            $this->_section = $section;
        }

        // Includes the section into the issue's custom order
        $this->includeSection($this->_section);

        // Caches the entry
        foreach ($sectionNames as $locale => $title) {
            $cache[$this->getContextId()][$locale][$title] = $this->_section;
        }

        return $this->_section;
    }
}
