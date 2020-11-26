<?php
/**
 * @file plugins/importexport/articleImporter/parsers/aPlusPlus/PublicationParser.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PublicationParser
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Handles parsing and importing the publications
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\APlusPlus;

trait PublicationParser {
	/**
	 * Parse, import and retrieve the publication
	 * @return \Publication
	 */
	public function getPublication(): \Publication
	{
		$publicationDate = $this->getPublicationDate() ?: $this->getIssue()->getDatePublished();

		// Create the publication
		$publication = \DAORegistry::getDAO('PublicationDAO')->newDataObject();
		$publication->setData('submissionId', $this->getSubmission()->getId());
		$publication->setData('status', \STATUS_PUBLISHED);
		$publication->setData('version', 1);
		$publication->setData('seq', $this->getSubmission()->getId());
		$publication->setData('accessStatus', $this->_getAccessStatus());
		$publication->setData('datePublished', $publicationDate->format(\DateTime::RFC3339));
		$publication->setData('sectionId', $this->getSection()->getId());
		$publication->setData('issueId', $this->getIssue()->getId());
		$publication->setData('urlPath', null);

		// Set article pages
		$firstPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleFirstPage');
		$lastPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleLastPage');
		if ($firstPage && $lastPage) {
			$publication->setData('pages', "$firstPage-$lastPage");
		}

		$hasTitle = false;
		$publicationLocale = null;

		// Set title
		foreach ($this->select('Journal/Volume/Issue/Article/ArticleInfo/ArticleTitle') as $node) {
			$locale = $this->getLocale($node->getAttribute('Language'));
			// The publication language is defined by the first title node
			if (!$publicationLocale) {
				$publicationLocale = $locale;
			}
			$value = $this->selectText('.', $node);
			$hasTitle |= strlen($value);
			$publication->setData('title', $value, $locale);
		}

		if(!$hasTitle) {
			throw new \Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
		}

		$publication->setData('locale', $publicationLocale);
		$publication->setData('language', \PKPLocale::getIso1FromLocale($publicationLocale));

		// Set subtitle
		foreach ($this->select('Journal/Volume/Issue/Article/ArticleInfo/ArticleSubTitle') as $node) {
			$publication->setData('subtitle', $this->selectText('.', $node), $this->getLocale($node->getAttribute('Language')));
		}

		// Set article abstract
		foreach ($this->select('Journal/Volume/Issue/Article/ArticleHeader/Abstract') as $abstract) {
			$value = trim($this->getTextContent($abstract, function ($node, $content) use ($abstract) {
				// Ignores the main Heading tag
				if ($node->nodeName == 'Heading' && $node->parentNode === $abstract) {
					return '';
				}
				// Transforms the known tags, the remaining ones will be stripped
				if ($node->nodeName == 'Heading') {
					return "<p><strong>$content</strong></p>";
				}
				$tag = [
					'Emphasis' => 'em',
					'Subscript' => 'sub',
					'Superscript' => 'sup',
					'Para' => 'p'
				][$node->nodeName] ?? null;
				return $tag ? "<$tag>$content</$tag>" : $content;
			}));
			if ($value) {
				$publication->setData('abstract', $value, $this->getLocale($abstract->getAttribute('Language')));
			}
		}

		// Set public IDs
		foreach ($this->getPublicIds() as $type => $value) {
			$publication->setData('pub-id::' . $type, $value);
		}

		// Set copyright year and holder and license permissions
		$publication->setData('copyrightHolder', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightHolderName'), $this->getLocale());
		$publication->setData('copyrightNotice', null);
		$publication->setData('copyrightYear', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightYear') ?: $publicationDate->format('Y'));
		$publication->setData('licenseURL', null);

		// Inserts the publication and updates the submission's publication ID
		$publication = \Services::get('publication')->add($publication, \Application::get()->getRequest());

		$this->_processAuthors($publication);

		// Handle PDF galley
		$this->_insertPDFGalley($publication);

		// Publishes the article
		\Services::get('publication')->publish($publication);

		return $publication;
	}

	/**
	 * Retrieves the access status of the submission
	 * @return int
	 */
	private function _getAccessStatus(): int
	{
		// Checks if there's an ArticleGrant different of OpenAccess
		return $this->evaluate("count(Journal/Volume/Issue/Article/ArticleInfo/ArticleGrants/*[@Grant!='OpenAccess'])") > 0
			? \ARTICLE_ACCESS_ISSUE_DEFAULT
			: \ARTICLE_ACCESS_OPEN;
	}

	/**
	 * Inserts the PDF galley
	 * @param \Publication $publication
	 */
	private function _insertPDFGalley(\Publication $publication): void
	{
		$file = $this->getArticleEntry()->getSubmissionFile();
		$filename = $file->getFilename();

		// Create a representation of the article (i.e. a galley)
		$representationDao = \Application::getRepresentationDAO();
		$representation = $representationDao->newDataObject();
		$representation->setData('publicationId', $publication->getId());
		$representation->setData('name', $filename, $this->getLocale());
		$representation->setData('seq', 1);
		$representation->setData('label', 'PDF');
		$representation->setData('locale', $this->getLocale());
		$representationDao->insertObject($representation);

		// Add the PDF file and link representation with submission file
		$submissionFile = (new \SubmissionFileManager($this->getContextId(), $this->getSubmission()->getId()))
			->copySubmissionFile(
				$file->getPathname(),
				\SUBMISSION_FILE_PROOF,
				$this->getConfiguration()->getEditor()->getId(),
				null,
				$this->getConfiguration()->getSubmissionGenre()->getId(),
				\ASSOC_TYPE_REPRESENTATION,
				$representation->getId()
			);
		$representation->setFileId($submissionFile->getFileId());
		$representationDao->updateObject($representation);
	}

	/**
	 * Retrieves the public IDs
	 * @return array Returns array, where the key is the type and value the ID
	 */
	public function getPublicIds(): array
	{
		$ids = [];
		if ($value = $this->selectText('Journal/Volume/Issue/Article/@ID')) {
			$ids['publisher-id'] = $value;
		}
		if ($value = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleDOI')) {
			$ids['doi'] = $value;
		}
		return $ids;
	}

	/**
	 * Retrieves the publication date
	 * @return \DateTimeImmutable
	 */
	public function getPublicationDate(): \DateTimeImmutable
	{
		$date = $this->getDateFromNode($this->selectFirst('Journal/Volume/Issue/Article/ArticleInfo/ArticleHistory/OnlineDate'))
			?: $this->getIssuePublicationDate();
		if (!$date) {
			throw new \Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
		}
		return $date;
	}
}
