<?php
/**
 * @file plugins/importexport/articleImporter/parsers/aPlusPlus/SectionParser.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SectionParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the sections
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\APlusPlus;

trait SectionParser {
	/** @var bool True if the section was created by this instance */
	private $_isSectionOwner;
	/** @var \Section Section instance */
	private $_section;
	
	/**
	 * Rollbacks the operation
	 */
	private function _rollbackSection(): void
	{
		if ($this->_isSectionOwner) {
			\Application::getSectionDAO()->deleteObject($this->_section);
		}
	}

	/**
	 * Parses and retrieves the section, if a section with the same name exists, it will be retrieved
	 * @return \Section
	 */
	public function getSection(): \Section
	{
		static $cache = [];

		if ($this->_section) {
			return $this->_section;
		}

		$sectionName = null;
		$locale = $this->getLocale();

		// Retrieves the section name and locale
		$node = $this->selectFirst('Journal/Volume/Issue/Article/ArticleInfo/ArticleCategory');
		if ($node) {
			$sectionName = ucwords(strtolower($this->selectText('.', $node)));
			$locale = $this->getLocale($node->getAttribute('Language'));
		}

		// CUSTOM: Section names have two languages, splitted by "/", where the second is "en_US"
		$sectionName = preg_split('@\s*/\s*@', $sectionName ?: $this->getConfiguration()->getDefaultSectionName(), 2);

		$sectionNames = [];
		$sectionNames[$locale] = reset($sectionName);
		if (count($sectionName) > 1) {
			$sectionNames['en_US'] = end($sectionName);
		}

		// Tries to find an entry in the cache
		foreach ($sectionNames as $locale => $title) {
			if ($this->_section = $cache[$this->getContextId()][$locale][$title] ?? null) {
				break;
			}
		}

		if (!$this->_section) {
			// Tries to find an entry in the database
			$sectionDao = \Application::getSectionDAO();
			foreach ($sectionNames as $locale => $title) {
				if ($this->_section = $sectionDao->getByTitle($title, $this->getContextId(), $locale)) {
					break;
				}
			}
		}

		if (!$this->_section) {
			// Creates a new section
			\AppLocale::requireComponents(\LOCALE_COMPONENT_APP_DEFAULT);
			$section = $sectionDao->newDataObject();
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

			$sectionDao->insertObject($section);

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
