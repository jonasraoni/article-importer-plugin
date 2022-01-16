<?php
/**
 * @file plugins/importexport/articleImporter/exceptions/InvalidDocTypeException.inc.php
 *
 * Copyright (c) 2014-2022 Simon Fraser University
 * Copyright (c) 2000-2022 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class InvalidDocTypeException
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Exception triggered when the article has an invalid doctype
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Exceptions;

class InvalidDocTypeException extends ArticleSkippedException
{
}
