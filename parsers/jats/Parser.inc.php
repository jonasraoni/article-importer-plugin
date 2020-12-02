<?php
/**
 * @file plugins/importexport/articleImporter/Parser.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Parser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Parser class, aggregates all the sub-parsers
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\Jats;

use \PKP\Plugins\ImportExport\ArticleImporter\BaseParser;

class Parser extends BaseParser {
	// Aggregates the parsers
	use PublicationParser, IssueParser, SectionParser, SubmissionParser, AuthorParser;

	/**
	 * Retrieves the DOCTYPE
	 * @return array \DOMDocumentType[]
	 */
	public function getDocType(): array
	{
		return [
			(new \DOMImplementation)->createDocumentType('article', '-//EDP//DTD EDP Publishing JATS v1.0 20130606//EN', 'JATS-edppublishing1.dtd'),
			(new \DOMImplementation)->createDocumentType('article', '-//NLM//DTD Journal Archiving with OASIS Tables v3.0 20080202//EN', 'http://dtd.nlm.nih.gov/archiving/3.0/archive-oasis-article3.dtd'),
		];
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
	 * @param \DOMNode|null $node
	 * @return \DateTimeImmutable|null
	 */
	public function getDateFromNode(?\DOMNode $node): ?\DateTimeImmutable
	{
		if (!$node || !strlen($year = $this->selectText('year', $node))) {
			return null;
		}

		$year = min((int) $year, date('Y'));
		$month = str_pad(max((int) $this->selectText('month', $node), 1), 2, '0', \STR_PAD_LEFT);
		$day = str_pad(max((int) $this->selectText('day', $node), 1), 2, '0', \STR_PAD_LEFT);

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
