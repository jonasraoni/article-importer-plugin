<?php
/**
 * @file plugins/importexport/articleImporter/Configuration.inc.php
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Configuration
 * @ingroup plugins_importexport_articleImporter
 *
 * @brief Keeps the import options and common shared settings
 */

namespace PKP\Plugins\ImportExport\ArticleImporter;

class Configuration {
	/** @var string Default title for sections */
	private $_defaultSectionName;
	/** @var string[] List of classes that can parse XML articles */
	private $_parsers;
	/** @var \Context Context */
	private $_context;
	/** @var \User User instance */
	private $_user;
	/** @var \User Editor instance */
	private $_editor;
	/** @var string Default email */
	private $_email;
	/** @var string Import path */
	private $_importPath;
	/** @var int Editor's user group ID */
	private $_editorGroupId;
	/** @var int|null Author's user group ID */
	private $_authorGroupId;
	/** @var \Genre Submission genre instance */
	private $_genre;

	/**
	 * Constructor
	 * @param string[] $parsers List of parser classes
	 * @param string $contextPath Path of the context
	 * @param string $username User to whom imported articles will be assigned
	 * @param string $editorUsername Editor to whom imported articles should be assigned
	 * @param string $email Default email when the author email is not provided in the XML
	 * @param string $importPath Base path where the "volume/issue/article" structure is kept
	 */
	public function __construct(array $parsers, string $contextPath, string $username, string $editorUsername, string $email, string $importPath, string $defaultSectionName = 'Articles')
	{
		$this->_defaultSectionName = $defaultSectionName;
		$this->_parsers = $parsers;

		if (!$this->_context = \Application::getContextDAO()->getByPath($contextPath)) {
			throw new \InvalidArgumentException(__('plugins.importexport.articleImporter.unknownJournal', ['journal' => $contextPath]));
		}

		[$this->_user, $this->_editor] = array_map(function ($username) {
			if (!$entity = \DAORegistry::getDAO('UserDAO')->getByUsername($username)) {
				throw new \InvalidArgumentException(__('plugins.importexport.articleImporter.unknownUser', ['username' => $username]));
			}
			return $entity;
		}, [$username, $editorUsername]);

		if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
			throw new \InvalidArgumentException(__('plugins.importexport.articleImporter.unknownEmail', ['email' => $email]));
		}
		$this->_email = $email;

		if (!is_dir($importPath)) {
			throw new \InvalidArgumentException(__('plugins.importexport.articleImporter.directoryDoesNotExist', ['directory' => $importPath]));
		}
		$this->_importPath = $importPath;

		// Finds the user group ID for the editor
		$userGroupDao = \DAORegistry::getDAO('UserGroupDAO');
		$userGroupIds = $userGroupDao->getUserGroupIdsByRoleId(\ROLE_ID_MANAGER, $this->_context->getId());
		foreach ($userGroupIds as $id) {
			if ($userGroupDao->userGroupAssignedToStage($id, \WORKFLOW_STAGE_ID_PRODUCTION)) {
				$this->_editorGroupId = $id;
				break;
			}
		}
		if (!$this->_editorGroupId) {
			throw new \Exception(__('plugins.importexport.articleImporter.missingEditorGroupId'));
		}

		// Finds the user group ID for the authors
		$userGroupDao = \DAORegistry::getDAO('UserGroupDAO');
		$userGroupIds = $userGroupDao->getUserGroupIdsByRoleId(\ROLE_ID_AUTHOR, $this->_context->getId());
		$this->_authorGroupId = reset($userGroupIds);

		// Retrieves the genre for submissions
		$this->_genre = \DAORegistry::getDAO('GenreDAO')->getByKey('SUBMISSION', $this->_context->getId());
	}

	/**
	 * Retrieves the context instance
	 * @return \Context
	 */
	public function getContext(): \Context
	{
		return $this->_context;
	}

	/**
	 * Retrieves the user instance
	 * @return \User
	*/
	public function getUser(): \User
	{
		return $this->_user;
	}

	/**
	 * Retrieves the user instance
	 * @return \User
	 */
	public function getEditor(): \User
	{
		return $this->_editor;
	}

	/**
	 * Retrieves the default email which will be assigned to authors (when absent)
	 * @return \Context
	 */
	public function getEmail(): string
	{
		return $this->_email;
	}

	/**
	 * Retrieves the import base path
	 * @return string
	 */
	public function getImportPath(): string
	{
		return $this->_importPath;
	}

	/**
	 * Retrieves the editor user group ID
	 * @return int
	 */
	public function getEditorGroupId(): int
	{
		return $this->_editorGroupId;
	}

	/**
	 * Retrieves the author user group ID
	 * @return ?int
	 */
	public function getAuthorGroupId(): ?int
	{
		return $this->_authorGroupId;
	}

	/**
	 * Retrieves the submission genre
	 * @return \Genre
	 */
	public function getSubmissionGenre(): \Genre
	{
		return $this->_genre;
	}


	/**
	 * Retrieves an article iterator
	 * @return ArticleIterator
	 */
	public function getArticleIterator(): ArticleIterator
	{
		return new ArticleIterator($this->getImportPath());
	}

	/**
	 * Retrieves the list of parsers
	 * @return string[]
	 */
	public function getParsers(): array
	{
		return $this->_parsers;
	}

	/**
	 * Retrieves the default section name
	 * @return string
	 */
	public function getDefaultSectionName(): string
	{
		return $this->_defaultSectionName;
	}
}
