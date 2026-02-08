<?php
/**
 * @file parsers/aPlusPlus/PublicationParser.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PublicationParser
 * @brief Handles parsing and importing the publications
 */

namespace APP\plugins\importexport\articleImporter\parsers\aPlusPlus;

use APP\publication\enums\VersionStage;
use DateTimeImmutable;
use DOMElement;
use Exception;
use PKP\core\Core;
use PKP\publication\helpers\PublicationVersionInfo;
use PKP\Services\PKPFileService;
use APP\publication\Publication;
use APP\submission\Submission;
use PKP\plugins\PluginRegistry;
use APP\core\Application;
use PKP\i18n\LocaleConversion;
use APP\core\Services;
use APP\facades\Repo;
use PKP\controlledVocab\ControlledVocab;
use PKP\submissionFile\SubmissionFile;

trait PublicationParser
{
    /**
     * Parse, import and retrieve the publication
     */
    public function getPublication(): Publication
    {
        $publicationDate = $this->getPublicationDate() ?: $this->getIssue()->getDatePublished();
        $version = $this->getArticleVersion()->getVersion();
        $submission = $this->getSubmission();

        // Create the publication
        $publication = Repo::publication()->newDataObject();
        $publication->setData('submissionId', $submission->getId());
        if ($version > 1) {
            $sourcePublication = Repo::publication()->getCollector()
                ->filterBySubmissionIds([$submission->getId()])
                ->getMany()
                ->first(fn (Publication $p) => (int) $p->getData('seq') === $version - 1);
            if ($sourcePublication) {
                $publication->setData('sourcePublicationId', $sourcePublication->getId());
            }
        }
        $publication->setData('status', Submission::STATUS_PUBLISHED);
        $publication->setData('version', $version);
        $publication->setVersion(new PublicationVersionInfo(VersionStage::VERSION_OF_RECORD, $version, 0));
        $publication->setData('seq', $version);
        $publication->setData('accessStatus', $this->_getAccessStatus());
        $publication->setData('datePublished', $publicationDate->format(static::DATETIME_FORMAT));
        $publication->setData('sectionId', $this->getSection()->getId());
        $publication->setData('issueId', $this->getIssue()->getId());
        $publication->setData('urlPath', null);

        // Set article pages
        $firstPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleFirstPage');
        $lastPage = $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleLastPage');
        if ($firstPage || $lastPage) {
            $publication->setData('pages', "{$firstPage}" . ($lastPage ? "-{$lastPage}" : ''));
        }

        $hasTitle = false;
        $publicationLocale = null;

        // Set title
        /** @var DOMElement $node */
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
            throw new Exception(__('plugins.importexport.articleImporter.articleTitleMissing'));
        }

        $publication->setData('locale', $publicationLocale);
        $publication->setData('language', LocaleConversion::getIso1FromLocale($publicationLocale));

        // Set subtitle
        /** @var DOMElement $node */
        foreach ($this->select('Journal/Volume/Issue/Article/ArticleInfo/ArticleSubTitle') as $node) {
            $publication->setData('subtitle', $this->selectText('.', $node), $this->getLocale($node->getAttribute('Language')));
        }

        // Set article abstract
        /** @var DOMElement $abstract */
        foreach ($this->select('Journal/Volume/Issue/Article/ArticleHeader/Abstract') as $abstract) {
            $value = trim($this->getTextContent($abstract, function ($node, $content) use ($abstract) {
                // Ignores the main Heading tag
                if ($node->nodeName == 'Heading' && $node->parentNode === $abstract) {
                    return '';
                }
                // Transforms the known tags, the remaining ones will be stripped
                if ($node->nodeName == 'Heading') {
                    return "<p><strong>{$content}</strong></p>";
                }
                $tag = [
                    'Emphasis' => 'em',
                    'Subscript' => 'sub',
                    'Superscript' => 'sup',
                    'Para' => 'p'
                ][$node->nodeName] ?? null;
                return $tag ? "<{$tag}>{$content}</{$tag}>" : $content;
            }));
            if ($value) {
                $publication->setData('abstract', $value, $this->getLocale($abstract->getAttribute('Language')));
            }
        }

        // Set public IDs
        $pubIdPlugins = null;
        foreach ($this->getPublicIds() as $type => $value) {
            if ($type === 'doi') {
                $doiFound = Repo::doi()->getCollector()->filterByIdentifier($value)->getMany()->first();
                if ($doiFound) {
                    $publication->setData('doiId', $doiFound->getId());
                } else {
                    $newDoiObject = Repo::doi()->newDataObject([
                        'doi' => $value,
                        'contextId' => $this->getSubmission()->getData('contextId')
                    ]);
                    $doiId = Repo::doi()->add($newDoiObject);
                    $publication->setData('doiId', $doiId);
                }
            } else {
                if ($type !== 'publisher-id' && !$pubIdPlugins) {
                    $pubIdPlugins = PluginRegistry::loadCategory('pubIds', true, $this->getContextId());
                }
                $publication->setData('pub-id::' . $type, $value);
            }
        }

        // Set copyright year and holder and license permissions
        $publication->setData('copyrightHolder', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightHolderName'), $this->getLocale());
        $publication->setData('copyrightNotice', null);
        $publication->setData('copyrightYear', $this->selectText('Journal/Volume/Issue/Article/ArticleInfo/ArticleCopyright/CopyrightYear') ?: $publicationDate->format('Y'));
        $publication->setData('licenseUrl', null);
        $this->setPublicationCoverImage($publication);

        // Inserts the publication and updates the submission's publication ID
        Repo::publication()->add($publication);

        $this->_processKeywords($publication);
        // Reload object with keywords (otherwise they will be cleared later on)
        $publication = Repo::publication()->get($publication->getId());
        $this->_processAuthors($publication);
        $publication = Repo::publication()->edit($publication, []);

        // Handle PDF galley
        $this->_insertPDFGalley($publication);

        // Publishes the article
        Repo::publication()->publish($publication);

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
        $file = $this->getArticleVersion()->getSubmissionFile();
        if (!$file) {
            return;
        }
        $filename = $file->getFilename();

        // Create a galley for the article
        $galley = Repo::galley()->newDataObject();
        $galley->setData('publicationId', $publication->getId());
        $galley->setData('name', $filename, $this->getLocale());
        $galley->setData('seq', 1);
        $galley->setData('label', 'PDF');
        $galley->setData('locale', $this->getLocale());
        $newGalleyId = Repo::galley()->add($galley);

        // Add the PDF file and link galley with submission file
        /** @var PKPFileService $fileService */
        $fileService = Services::get('file');
        $submission = $this->getSubmission();

        $submissionDir = Repo::submissionFile()->getSubmissionDir($submission->getData('contextId'), $submission->getId());
        $newFileId = $fileService->add(
            $file->getPathname(),
            $submissionDir . '/' . uniqid() . '.pdf'
        );

        $newSubmissionFile = Repo::submissionFile()->newDataObject();
        $newSubmissionFile->setData('submissionId', $submission->getId());
        $newSubmissionFile->setData('fileId', $newFileId);
        $newSubmissionFile->setData('genreId', $this->getConfiguration()->getSubmissionGenre()->getId());
        $newSubmissionFile->setData('fileStage', SubmissionFile::SUBMISSION_FILE_PROOF);
        $newSubmissionFile->setData('uploaderUserId', $this->getConfiguration()->getEditor()->getId());
        $newSubmissionFile->setData('createdAt', Core::getCurrentDate());
        $newSubmissionFile->setData('updatedAt', Core::getCurrentDate());
        $newSubmissionFile->setData('assocType', Application::ASSOC_TYPE_REPRESENTATION);
        $newSubmissionFile->setData('assocId', $newGalleyId);
        $newSubmissionFile->setData('name', $filename, $this->getLocale());
        Repo::submissionFile()->add($newSubmissionFile);

        $galley = Repo::galley()->get($newGalleyId);
        $galley->setData('submissionFileId', $newSubmissionFile->getData('fileId'));
        Repo::galley()->edit($galley, []);
    }

    /**
     * Retrieves the public IDs
     *
     * @return array Returns array, where the key is the type and value the ID
     */
    public function getPublicIds(): array
    {
        $articleEntry = $this->getArticleEntry();
        $ids = ['publisher-id' => "{$articleEntry->getVolume()}.{$articleEntry->getIssue()}.{$articleEntry->getArticle()}.{$this->getArticleVersion()->getVersion()}"];
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
    public function getPublicationDate(): DateTimeImmutable
    {
        $date = $this->getDateFromNode($this->selectFirst('Journal/Volume/Issue/Article/ArticleInfo/ArticleHistory/OnlineDate'))
            ?: $this->getIssuePublicationDate();
        if (!$date) {
            throw new Exception(__('plugins.importexport.articleImporter.missingPublicationDate'));
        }
        return $date;
    }

    /**
     * Process the article keywords
     */
    private function _processKeywords(Publication $publication): void
    {
        $keywords = [];
        /** @var DOMElement $node */
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
