<?php
/**
 * @file plugins/importexport/articleImporter/parsers/jats/PublicationParser.inc.php
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

namespace PKP\Plugins\ImportExport\ArticleImporter\Parsers\Jats;

trait PublicationParser {
	/**
	 * Parse, import and retrieve the publication
	 * @return \Publication
	 */
	public function getPublication(): \Publication
	{
		$publicationDate = $this->getPublicationDate() ?: $this->getIssuePublicationDate();

		// Create the publication
		$publication = \DAORegistry::getDAO('PublicationDAO')->newDataObject();
		$publication->setData('submissionId', $this->getSubmission()->getId());
		$publication->setData('status', \STATUS_PUBLISHED);
		$publication->setData('version', 1);
		$publication->setData('seq', $this->getSubmission()->getId());
		$publication->setData('accessStatus', \ARTICLE_ACCESS_OPEN);
		$publication->setData('datePublished', $publicationDate->format(\DateTime::RFC3339));
		$publication->setData('sectionId', $this->getSection()->getId());
		$publication->setData('issueId', $this->getIssue()->getId());
		$publication->setData('urlPath', null);

		// Set article pages
		$firstPage = $this->selectText('front/article-meta/fpage');
		$lastPage = $this->selectText('front/article-meta/lpage');
		if ($firstPage && $lastPage) {
			$publication->setData('pages', "$firstPage-$lastPage");
		}

		$hasTitle = false;
		$publicationLocale = null;
		
		// Set title
		if($node = $this->selectFirst('front/article-meta/title-group/article-title')) {
			$locale = $this->getLocale($node->getAttribute('xml:lang'));
			// The publication language is defined by the first title node
			if (!$publicationLocale) {
				$publicationLocale = $locale;
			}
			$value = $this->selectText('.', $node);
			$hasTitle = strlen($value);
			$publication->setData('title', $value, $locale);
		}

		// Set subtitle
		if($node = $this->selectFirst('front/article-meta/title-group/subtitle')) {
			$publication->setData('subtitle', $this->selectText('.', $node), $this->getLocale($node->getAttribute('xml:lang')));
		}

		// Set localized title/subtitle
		foreach ($this->select('front/article-meta/title-group/trans-title-group') as $node) {
			$locale = $this->getLocale($node->getAttribute('xml:lang'));
			if ($value = $this->selectText('trans-title', $node)) {
				// The publication language is defined by the first title node
				if (!$publicationLocale) {
					$publicationLocale = $locale;
				}
				$hasTitle = true;
				$publication->setData('title', $value, $locale);
			}
			if ($value = $this->selectText('trans-subtitle', $node)) {
				$publication->setData('subtitle', $value, $locale);
			}
		}

		if(!$hasTitle) {
			throw new \Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
		}

		$publication->setData('locale', $publicationLocale);
		$publication->setData('language', \PKPLocale::getIso1FromLocale($publicationLocale));

		// Set abstract
		foreach ($this->select('front/article-meta/abstract|front/article-meta/trans-abstract') as $node) {
			$value = trim($this->getTextContent($node, function ($node, $content) {
				// Transforms the known tags, the remaining ones will be stripped
				$tag = [
					'italic' => 'em',
					'sub' => 'sub',
					'sup' => 'sup',
					'p' => 'p'
				][$node->nodeName] ?? null;
				return $tag ? "<$tag>$content</$tag>" : $content;
			}));
			if ($value) {
				$publication->setData('abstract', $value, $this->getLocale($node->getAttribute('xml:lang')));
			}
		}

		// Set public IDs
		foreach ($this->getPublicIds() as $type => $value) {
			$publication->setData('pub-id::' . $type, $value);
		}

		// Set copyright year and holder and license permissions
		$publication->setData('copyrightHolder', $this->selectText('front/article-meta/permissions/copyright-holder'), $this->getLocale());
		$publication->setData('copyrightNotice', $this->selectText('front/article-meta/permissions/copyright-statement'), $this->getLocale());
		$publication->setData('copyrightYear', $this->selectText('front/article-meta/permissions/copyright-year') ?: $publicationDate->format('Y'));
		$publication->setData('licenseURL', null);

		// Inserts the publication and updates the submission
		$publication = \Services::get('publication')->add($publication, \Application::get()->getRequest());

		$this->_processAuthors($publication);

		// Handle PDF galley
		$this->_insertPDFGalley($publication);

		// Record this XML itself
		$this->_insertXMLSubmissionFile($publication);

		// Publishes the article
		\Services::get('publication')->publish($publication);

		return $publication;
	}
		
	/**
	 * Inserts the PDF galley
	 * @param \Publication $publication
	 */
	private function _insertXMLSubmissionFile(\Publication $publication): void
	{
		import('lib.pkp.classes.file.SubmissionFileManager');
		$splfile = $this->getArticleEntry()->getMetadataFile();
		$filename = $splfile->getPathname();

		$genreId = \GENRE_CATEGORY_DOCUMENT;
		$fileSize = $splfile->getSize();
		$fileType = "text/xml";
		$fileStage = \SUBMISSION_FILE_PRODUCTION_READY;
		$userId = $this->getConfiguration()->getUser()->getId();

		$submission = $this->getSubmission();

		$submissionFileDao = \DAORegistry::getDAO('SubmissionFileDAO');
		$newSubmissionFile = $submissionFileDao->newDataObjectByGenreId($genreId);
		$newSubmissionFile->setSubmissionId($submission->getId());
		$newSubmissionFile->setSubmissionLocale($submission->getLocale());
		$newSubmissionFile->setGenreId($genreId);
		$newSubmissionFile->setFileStage($fileStage);
		$newSubmissionFile->setDateUploaded(\Core::getCurrentDate());
		$newSubmissionFile->setDateModified(\Core::getCurrentDate());
		$newSubmissionFile->setOriginalFileName($splfile->getFilename());
		$newSubmissionFile->setUploaderUserId($userId);
		$newSubmissionFile->setFileSize($fileSize);
		$newSubmissionFile->setFileType($fileType);
		$newSubmissionFile->setName($splfile->getFilename(), $submission->getLocale());

		$insertedSubmissionFile = $submissionFileDao->insertObject($newSubmissionFile, $filename);

		foreach ($this->select('//asset|//graphic') as $asset) {
			$assetFilename = $asset->getAttribute( $asset->nodeName == 'path' ? 'href' : 'xlink:href' );
			$dependentFilePath = dirname($filename) . DIRECTORY_SEPARATOR . $assetFilename;
			if (file_exists($dependentFilePath)) {
				$fileType = pathinfo($assetFilename, PATHINFO_EXTENSION);
				$genreId = $this->_getGenreId($this->getContextId(), $fileType);
				$this->_createDependentFile($genreId, $submission, $insertedSubmissionFile, $userId, $fileType, $assetFilename, \SUBMISSION_FILE_DEPENDENT, \ASSOC_TYPE_SUBMISSION_FILE, false, $insertedSubmissionFile->getFileId(), false, $dependentFilePath);
			}
		}
	}


	/**
	 * Creates a dependent file
	 *
	 * @param $genreId  int
	 * @param $submission Submission
	 * @param $submissionFile SubmissionFile
	 * @param $userId int
	 * @param $fileType string
	 * @param $fileName string
	 * @param bool $fileStage
	 * @param bool $assocType
	 * @param bool $sourceRevision
	 * @param bool $assocId
	 * @param bool $sourceFileId
	 * @param $filePath string
	 * @return void
	 */
	protected function _createDependentFile($genreId, $submission, $submissionFile, $userId, $fileType, $fileName, $fileStage = false, $assocType = false, $sourceRevision = false, $assocId = false, $sourceFileId = false, $filePath) {

		$fileSize = filesize($filePath);

		$submissionFileDao = \DAORegistry::getDAO('SubmissionFileDAO');
		$newFile = $submissionFileDao->newDataObjectByGenreId($genreId);
		$newFile->setSubmissionId($submission->getId());
		$newFile->setSubmissionLocale($submission->getLocale());
		$newFile->setGenreId($genreId);
		$newFile->setFileStage($fileStage);
		$newFile->setDateUploaded(\Core::getCurrentDate());
		$newFile->setDateModified(\Core::getCurrentDate());
		$newFile->setUploaderUserId($userId);
		$newFile->setFileSize($fileSize);
		$newFile->setFileType($fileType);

		if (isset($fileName)) $newFile->setOriginalFileName($fileName);
		if (isset($fileName)) $newFile->setName($fileName, $submission->getLocale());
		if (isset($assocType)) $newFile->setAssocType($assocType);
		if (isset($sourceRevision)) $newFile->setSourceRevision($sourceRevision);
		if (isset($assocId)) $newFile->setAssocId($assocId);
		if (isset($sourceFileId)) $newFile->setSourceFileId($sourceFileId);

		$insertedMediaFile = $submissionFileDao->insertObject($newFile, $filePath);

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
		foreach ($this->select('front/article-meta/article-id') as $node) {
			$ids[strtolower($node->getAttribute('pub-id-type'))] = $this->selectText('.', $node);
		}
		return $ids;
	}

	/**
	 * Retrieves the publication date
	 * @return \DateTimeImmutable
	 */
	public function getPublicationDate(): \DateTimeImmutable
	{
		$node = null;
		// Find the most suitable pub-date node
		foreach ($this->select('front/article-meta/pub-date') as $node) {
			if ($node->getAttribute('pub-type') == 'given-online-pub' || $node->getAttribute('publication-format') == 'electronic') {
				break;
			}
		}
		if (!$date = $this->getDateFromNode($node)) {
			throw new \Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
		}
		return $date;
	}
}
