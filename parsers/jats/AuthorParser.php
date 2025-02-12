<?php
/**
 * @file parsers/jats/AuthorParser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class AuthorParser
 * @brief Handles parsing and importing the authors
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\publication\Publication;
use PKP\db\DAORegistry;
use APP\facades\Repo;

trait AuthorParser
{
    /** @var int Keeps the count of inserted authors */
    private $_authorCount = 0;

    /**
     * Processes all the authors
     */
    private function _processAuthors(\Publication $publication): void
    {
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
     */
    private function _processAuthor(\Publication $publication, \DOMNode $authorNode): \Author
    {
        $node = $this->selectFirst('name|string-name', $authorNode);

        $firstName = $this->selectText('given-names', $node);
        $lastName = $this->selectText('surname', $node);
        if ($lastName && !$firstName) {
            $firstName = $lastName;
            $lastName = '';
        } elseif (!$lastName && !$firstName) {
            $firstName = $this->getConfiguration()->getContext()->getName($this->getLocale());
        }
        $email = null;
        $affiliations = [];

        // Try to retrieve the affiliation and email
        foreach ($this->select('xref', $authorNode) as $node) {
            $id = $node->getAttribute('rid');
            switch ($node->getAttribute('ref-type')) {
                case 'aff':
                    $affiliation = $this->selectText("../aff[@id='${id}']//institution", $authorNode) ?: $this->selectText("front/article-meta/aff[@id='${id}']//institution");
                    if ($affiliation) {
                        $affiliations[] = $affiliation;
                    }
                    break;
                case 'corresp':
                    $email = $this->selectText("front/article-meta/author-notes/corresp[@id='${id}']//email");
                    break;
            }
        }

        $email = $email ?: $this->selectText('email', $authorNode) ?: $this->getConfiguration()->getEmail();

        $author = Repo::author()->dao->newDataObject();
        $author->setData('givenName', $firstName, $this->getLocale());
        if ($lastName) {
            $author->setData('familyName', $lastName, $this->getLocale());
        }
        //$author->setData('preferredPublicName', "", $this->getLocale());
        $author->setData('email', $email);
        $author->setData('affiliation', implode('; ', $affiliations), $this->getLocale());
        $author->setData('seq', $this->_authorCount + 1);
        $author->setData('publicationId', $publication->getId());
        $author->setData('includeInBrowse', true);
        $author->setData('primaryContact', !$this->_authorCount);
        $author->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());

        Repo::author()->add($author);
        ++$this->_authorCount;
        return $author;
    }
}
