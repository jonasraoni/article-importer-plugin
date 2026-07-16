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
use APP\plugins\importexport\articleImporter\ArticleImporterPlugin;
use APP\publication\Publication;
use APP\facades\Repo;
use DOMElement;
use DOMNode;
use Exception;
use PKP\author\contributorRole\ContributorRole;

trait AuthorParser
{
    /** @var int Keeps the count of inserted authors */
    private int $_authorCount = 0;

    /**
     * Processes all the authors
     */
    private function _processAuthors(Publication $publication): void
    {
        static $correspondingAuthorRole = null,$coAuthorRole = null;
        $correspondingAuthorRole ??= ContributorRole::query()
            ->withContextId($this->getContextId())
            ->where('name', 'Corresponding Author')
            ->first() ?? throw new Exception('Corresponding Author contributor role not found');
        $coAuthorRole ??= ContributorRole::query()
            ->withContextId($this->getContextId())
            ->where('name', 'Co-Author')
            ->first() ?? throw new Exception('Co-Author contributor role not found');
        $doi = $this->getPublicIds()['doi'] ?? null;
        $doi = explode('.', $doi);
        $version = array_pop($doi);
        $articleId = array_pop($doi);
        $connection = ArticleImporterPlugin::getOreConnection();
        $databaseEmails = $connection->table('f1000r_author', 'a')
            ->leftJoin('f1000r_author_version as av', 'a.id', '=', 'av.author_id')
            ->leftJoin('f1000r_version as v', 'av.version_id', '=', 'v.id')
            ->where('v.article_id', $articleId)
            ->where('v.version_number', $version)
            ->where('v.status', 'PUBLISHED')
            ->orderBy('av.author_position')
            ->pluck('a.email')
            ->all();

        $firstCorrespYesAuthor = $firstCorrespNotNoAuthor = null;
        $authors = [];
        foreach ($this->select("front/article-meta/contrib-group[@content-type='authors']/contrib|front/article-meta/contrib-group/contrib[@contrib-type='author']") as $node) {
            $databaseEmail = array_shift($databaseEmails);
            $author = $this->_processAuthor($publication, $node, $databaseEmail);
            $authors[] = $author;
            $corresp = mb_strtolower(trim($node->getAttribute('corresp') ?? ''));
            if ($corresp === 'yes' && !$firstCorrespYesAuthor) {
                $firstCorrespYesAuthor = $author;
            }
            if ($corresp !== 'no' && !$firstCorrespNotNoAuthor) {
                $firstCorrespNotNoAuthor = $author;
            }
        }
        // If there's no author, a default one will be created
        $primaryContactAuthor = count($authors) ? ($firstCorrespYesAuthor ?? $firstCorrespNotNoAuthor) : ($authors[] = $this->_createDefaultAuthor($publication));
        $publication->setData('primaryContactId', $primaryContactAuthor->getId());
        $primaryContactAuthor->setContributorRoles([$correspondingAuthorRole]);
        Repo::author()->edit($primaryContactAuthor);

        if (count($authors) > 1) {
            foreach ($authors as $author) {
                $author->setContributorRoles(array_merge($author->getContributorRoles(), [$coAuthorRole]));
                Repo::author()->edit($author);
            }
        }
    }

    /**
     * Handles an author node
     */
    private function _processAuthor(Publication $publication, DOMNode $authorNode, $databaseEmail = null): Author
    {
        $node = $this->selectFirst('name|string-name', $authorNode);

        $firstName = $this->selectText('given-names', $node);
        $lastName = $this->selectText('surname', $node);
        $prefix = $this->selectText('prefix', $node);
        $suffix = $this->selectText('suffix', $node);
        $collab = '';
        foreach ($this->select('collab/text()', $authorNode) as $textNode) {
            $collab .= $textNode->nodeValue;
        }
        if ($lastName && !$firstName) {
            $firstName = $lastName;
            $lastName = '';
        } elseif (!$lastName && !$firstName) {
            $firstName = $collab ?: $this->getConfiguration()->getContext()->getName($this->getLocale());
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
                    $labels = $affiliationNode->getElementsByTagName('label');
                    foreach ($labels as $label) {
                        $label->parentNode->removeChild($label);
                    }
                    $affiliations[] = $this->selectText(".//institution", $affiliationNode) ?: $this->selectText(".", $affiliationNode);
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

        $email = $email ?: $databaseEmail ?: $this->getConfiguration()->getEmail();

        $author = Repo::author()->newDataObject();
        $author->setData('givenName', $firstName, $this->getLocale());
        if ($lastName) {
            $author->setData('familyName', $lastName, $this->getLocale());
        }

        if ($orcid) {
            $author->setData('orcid', $orcid);
        }

        if ($competingInterests = $this->selectText('front/article-meta/author-notes/fn[@fn-type="conflict"]')) {
            $author->setData('competingInterests', $competingInterests, $this->getLocale());
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
        static $roles;
        if (!$roles) {
            $roles = [
                'conceptualization' => 'credit.niso.org/contributor-roles/conceptualization',
                'data curation' => 'credit.niso.org/contributor-roles/data-curation',
                'formal analysis' => 'credit.niso.org/contributor-roles/formal-analysis',
                'funding acquisition' => 'credit.niso.org/contributor-roles/funding-acquisition',
                'investigation' => 'credit.niso.org/contributor-roles/investigation',
                'methodology' => 'credit.niso.org/contributor-roles/methodology',
                'project administration' => 'credit.niso.org/contributor-roles/project-administration',
                'resources' => 'credit.niso.org/contributor-roles/resources',
                'software' => 'credit.niso.org/contributor-roles/software',
                'supervision' => 'credit.niso.org/contributor-roles/supervision',
                'validation' => 'credit.niso.org/contributor-roles/validation',
                'visualization' => 'credit.niso.org/contributor-roles/visualization',
                'writing – original draft' => 'credit.niso.org/contributor-roles/writing-original-draft',
                'writing – original draft preparation' => 'credit.niso.org/contributor-roles/writing-original-draft',
                'writing – review & editing' => 'credit.niso.org/contributor-roles/writing-review-editing',
            ];
            $roles += array_combine($roles, $roles);
        }
        $role = mb_strtolower($role ?? '');
        // Drop http prefix and trailing slash
        $role = preg_replace('#https?://|/$#', '', $role);
        return array_key_exists($role, $roles) ? "https://{$roles[$role]}/" : null;
    }
}
