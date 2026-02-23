<?php
/**
 * @file update-review-dois.php
 *
 * Backfills review_assignments.doi_id from f1000r_report.doi.
 * Uses PostgreSQL (F1000) for source data and MySQL (OJS) for dois/review_assignments.
 *
 * Usage:
 *   php update-review-dois.php <context_path> [--dry-run]
 *
 * PostgreSQL connection: edit the $pgsqlConnection array below (same as import-from-database.php).
 */

require_once __DIR__ . '/../../../tools/bootstrap.php';

use Illuminate\Support\Facades\DB;
use PKP\cliTool\CommandLineTool;

new CommandLineTool();

$contextPath = $argv[1] ?? null;
$dryRun = in_array('--dry-run', $argv ?? [], true);

if (!$contextPath) {
    echo "Usage: php update-review-dois.php <context_path> [--dry-run]\n";
    echo "  context_path: Same as import-from-database.php (e.g. myjournal)\n";
    exit(1);
}

// Same PostgreSQL connection as import-from-database.php
$capsule = new Illuminate\Database\Capsule\Manager;
$capsule->addConnection([
    'driver' => 'pgsql',
    'host' => '127.0.0.1',
    'database' => 'ore',
    'username' => 'root',
    'password' => 'abc123',
], 'source');

$pgsql = $capsule->getConnection('source');
$mysql = DB::connection(); // OJS default (MySQL)

$journal = \APP\core\Application::getContextDAO()->getByPath($contextPath);
if (!$journal) {
    echo "Journal not found: {$contextPath}\n";
    exit(1);
}
$contextId = $journal->getId();

// Fetch from PostgreSQL: use v.doi (article version DOI) to find OJS submission
$reportRows = $pgsql->table('f1000r_version as v')
    ->join('f1000r_report as r', 'r.version_id', '=', 'v.id')
    ->join('f1000r_referee_report as frr', 'frr.report_id', '=', 'r.id')
    ->join('f1000r_referee as ref', 'ref.id', '=', 'frr.referee_id')
    ->whereNotNull('r.doi')
    ->where('r.doi', '!=', '')
    ->whereNotNull('v.doi')
    ->where('v.doi', '!=', '')
    ->select([
        'v.doi as article_doi',
        'v.version_number as round',
        'ref.email',
        'r.doi as report_doi',
    ])
    ->get();

$reportMap = [];
foreach ($reportRows as $row) {
    $key = trim($row->article_doi ?? '') . '|' . (int) $row->round . '|' . strtolower(trim($row->email ?? ''));
    $reportMap[$key] = trim($row->report_doi ?? '');
}

if (empty($reportMap)) {
    echo "No report DOIs found in PostgreSQL.\n";
    exit(0);
}

// Get OJS review_assignments with publication DOI from the review round's publication
$matches = $mysql->table('review_assignments as ra')
    ->join('review_rounds as rr', 'rr.review_round_id', '=', 'ra.review_round_id')
    ->join('publications as p', 'p.publication_id', '=', 'rr.publication_id')
    ->join('dois as d', 'd.doi_id', '=', 'p.doi_id')
    ->join('submissions as s', 's.submission_id', '=', 'ra.submission_id')
    ->join('users as u', 'u.user_id', '=', 'ra.reviewer_id')
    ->where('s.context_id', $contextId)
    ->whereNotNull('p.doi_id')
    ->select(['ra.review_id', 'd.doi as article_doi', 'rr.round', 'u.email'])
    ->get();

$toUpdate = [];
foreach ($matches as $m) {
    $key = trim($m->article_doi ?? '') . '|' . (int) $m->round . '|' . strtolower(trim($m->email ?? ''));
    if (isset($reportMap[$key])) {
        $toUpdate[(int) $m->review_id] = $reportMap[$key];
    }
}

if (empty($toUpdate)) {
    echo "No matching review assignments found.\n";
    exit(0);
}

echo count($toUpdate) . " review assignments to update.\n";

if ($dryRun) {
    foreach ($toUpdate as $reviewId => $doi) {
        echo "  review_id={$reviewId} -> doi={$doi}\n";
    }
    echo "Dry run complete. Run without --dry-run to apply.\n";
    exit(0);
}

$mysql->transaction(function () use ($mysql, $toUpdate, $contextId) {
    $uniqueDois = array_unique($toUpdate);
    $doiCache = [];

    foreach ($uniqueDois as $doi) {
        $existing = $mysql->table('dois')
            ->where('doi', $doi)
            ->where('context_id', $contextId)
            ->value('doi_id');
        if ($existing) {
            $doiCache[$doi] = (int) $existing;
        } else {
            $mysql->table('dois')->insert([
                'context_id' => $contextId,
                'doi' => $doi,
                'status' => 1,
            ]);
            $doiCache[$doi] = (int) $mysql->getPdo()->lastInsertId();
        }
    }

    foreach ($toUpdate as $reviewId => $doi) {
        $mysql->table('review_assignments')
            ->where('review_id', $reviewId)
            ->update(['doi_id' => $doiCache[$doi]]);
    }
});

echo "Done. Updated " . count($toUpdate) . " review assignments.\n";



