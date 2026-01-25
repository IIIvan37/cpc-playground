import type { Project, UserShare } from '../entities/project.entity'
import type { ProjectFile } from '../entities/project-file.entity'
import type { PaginatedResult, PaginationParams } from '../types/pagination'

/**
 * Tag representation from database
 */
export type Tag = {
  id: string
  name: string
}

/**
 * Search/filter params for paginated queries
 */
export type ProjectSearchParams = PaginationParams & {
  readonly search?: string
  readonly librariesOnly?: boolean
}

/**
 * Repository interface for Projects (Port in Hexagonal Architecture)
 * The implementation will be in infrastructure layer
 */
export interface IProjectsRepository {
  /**
   * Find all projects for a user (owned + shared with user)
   */
  findAll(userId: string): Promise<readonly Project[]>

  /**
   * Find all projects visible to a user
   * - If userId is provided: public projects + user's own projects + projects shared with user
   * - If userId is undefined (anonymous): only public projects
   */
  findVisible(userId?: string): Promise<readonly Project[]>

  /**
   * Find visible projects with pagination and search
   * - If userId is provided: public projects + user's own projects + projects shared with user
   * - If userId is undefined (anonymous): only public projects
   * - Supports server-side search and filtering
   */
  findVisiblePaginated(
    userId: string | undefined,
    params: ProjectSearchParams
  ): Promise<PaginatedResult<Project>>

  /**
   * Find a project by ID
   */
  findById(projectId: string): Promise<Project | null>

  /**
   * Find a project by share code
   */
  findByShareCode(shareCode: string): Promise<Project | null>

  /**
   * Create a new project
   */
  create(project: Project): Promise<Project>

  /**
   * Update an existing project
   */
  update(projectId: string, project: Partial<Project>): Promise<Project>

  /**
   * Delete a project
   */
  delete(projectId: string): Promise<void>

  // ============================================================================
  // Files
  // ============================================================================

  /**
   * Create a file in a project
   */
  createFile(projectId: string, file: ProjectFile): Promise<ProjectFile>

  /**
   * Update a file
   */
  updateFile(
    projectId: string,
    fileId: string,
    updates: Partial<ProjectFile>
  ): Promise<ProjectFile>

  /**
   * Delete a file
   */
  deleteFile(projectId: string, fileId: string): Promise<void>

  // Note: Link shares (with share_code) are handled by Netlify Blobs, not the database
  // The project_shares table only stores user shares (project_id, user_id)

  // ============================================================================
  // Tags
  // ============================================================================

  /**
   * Get all tags for a project
   */
  getTags(projectId: string): Promise<readonly Tag[]>

  /**
   * Get all available tags in the system
   */
  getAllTags(): Promise<readonly Tag[]>

  /**
   * Add a tag to a project (creates tag if it doesn't exist)
   */
  addTag(projectId: string, tagName: string): Promise<Tag>

  /**
   * Remove a tag from a project (by tag id or tag name)
   */
  removeTag(projectId: string, tagIdOrName: string): Promise<void>

  // ============================================================================
  // Dependencies
  // ============================================================================

  /**
   * Get dependencies for a project
   */
  getDependencies(projectId: string): Promise<readonly string[]>

  /**
   * Add a dependency to a project
   */
  addDependency(projectId: string, dependencyId: string): Promise<void>

  /**
   * Remove a dependency from a project
   */
  removeDependency(projectId: string, dependencyId: string): Promise<void>

  // ============================================================================
  // User Shares (sharing with specific users)
  // ============================================================================

  /**
   * Get all user shares for a project
   */
  getUserShares(projectId: string): Promise<readonly UserShare[]>

  /**
   * Find a user by username
   */
  findUserByUsername(
    username: string
  ): Promise<{ id: string; username: string } | null>

  /**
   * Search users by username prefix
   */
  searchUsers(
    query: string,
    limit?: number
  ): Promise<ReadonlyArray<{ id: string; username: string }>>

  /**
   * Add a user share to a project
   */
  addUserShare(projectId: string, userId: string): Promise<UserShare>

  /**
   * Remove a user share from a project
   */
  removeUserShare(projectId: string, userId: string): Promise<void>
}
