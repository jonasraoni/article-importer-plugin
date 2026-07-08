<?php

/**
 * @file plugins/importexport/articleImporter/Funders.php
 *
 * Copyright (c) 2026 Simon Fraser University
 * Copyright (c) 2026 John Willinsky
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
    public static function isFundingPluginEnabled(): bool
    {
        $fundingPlugin = PluginRegistry::getPlugin('generic', 'FundingPlugin') ?? PluginRegistry::loadPlugin('generic', 'funding');
        return (bool) $fundingPlugin?->getEnabled();
    }

    /**
     * Create funders and awards from JATS-style award-group data (e.g. funding-source, award-id, xlink:href).
     * If funding data already exists for the submission, it will be replaced.
     * @param array<array{funderName: string, funderIdentification: string, awardNumbers: string[]}> $awardGroups
     */
    public static function createFundersFromAwardGroups(array $awardGroups, int $submissionId, int $contextId): void
    {
        if (!self::isFundingPluginEnabled()) {
            return;
        }
        /** @var FunderDAO $funderDao */
        $funderDao = DAORegistry::getDAO('FunderDAO');
        /** @var FunderAwardDAO $funderAwardDao */
        $funderAwardDao = DAORegistry::getDAO('FunderAwardDAO');

        // Remove existing funders (and their awards) for this submission/context
        /** @var DAOResultFactory<Funder> $existingFunders */
        $existingFunders = $funderDao->getBySubmissionId($submissionId, $contextId);
        foreach ($existingFunders->toIterator() as $existingFunder) {
            $funderDao->deleteObject($existingFunder);
        }

        foreach ($awardGroups as $group) {
            $funderName = trim($group['funderName'] ?? '');
            if ($funderName === '') {
                continue;
            }
            $funderIdentification = trim($group['funderIdentification'] ?? '');
            $awardNumbers = $group['awardNumbers'] ?? [];
            if (!is_array($awardNumbers)) {
                $awardNumbers = [];
            }
            /** @var Funder $funder */
            $funder = $funderDao->newDataObject();
            $funder->setContextId($contextId);
            $funder->setSubmissionId($submissionId);
            $funder->setFunderIdentification($funderIdentification);
            $funder->setFunderName($funderName);
            $funderId = $funderDao->insertObject($funder);
            foreach ($awardNumbers as $awardNumber) {
                $awardNumber = trim((string) $awardNumber);
                if ($awardNumber === '') {
                    continue;
                }
                /** @var FunderAward $funderAward */
                $funderAward = $funderAwardDao->newDataObject();
                $funderAward->setFunderId($funderId);
                $funderAward->setFunderAwardNumber($awardNumber);
                $funderAwardDao->insertObject($funderAward);
            }
        }
    }
}
