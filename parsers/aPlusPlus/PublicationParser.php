<?php
/**
 * @file parsers/aPlusPlus/PublicationParser.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PublicationParser
 * @brief Handles parsing and importing the publications
 */

namespace APP\plugins\importexport\articleImporter\parsers\aPlusPlus;

use APP\plugins\importexport\articleImporter\ArticleImporterPlugin;

use APP\services\SubmissionFileService;
use PKP\Services\PKPFileService;
use APP\publication\Publication;
use PKP\db\DAORegistry;
use APP\submission\Submission;
use PKP\plugins\PluginRegistry;
use APP\core\Application;
use PKP\i18n\LocaleConversion;
use APP\core\Services;
use APP\facades\Repo;
use PKP\controlledVocab\ControlledVocab;

trait PublicationParser
{
    /**
     * Parse, import and retrieve the publication
     */
    public function getPublication(): Publication
    {
        $publicationDate = $this->getPublicationDate() ?: $this->getIssue()->getDatePublished();

        // Create the publication
        $publication = Repo::publication()->dao->newDataObject();
        $publication->setData('submissionId', $this->getSubmission()->getId());
        $publication->setData('status', Submission::STATUS_PUBLISHED);
        $publication->setData('version', 1);
        $publication->setData('seq', $this->getSubmission()->getId());
        $publication->setData('accessStatus', $this->_getAccessStatus());
        $publication->setData('datePublished', $publicationDate->format(ArticleImporterPlugin::DATETIME_FORMAT));
        $publication->setData('sectionId', $this->getSection()->getId());
        $publication->setData('issueId', $this->getIssue()->getId());
        $publication->setData('urlPath', null);

        // Set article pages
        $firstPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleFirstPage');
        $lastPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleLastPage');
        if ($firstPage || $lastPage) {
            $publication->setData('pages', "${firstPage}" . ($lastPage ? "-${lastPage}" : ''));
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

        if (!$hasTitle) {
            throw new \Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
        }

        $publication->setData('locale', $publicationLocale);
        $publication->setData('language', LocaleConversion::getIso1FromLocale($publicationLocale));

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
                    return "<p><strong>${content}</strong></p>";
                }
                $tag = [
                    'Emphasis' => 'em',
                    'Subscript' => 'sub',
                    'Superscript' => 'sup',
                    'Para' => 'p'
                ][$node->nodeName] ?? null;
                return $tag ? "<${tag}>${content}</${tag}>" : $content;
            }));
            if ($value) {
                $publication->setData('abstract', $value, $this->getLocale($abstract->getAttribute('Language')));
            }
        }

        // Set public IDs
        $pubIdPlugins = false;
        foreach ($this->getPublicIds() as $type => $value) {
            if ($type !== 'publisher-id' && !$pubIdPlugins) {
                $pubIdPlugins = PluginRegistry::loadCategory('pubIds', true, $this->getContextId());
            }
            $publication->setData('pub-id::' . $type, $value);
        }

        // Set copyright year and holder and license permissions
        $publication->setData('copyrightHolder', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightHolderName'), $this->getLocale());
        $publication->setData('copyrightNotice', null);
        $publication->setData('copyrightYear', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightYear') ?: $publicationDate->format('Y'));
        $publication->setData('licenseUrl', null);

        // Inserts the publication and updates the submission's publication ID
	Repo::publication()->dao->insert($publication);
	$submission = $this->getSubmission();
	$submission->setData('currentPublicationId', $publication->getId());
	Repo::submission()->edit($submission, []);

        $this->_processKeywords($publication);
        $this->_processAuthors($publication);

        // Handle PDF galley
        $this->_insertPDFGalley($publication);

        // Publishes the article
        Services::get('publication')->publish($publication);

        return $publication;
    }

    /**
     * Retrieves the access status of the submission
     */
    private function _getAccessStatus(): int
    {
        // Checks if there's an ArticleGrant different of OpenAccess
        return $this->evaluate("count(Journal/Volume/Issue/Article/ArticleInfo/ArticleGrants/*[@Grant!='OpenAccess'])") > 0
            ? Submission::ARTICLE_ACCESS_ISSUE_DEFAULT
            : Submission::ARTICLE_ACCESS_OPEN;
    }

    /**
     * Inserts the PDF galley
     */
    private function _insertPDFGalley(Publication $publication): void
    {
        $file = $this->getArticleEntry()->getSubmissionFile();
        $filename = $file->getFilename();

        // Create a galley for the article
        $galley = Repo::galley()->dao->newDataObject();
        $galley->setData('publicationId', $publication->getId());
        $galley->setData('name', $filename, $this->getLocale());
        $galley->setData('seq', 1);
        $galley->setData('label', 'PDF');
        $galley->setData('locale', $this->getLocale());
        $newGalleyId = Repo::galley()->add($galley);

        // Add the PDF file and link galley with submission file
        /** @var SubmissionFileService $submissionFileService */
        $submissionFileService = Services::get('submissionFile');
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');
        $submission = $this->getSubmission();

        $submissionDir = $submissionFileService->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $file->getPathname(),
            $submissionDir . '/' . uniqid() . '.pdf'
        );

        $newSubmissionFile = Repo::submissionFile()->dao->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', \SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', \Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', \Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', \ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        $submissionFileService->add($newSubmissionFile, \Application::get()->getRequest());

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $newSubmissionFile->getData('fileId'));
        Repo::galley()->edit($galley, []);

        unset($newFileId);
    }

    /**
     * Retrieves the public IDs
     *
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

    /**
     * Process the article keywords
     */
    private function _processKeywords(\Publication $publication): void
    {
        $submissionKeywordDAO = DAORegistry::getDAO('SubmissionKeywordDAO');
        $keywords = [];
        foreach ($this->select('Journal/Volume/Issue/Article/ArticleHeader/KeywordGroup') as $node) {
            $locale = $this->getLocale($node->getAttribute('Language'));
            foreach ($this->select('Keyword', $node) as $node) {
                $keywords[$locale][] = $this->selectText('.', $node);
            }
        }
        if (count($keywords)) {
            Repo::controlledVocab()->insertBySymbolic(ControlledVocab::CONTROLLED_VOCAB_SUBMISSION_KEYWORD, $keywords, Application::ASSOC_TYPE_PUBLICATION, $publication->getId());
        }
    }
}
