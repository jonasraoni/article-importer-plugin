<?php
/**
 * @file exceptions/NoSuitableParserException.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class NoSuitableParserException
 * @brief Exception triggered when there's no suitable parser for the article
 */

namespace APP\plugins\importexport\articleImporter\exceptions;

class NoSuitableParserException extends ArticleSkippedException
{
}
