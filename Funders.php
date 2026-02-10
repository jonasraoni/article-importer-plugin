<?php

/**
 * @file plugins/importexport/articleImporter/Funders.php
 *
 * Copyright (c) 2025 Simon Fraser University
 * Copyright (c) 2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Funders
 *
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Process funder/award data into the database using the Funding plugin.
 */

namespace APP\plugins\importexport\articleImporter;

use APP\plugins\generic\funding\classes\Funder;
use APP\plugins\generic\funding\classes\FunderAward;
use APP\plugins\generic\funding\classes\FunderAwardDAO;
use APP\plugins\generic\funding\classes\FunderDAO;
use PKP\db\DAORegistry;
use PKP\db\DAOResultFactory;
use PKP\plugins\PluginRegistry;

class Funders
{
    /**
     * Check if the Funding plugin is enabled and properly loaded with DAOs registered.
     */
    public static function isFundingPluginEnabled(int $contextId): bool
    {
        $fundingPlugin = PluginRegistry::getPlugin('generic', 'FundingPlugin') ?? PluginRegistry::loadPlugin('generic', 'funding');
        return $fundingPlugin?->getEnabled();
    }

    /**
     * Check if a submission already has funders
     */
    private static function submissionHasFunders(int $submissionId): bool
    {
        /** @var FunderDAO */
        $funderDao = DAORegistry::getDAO('FunderDAO');
        /** @var DAOResultFactory<Funder> */
        $existingFunders = $funderDao->getBySubmissionId($submissionId);
        return $existingFunders->next() !== null;
    }

    /**
     * Create funders and awards from JATS-style award-group data (e.g. funding-source, award-id, xlink:href).
     * Each item: ['funderName' => string, 'funderIdentification' => string, 'awardNumbers' => string[]].
     * No-op if Funding plugin is disabled or submission already has funders.
     */
    public static function createFundersFromAwardGroups(array $award_groups, int $submissionId, int $contextId): void
    {
        if (!self::isFundingPluginEnabled($contextId)) {
            return;
        }
        if (self::submissionHasFunders($submissionId)) {
            return;
        }
        /** @var FunderDAO $funderDao */
        $funderDao = DAORegistry::getDAO('FunderDAO');
        /** @var FunderAwardDAO $funderAwardDao */
        $funderAwardDao = DAORegistry::getDAO('FunderAwardDAO');
        foreach ($award_groups as $group) {
            $funder_name = trim($group['funderName'] ?? '');
            if ($funder_name === '') {
                continue;
            }
            $funder_identification = trim($group['funderIdentification'] ?? '');
            $award_numbers = $group['awardNumbers'] ?? [];
            if (!is_array($award_numbers)) {
                $award_numbers = [];
            }
            /** @var Funder $funder */
            $funder = $funderDao->newDataObject();
            $funder->setContextId($contextId);
            $funder->setSubmissionId($submissionId);
            $funder->setFunderIdentification($funder_identification);
            $funder->setFunderName($funder_name);
            $funderId = $funderDao->insertObject($funder);
            if (!$funderId) {
                continue;
            }
            foreach ($award_numbers as $award_number) {
                $award_number = trim((string) $award_number);
                if ($award_number === '') {
                    continue;
                }
                /** @var FunderAward $funderAward */
                $funderAward = $funderAwardDao->newDataObject();
                $funderAward->setFunderId($funderId);
                $funderAward->setFunderAwardNumber($award_number);
                $funderAwardDao->insertObject($funderAward);
            }
        }
    }
}
