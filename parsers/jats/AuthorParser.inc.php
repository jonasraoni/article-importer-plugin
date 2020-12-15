<?php
/**
 * @file plugins/importexport/articleImporter/parsers/jats/AuthorParser.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class AuthorParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the authors
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\Jats;

trait AuthorParser {
	/** @var int Keeps the count of inserted authors */
	private $_authorCount = 0;

	/**
	 * Processes all the authors
	 * @param \Publication $publication
	 */
	private function _processAuthors(\Publication $publication): void
	{
		$authorDao = \DAORegistry::getDAO('AuthorDAO');
		$firstAuthor = null;
		foreach ($this->select("front/article-meta/contrib-group[@content-type='authors']/contrib|front/article-meta/contrib-group/contrib[@contrib-type='author']") as $node) {
			$author = $this->_processAuthor($publication, $node);
			$firstAuthor ?? $firstAuthor = $author;
		}
		// If there's no authors, create a default author
		$firstAuthor ?? $firstAuthor = $this->_createDefaultAuthor($publication);
		$publication->setData('primaryContactId', $firstAuthor->getId());
	}

	/**
	 * Handles an author node
	 * @param \Publication $publication
	 * @param \DOMNode $authorNode
	 * @return \Author
	 */
	private function _processAuthor(\Publication $publication, \DOMNode $authorNode): \Author
	{
		$node = $this->selectFirst('name|string-name', $authorNode);
		
		$firstName = $this->selectText('given-names', $node);
		$lastName = $this->selectText('surname', $node);
		if ($lastName && !$firstName) {
			$firstName = $lastName;
			$lastName = '';
		} else if (!$lastName && !$firstName) {
			$firstName = $this->getConfiguration()->getContext()->getName($this->getLocale());
		}
		$email = null;
		$affiliation = null;

		// Try to retrieve the affiliation and email
		foreach ($this->select('xref', $authorNode) as $node) {
			$id = $node->getAttribute('rid');
			switch ($node->getAttribute('ref-type')) {
				case 'aff':
					$affiliation = $this->selectText("front/article-meta/aff[@id='$id']//institution");
					break;
				case 'corresp':
					$email = $this->selectText("front/article-meta/author-notes/corresp[@id='$id']//email");
					break;
			}
		}

		$authorDao = \DAORegistry::getDAO('AuthorDAO');
		$author = $authorDao->newDataObject();
		$author->setData('givenName', $firstName, $this->getLocale());
		$author->setData('familyName', $lastName, $this->getLocale());
		//$author->setData('preferredPublicName', "", $this->getLocale());
		$author->setData('email', $email ?: $this->getConfiguration()->getEmail());
		$author->setData('affiliation', $affiliation, $this->getLocale());
		$author->setData('seq', $this->_authorCount + 1);
		$author->setData('publicationId', $publication->getId());
		$author->setData('includeInBrowse', true);
		$author->setData('primaryContact', !$this->_authorCount);
		$author->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());

		$authorDao->insertObject($author);
		++$this->_authorCount;
		return $author;
	}
}
