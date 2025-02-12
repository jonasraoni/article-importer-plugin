<?php
/**
 * @file exceptions/InvalidDocTypeException.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class InvalidDocTypeException
 * @brief Exception triggered when the article has an invalid doctype
 */

namespace APP\plugins\importexport\articleImporter\exceptions;

class InvalidDocTypeException extends ArticleSkippedException
{
}
