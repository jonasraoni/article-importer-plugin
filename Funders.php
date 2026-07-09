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
 * @brief Process funder/award data into the core native Funder structures.
 */

namespace APP\plugins\importexport\articleImporter;

use APP\core\Application;
use Exception;
use Illuminate\Support\Facades\DB;
use PKP\core\Core;
use PKP\funder\Funder;
use Throwable;

class Funders
{
    /** @var array<string, string>|null Lazily-loaded Fundref ID => ROR URL map */
    private static ?array $fundrefToRor = null;

    /** @var array<string, ?string> Per-request cache of Crossref Fundref ID => funder name lookups */
    private static array $crossrefNameCache = [];

    /**
     * Create funders and awards from JATS-style award-group data (e.g. funding-source, award-id, xlink:href).
     * If funding data already exists for the submission, it will be replaced.
     *
     * @param array<array{funderName: string, funderIdentification: string, awardNumbers: string[]}> $awardGroups
     */
    public static function createFundersFromAwardGroups(array $awardGroups, int $submissionId, string $locale): void
    {
        $seq = 0;
        foreach ($awardGroups as $group) {
            $funderName = trim($group['funderName'] ?? '');
            $funderIdentification = trim($group['funderIdentification'] ?? '');
            $awardNumbers = $group['awardNumbers'] ?? [];
            if (!is_array($awardNumbers)) {
                $awardNumbers = [];
            }

            // funder_identification is stored as a full Fundref URL (e.g. http://dx.doi.org/10.13039/501100001780);
            // basename() extracts the numeric Fundref ID used to resolve a ROR.
            $fundrefId = $funderIdentification !== '' ? basename($funderIdentification) : null;
            $ror = $fundrefId ? (static::getFundrefToRorMap()[$fundrefId] ?? null) : null;

            // No ROR and no name, but a Fundref ID exists, try resolving the name from Crossref.
            if (!$ror && $funderName === '' && $fundrefId) {
                $funderName = static::resolveFunderNameFromCrossref($fundrefId) ?? '';
            }

            if (!$ror && $funderName === '') {
                continue;
            }

            $grants = array_values(array_filter(array_map(
                fn ($number) => ($number = trim((string) $number)) === ''
                    ? null
                    : ['grantNumber' => $number, 'grantName' => null, 'grantDoi' => null],
                $awardNumbers
            )));

            $funder = Funder::create([
                'submissionId' => $submissionId,
                'ror' => $ror ?: null,
                'name' => $ror ? [] : [$locale => $funderName],
                'grants' => $grants,
                'seq' => $seq++,
            ]);

            // Preserve the original Fundref ID when no ROR match, so it can still be exported downstream
            if (!$ror && $fundrefId) {
                DB::table('funder_settings')->insert([
                    'funder_id' => $funder->id,
                    'locale' => '',
                    'setting_name' => 'fundrefId',
                    'setting_value' => $fundrefId,
                ]);
            }
        }
    }

    /**
     * Resolve a funder name from the Crossref Funder Registry API (public, no auth).
     * GET https://api.crossref.org/funders/{fundrefId} -> message.name
     */
    private static function resolveFunderNameFromCrossref(string $fundrefId): ?string
    {
        if (array_key_exists($fundrefId, static::$crossrefNameCache)) {
            return static::$crossrefNameCache[$fundrefId];
        }

        $name = null;
        try {
            $response = Application::get()->getHttpClient()->request(
                'GET',
                'https://api.crossref.org/funders/' . rawurlencode($fundrefId),
                ['timeout' => 5]
            );
            $body = json_decode($response->getBody(), true);
            $resolved = $body['message']['name'] ?? null;
            $name = is_string($resolved) && trim($resolved) !== '' ? trim($resolved) : null;
        } catch (Throwable $e) {
            error_log("Crossref API error: " . $e->getMessage());
        }

        return static::$crossrefNameCache[$fundrefId] = $name;
    }

    /**
     * Builds (once) and returns the Fundref ID => ROR URL map from the bundled ror_fundref.csv.
     *
     * @return array<string, string>
     */
    private static function getFundrefToRorMap(): array
    {
        if (static::$fundrefToRor !== null) {
            return static::$fundrefToRor;
        }

        static::$fundrefToRor = [];
        $path = Core::getBaseDir() . '/' . PKP_LIB_PATH . '/lib/rorFundrefData/data/ror_fundref.csv';
        if (!is_file($path) || ($handle = fopen($path, 'r')) === false) {
            throw new Exception("ROR-Fundref mapping file not found or unreadable at {$path}");
        }

        fgetcsv($handle); // skip header
        while (($row = fgetcsv($handle)) !== false) {
            [$rorId, $fundrefId] = $row + [null, null];
            if ($fundrefId !== null && $fundrefId !== '') {
                static::$fundrefToRor[$fundrefId] = $rorId;
            }
        }
        fclose($handle);

        return static::$fundrefToRor;
    }
}
