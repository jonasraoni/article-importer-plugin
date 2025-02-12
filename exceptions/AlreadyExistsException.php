<?php
/**
 * @file exceptions/AlreadyExistsException.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class AlreadyExistsException
 * @brief Exception triggered when the article already exists
 */

namespace APP\plugins\importexport\articleImporter\exceptions;

class AlreadyExistsException extends ArticleSkippedException
{
}
