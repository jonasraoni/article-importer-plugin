<?php
/**
 * @file EntityManager.php
 *
 * Copyright (c) 2020 Simon Fraser University
 * Copyright (c) 2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class EntityManager
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Trait that provides caching functionality for parsers
 */

namespace APP\plugins\importexport\articleImporter;

use APP\facades\Repo;
use APP\issue\Issue;
use APP\section\Section;
use APP\submission\Submission;
use PKP\author\contributorRole\ContributorRole;
use PKP\category\Category;
use PKP\db\DAORegistry;
use PKP\submission\Genre;
use PKP\submission\GenreDAO;
use Throwable;

trait EntityManager
{
    /** @var array Cache */
    protected static $cache = [];

    /** @var array Track created entities for rollback */
    protected $entities = [];

    /**
     * Track a created entity for rollback
     */
    protected function trackEntity(object $entity): void
    {
        $this->entities[] = $entity;
    }

    /**
     * Delete tracked entities
     */
    protected function deleteTrackedEntities(): void
    {
        foreach ($this->entities as $entity) {
            try {
                $cache = null;
                if ($entity instanceof Submission) {
                    Repo::submission()->delete($entity);
                    $cache = 'submission';
                } elseif ($entity instanceof Issue) {
                    Repo::issue()->delete($entity);
                    $cache = 'issue';
                } elseif ($entity instanceof Section) {
                    Repo::section()->delete($entity);
                    $cache = 'section';
                } elseif ($entity instanceof Category) {
                    Repo::category()->delete($entity);
                    $cache = 'category';
                } else {
                    error_log('Unexpected entity type');
                }
                if ($cache) {
                    foreach(static::$cache[$cache] as $key => $value) {
                        if ($entity === $value) {
                            unset(static::$cache[$cache][$key]);
                            break;
                        }
                    }
                }
            } catch (Throwable $entity) {
                error_log("An error happened while removing an entity:\n{$entity}");
            }
        }

        $this->entities = [];
    }

    /**
     * Get cached genre
     */
    protected function getCachedGenre(string $extension): Genre
    {
        $type = in_array($extension, $this->getConfiguration()->getImageExtensions()) ? 'IMAGE' : 'MULTIMEDIA';
        if (isset(static::$cache['genre'][$type])) {
            return static::$cache['genre'][$type];
        }

        /** @var GenreDAO */
        $genreDao = DAORegistry::getDAO('GenreDAO');
        return static::$cache['genre'][$type] = $genreDao->getByKey($type, $this->getContextId()) ?? $this->getConfiguration()->getSubmissionGenre();
    }

    /**
     * Get cached section
     */
    protected function getCachedSection(string $name): ?Section
    {
        return static::$cache['section'][$name] ?? Repo::section()->getCollector()->filterByTitles([$name])->filterByContextIds([$this->getContextId()])->getMany()->first();
    }

    /**
     * Set cached section
     */
    protected function setCachedSection(string $name, Section $section): void
    {
        static::$cache['section'][$name] = $section;

        if (!$section) {
            return;
        }

        // Includes a section into the issue custom order
        if (!Repo::section()->getCustomSectionOrder($this->getIssue()->getId(), $section->getId())) {
            Repo::section()->upsertCustomSectionOrder($this->getIssue()->getId(), $section->getId(), count(static::$cache['section']));
        }
    }

    /**
     * Get cached submission
     */
    protected function getCachedSubmission(): ?Submission
    {
        $entry = $this->getArticleEntry();
        return static::$cache['submission']["{$entry->getVolume()}-{$entry->getIssue()}-{$entry->getArticle()}"] ?? null;
    }

    /**
     * Set cached submission
     */
    protected function setCachedSubmission(Submission $submission): void
    {
        $entry = $this->getArticleEntry();
        static::$cache['submission']["{$entry->getVolume()}-{$entry->getIssue()}-{$entry->getArticle()}"] = $submission;
    }

    /**
     * Get cached issue
     */
    protected function getCachedIssue(string $volume, string $number): ?Issue
    {
        return static::$cache['issue']["{$volume}-{$number}"] ?? Repo::issue()->getCollector()
            ->filterByContextIds([$this->getContextId()])
            ->filterByVolumes([$volume])
            ->filterByNumbers([$number])
            ->getMany()
            ->first();
    }

    /**
     * Set cached issue
     */
    protected function setCachedIssue(string $volume, string $number, Issue $issue): void
    {
        static::$cache['issue']["{$volume}-{$number}"] = $issue;
    }

    /**
     * Get cached category
     */
    protected function getCachedCategory(string $name): ?Category
    {
        return static::$cache['category'][$name] ?? Repo::category()->getCollector()->filterByPaths([$name])->filterByContextIds([$this->getContextId()])->getMany()->first();
    }

    /**
     * Set cached category
     */
    protected function setCachedCategory(string $name, ?Category $category): void
    {
        static::$cache['category'][$name] = $category;
    }

    /**
     * Get cached contributor role
     */
    protected function getCachedContributorRole(string $name): ?ContributorRole
    {
        return static::$cache['contributorRole'][$name] ?? ContributorRole::where('contributor_role_identifier', $name)
            ->filterByContextIds([$this->getContextId()])
            ->getMany()
            ->first();
    }
}
