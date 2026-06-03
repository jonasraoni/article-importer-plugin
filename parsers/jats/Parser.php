<?php
/**
 * @file parsers/jats/Parser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Parser
 * @brief Parser class, aggregates all the sub-parsers
 */

namespace APP\plugins\importexport\articleImporter\parsers\jats;

use APP\plugins\importexport\articleImporter\BaseParser;
use DateTimeImmutable;
use DOMElement;
use DOMNode;
use DOMXPath;

class Parser extends BaseParser
{
    // Aggregates the parsers
    use PublicationParser;
    use IssueParser;
    use SectionParser;
    use SubmissionParser;
    use AuthorParser;

    /**
     * Retrieves whether the parser can deal with the underlying document
     */
    public function canParse(): bool
    {
        return (bool) $this->selectFirst('front/article-meta/title-group/article-title');
    }

    /**
     * Given a nodes with month/year/day, tries to form a valid date string and retrieve a DateTimeImmutable
     */
    public function getDateFromNode(?DOMNode $node, DOMXPath $xpath = null): ?DateTimeImmutable
    {
        if (!$node || !strlen($year = $this->selectText('year', $node, $xpath))) {
            return null;
        }

        $year = min((int) $year, date('Y'));
        $month = str_pad(max((int) $this->selectText('month', $node, $xpath), 1), 2, '0', STR_PAD_LEFT);
        $day = str_pad(max((int) $this->selectText('day', $node, $xpath), 1), 2, '0', STR_PAD_LEFT);

        if ($year < 100) {
            $currentYear = date('Y');
            $year += (int)($currentYear / 100) * 100;
            if ($year > $currentYear) {
                $year -= 100;
            }
        }

        if (!checkdate($month, $day, $year)) {
            return null;
        }

        return new DateTimeImmutable($year . '-' . $month . '-' . $day);
    }

    /**
     * Convert JATS tags to HTML
     */
    public static function convertJatsToHtml(?DOMElement $node): ?DOMElement
    {
        if (!$node) {
            return null;
        }

        $document = $node->ownerDocument;
        /** @var DOMNode $current */
        foreach (iterator_to_array($node->getElementsByTagName('*')) as $current) {
            $new = null;
            if ($current->nodeType === XML_TEXT_NODE && (filter_var($textContent = trim($current->textContent), FILTER_VALIDATE_EMAIL) || filter_var($textContent, FILTER_VALIDATE_URL))) {
                $new = $document->createElement('a', $textContent);
                $new->setAttribute('href', $textContent);
            }

            /** @var DOMElement $current */
            switch ($current->tagName ?? null) {
                case 'p':
                case 'sub':
                case 'sup':
                    break;
                case 'title':
                    $new = $document->createElement('strong');
                    break;
                case 'bold':
                    $new = $document->createElement('b');
                    break;
                case 'italic':
                    $new = $document->createElement('i');
                    break;
                case 'strike':
                    $new = $document->createElement('s');
                    break;
                case 'underline':
                    $new = $document->createElement('u');
                    break;
                case 'list-item':
                    $new = $document->createElement('li');
                    break;
                case 'elocation-id':
                    $new = $document->createElement('span');
                    $new->setAttribute('hidden', '');
                    break;
                case 'overline':
                    $new = $document->createElement('span');
                    $new->setAttribute('style', 'text-decoration: overline');
                    break;
                case 'sc':
                    $new = $document->createElement('span');
                    $new->setAttribute('style', 'font-variant: small-caps');
                    break;
                case 'monospace':
                    $new = $document->createElement('span');
                    $new->setAttribute('style', 'font-family: monospace');
                    break;
                case 'ext-link':
                    $new = $document->createElement('a');
                    $new->setAttribute('href', $current->getAttributeNS('http://www.w3.org/1999/xlink', 'href') ?: $current->getAttribute('href'));
                    break;
                case 'email':
                    $new = $document->createElement('a');
                    $new->setAttribute('href', $current->getAttributeNS('http://www.w3.org/1999/xlink', 'href') ?: $current->getAttribute('href'));
                    break;
                case 'styled-content':
                    $new = $document->createElement('span');
                    $new->setAttribute('style', $current->getAttribute('style'));
                    break;
                case 'list':
                    $new = $document->createElement('ul');
                    if ($current->getAttribute('list-type') === 'order') {
                        $new = new DOMElement('ol');
                    }

                    break;
                case 'pub-id':
                    $new = $document->createElement('a');
                    $type = $current->attributes->getNamedItem('pub-id-type');
                    $baseUrls = [
                        'doi' => 'https://doi.org/',
                        'pmid' => 'https://pubmed.ncbi.nlm.nih.gov/',
                        'pmcid' => 'https://www.ncbi.nlm.nih.gov/pmc/articles/'
                    ];
                    $url = $baseUrls[$type->textContent] ?? '';
                    if (!$url) {
                        error_log('Unknown pub-id type');
                        $new->setAttribute('hidden', '');
                        break;
                    }

                    $url .= str_replace($url, '', $current->textContent);
                    $new->setAttribute('href', $url);
                    $current->textContent = $url;
                    break;
                case 'etal':
                    if (!$current->textContent) {
                        $current->appendChild($document->createElement('i'))->textContent = 'et al.';
                    }

                    $next = $current->nextSibling;
                    if ($next && trim($next->textContent) === '') {
                        $current->parentNode->removeChild($next);
                    }

                    break;
                case 'volume':
                    if ($current->firstChild === $current->lastChild) {
                        $current->appendChild($document->createElement('b'))->textContent = $current->textContent;
                        $current->removeChild($current->firstChild);
                    }
                    $current->parentNode->insertBefore($document->createTextNode(' '), $current);

                    break;
                case 'person-group':
                    $new = $document->createElement('span');
                    break;
                case 'name':
                    // Add commas to the end of names
                    $nextElement = $current->nextElementSibling;
                    if ($nextElement && in_array($nextElement->tagName, ['name', 'etal'])) {
                        for ($sibling = $current; ($sibling = $sibling->nextSibling) !== $nextElement && strpos($sibling->textContent, ',') === false;);

                        if ($sibling === $nextElement) {
                            $current->insertBefore($document->createTextNode(', '), $current->lastChild === $current->lastElementChild ? null : $current->lastChild);
                        }
                    }

                    // Remove empty spaces from the last element
                    if ($current->parentNode->lastElementChild === $current) {
                        if (trim($current->lastChild->textContent) === '') {
                            $current->removeChild($current->lastChild);
                        }

                        $next = $current->nextSibling;
                        if ($next && trim($next->textContent) === '') {
                            $current->parentNode->removeChild($next);
                        }
                    }

                    break;
                case 'fpage':
                    $current->parentNode->insertBefore($document->createTextNode(' '), $current);
                    break;
                case 'article-title':
                    $current->appendChild($document->createTextNode(' '));
                    break;
                default:
                    // Default behavior is to drop the unknown tag and leave its text
                    $new = $document->createDocumentFragment();
            }

            if ($new) {
                foreach (iterator_to_array($current->childNodes) as $child) {
                    $new->appendChild($child);
                }
                $current->parentNode->replaceChild($new, $current);
            }
        }

        return $node;
    }

    /**
     * Remove any xref tag from the given node
     */
    public function clearXref(DOMElement $node, bool $cloneNode = true): DOMElement
    {
        if ($cloneNode) {
            $node = $node->cloneNode(true);
        }
        /** @var DOMElement */
        foreach (iterator_to_array($node->getElementsByTagName('xref')) as $xref) {
            $xref->parentNode->removeChild($xref);
        }
        return $node;
    }
}
