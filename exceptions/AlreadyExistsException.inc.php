<?php
/**
 * @file plugins/importexport/articleImporter/exceptions/AlreadyExistsException.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class AlreadyExistsException
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Exception triggered when the article already exists
 */

namespace PKP\Plugins\ImportExport\ArticleImporter\Exceptions;

class AlreadyExistsException extends ArticleSkippedException {
}
