<?php
/**
 * @file parsers\aPlusPlus\Parser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Parser
 * @brief Parser class, aggregates all the sub-parsers
 */

namespace APP\plugins\importexport\articleImporter\parsers\aPlusPlus;

use APP\plugins\importexport\articleImporter\BaseParser;

class Parser extends BaseParser
{
    // Aggregates the parsers
    use PublicationParser;
    use IssueParser;
    use SectionParser;
    use SubmissionParser;
    use AuthorParser;

    /**
     * Retrieves the DOCTYPE
     *
     * @return array \DOMDocumentType[]
     */
    public function getDocType(): array
    {
        return [(new \DOMImplementation())->createDocumentType('Publisher', '-//Springer-Verlag//DTD A++ V2.4//EN', 'http://devel.springer.de/A++/V2.4/DTD/A++V2.4.dtd')];
    }

    /**
     * Rollbacks the process
     */
    public function rollback(): void
    {
        $this->_rollbackSection();
        $this->_rollbackIssue();
        $this->_rollbackSubmission();
    }

    /**
     * Given a nodes with month/year/day, tries to form a valid date string and retrieve a DateTimeImmutable
     */
    public function getDateFromNode(?\DOMNode $node): ?\DateTimeImmutable
    {
        if (!$node || !strlen($year = $this->selectText('Year', $node))) {
            return null;
        }

        $year = min((int) $year, date('Y'));
        $month = str_pad(max((int) $this->selectText('Month', $node), 1), 2, '0', \STR_PAD_LEFT);
        $day = str_pad(max((int) $this->selectText('Day', $node), 1), 2, '0', \STR_PAD_LEFT);

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

        return new \DateTimeImmutable($year . '-' . $month . '-' . $day);
    }
}
