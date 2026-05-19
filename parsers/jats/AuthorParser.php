<?php
/**
 * @file parsers/jats/AuthorParser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class AuthorParser
 * @brief Handles parsing and importing the authors
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\author\Author;
use APP\publication\Publication;
use APP\facades\Repo;
use DOMElement;
use DOMNode;

trait AuthorParser
{
    /** @var int Keeps the count of inserted authors */
    private int $_authorCount = 0;

    /**
     * Processes all the authors
     */
    private function _processAuthors(Publication $publication): void
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
    private function _processAuthor(Publication $publication, DOMNode $authorNode): Author
    {
        $node = $this->selectFirst('name|string-name', $authorNode);

        $firstName = $this->selectText('given-names', $node);
        $lastName = $this->selectText('surname', $node);
        $prefix = $this->selectText('prefix', $node);
        $suffix = $this->selectText('suffix', $node);
        if ($lastName && !$firstName) {
            $firstName = $lastName;
            $lastName = '';
        } elseif (!$lastName && !$firstName) {
            $firstName = $this->getConfiguration()->getContext()->getName($this->getLocale());
        }
        $firstName = ($prefix ? "{$prefix} " : '') . $firstName;
        $lastName = $lastName . ($suffix ? " {$suffix}" : '');
        $email = $this->selectText('email', $authorNode);
        $orcid = $this->selectText(".//uri[@content-type='orcid']", $authorNode);
        $affiliations = [];
        $biography = null;

        $creditRoles = [];
        /** @var DOMElement $node */
        foreach ($this->select('role', $authorNode) as $node) {
            if (!($role = $this->getCreditRole($node->getAttribute('content-type')) ?: $this->getCreditRole($node->textContent))) {
                error_log("Unrecognized credit role: {$node->textContent}");
                continue;
            }
            $creditRoles[] = ['role' => $role];
        }

        // Try to retrieve the affiliation and email
        /** @var DOMElement $node */
        foreach ($this->select('xref', $authorNode) as $node) {
            $id = $node->getAttribute('rid');
            switch ($node->getAttribute('ref-type')) {
                case 'aff':
                    $affiliationNode = $this->selectFirst("../aff[@id='{$id}']", $authorNode) ?: $this->selectFirst("front/article-meta/aff[@id='{$id}']");
                    if (!$affiliationNode) {
                        break;
                    }
                    $affiliation = $this->selectText(".//institution", $affiliationNode) ?: $this->selectText(".", $affiliationNode);
                    if ($affiliation) {
                        $affiliations[] = $affiliation;
                    }
                    break;
                case 'corresp':
                    $email = $email ?: $this->selectText("front/article-meta/author-notes/corresp[@id='{$id}']//email");
                    break;
                case 'fn':
                    /** @var DOMElement $node */
                    if ($node = $this->selectFirst("back/fn-group/fn[@id='{$id}']")) {
                        $node = $node->cloneNode(true);
                        /** @var DOMElement */
                        foreach ($node->getElementsByTagName('email') as $emailNode) {
                            $email = $email ?: $emailNode->textContent;
                        }
                        $this->convertJatsToHtml($node);
                        $fragment = $node->ownerDocument->createDocumentFragment();
                        foreach (iterator_to_array($node->childNodes) as $childNode) {
                            $fragment->appendChild($childNode);
                        }
                        $biography = $node->ownerDocument->saveHTML($fragment);
                    }
            }
        }

        foreach ($this->select('sup', $authorNode) as $node) {
            $affiliation = '';
            foreach ($this->select("../aff/label[.='{$node->textContent}']/following-sibling::node()", $authorNode) as $node) {
                $affiliation .= $node->textContent;
            }
            if ($affiliation = preg_replace(['/\r\n|\n\r|\r|\n/', '/\s{2,}/', '/\s+([,.])/'], [' ', ' ', '$1'], trim($affiliation))) {
                $affiliations[] = $affiliation;
            }
        }

        $email = $email ?: $this->getConfiguration()->getEmail();

        $author = Repo::author()->newDataObject();
        $author->setData('givenName', $firstName, $this->getLocale());
        if ($lastName) {
            $author->setData('familyName', $lastName, $this->getLocale());
        }

        if ($orcid) {
            $author->setData('orcid', $orcid);
        }

        $author->setData('email', $email);
        $author->setData('biography', $biography, $this->getLocale());
        $author->setData('seq', $this->_authorCount + 1);
        $author->setData('publicationId', $publication->getId());
        $author->setData('includeInBrowse', true);
        $author->setData('primaryContact', !$this->_authorCount);
        $author->setData('userGroupId', $this->getConfiguration()->getAuthorGroupId());
        $author->setData('creditRoles', $creditRoles);
        $authorId = Repo::author()->add($author);
        $author = Repo::author()->get($authorId);
        $affiliationObjects = [];
        foreach ($affiliations as $name) {
            $affiliation = Repo::affiliation()->newDataObject(['authorId' => $author->getId()]);
            $ror = $this->getCachedROR($name);
            if ($ror) {
                $affiliation->setRor($ror->getRor());
            } else {
                $affiliation->setName($name, $this->getLocale());
            }
            $affiliationObjects[] = $affiliation;
        }
        $author->setAffiliations($affiliationObjects);
        Repo::author()->edit($author);
        ++$this->_authorCount;
        return $author;
    }

    private function getCreditRole(?string $role): ?string
    {
        $roles = [
            'https://credit.niso.org/contributor-roles/conceptualization/' => 'conceptualization',
            'https://credit.niso.org/contributor-roles/data-curation/' => 'data curation',
            'https://credit.niso.org/contributor-roles/formal-analysis/' => 'formal analysis',
            'https://credit.niso.org/contributor-roles/funding-acquisition/' => 'funding acquisition',
            'https://credit.niso.org/contributor-roles/investigation/' => 'investigation',
            'https://credit.niso.org/contributor-roles/methodology/' => 'methodology',
            'https://credit.niso.org/contributor-roles/project-administration/' => 'project administration',
            'https://credit.niso.org/contributor-roles/resources/' => 'resources',
            'https://credit.niso.org/contributor-roles/software/' => 'software',
            'https://credit.niso.org/contributor-roles/supervision/' => 'supervision',
            'https://credit.niso.org/contributor-roles/validation/' => 'validation',
            'https://credit.niso.org/contributor-roles/visualization/' => 'visualization',
            'https://credit.niso.org/contributor-roles/writing-original-draft/' => 'writing – original draft',
            'https://credit.niso.org/contributor-roles/writing-original-draft/' => 'writing – original draft preparation',
            'https://credit.niso.org/contributor-roles/writing-review-editing/' => 'writing – review & editing'
        ];
        return array_key_exists($role = strtolower($role), $roles) ? $role : (array_search($role, $roles) ?: null);
    }
}
