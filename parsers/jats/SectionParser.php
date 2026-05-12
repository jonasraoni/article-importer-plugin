<?php
/**
 * @file parsers/jats/SectionParser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SectionParser
 * @brief Handles parsing and importing the sections
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\plugins\importexport\articleImporter\EntityManager;
use APP\section\Section;
use APP\facades\Repo;

trait SectionParser
{
    use EntityManager;

    /** @var Section Section instance */
    private ?Section $_section = null;

    /**
     * Parses and retrieves the section, if a section with the same name exists, it will be retrieved
     */
    public function getSection(): Section
    {
        if ($this->_section) {
            return $this->_section;
        }

        $sectionName = null;
        $locale = $this->getLocale();

        if ($this->getConfiguration()->useCategoryAsSection()) {
            // Retrieves the section name and locale
            $node = $this->selectFirst('front/article-meta/article-categories/subj-group');
            if ($node) {
                $sectionName = ucwords(strtolower($this->selectText('subject', $node)));
                $locale = $this->getLocale($node->getAttribute('xml:lang'));
            }
        }

        $sectionName = $sectionName ?: $this->getIssueMeta()['section'] ?: $this->getConfiguration()->getDefaultSectionName();
        // Tries to find an entry in the cache
        if ($this->_section = $this->getCachedSection($sectionName)) {
            return $this->_section;
        }

        // Creates a new section
        $section = Repo::section()->newDataObject();
        $section->setData('contextId', $this->getContextId());
        $section->setData('title', $sectionName, $locale);
        $section->setData('abbrev', strtoupper(substr($sectionName, 0, 3)), $locale);
        $section->setData('abstractsNotRequired', true);
        $section->setData('metaIndexed', true);
        $section->setData('metaReviewed', false);
        $section->setData('policy', __('section.default.policy'), $this->getLocale());
        $section->setData('editorRestricted', true);
        $section->setData('hideTitle', false);
        $section->setData('hideAuthor', false);
        Repo::section()->add($section);
        $this->trackEntity($section);
        $this->setCachedSection($sectionName, $section, $this->getIssue());
        return $this->_section = $section;
    }
}
