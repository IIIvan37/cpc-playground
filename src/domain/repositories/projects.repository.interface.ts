import type {
  Project,
  ProjectShare,
  UserShare
} from '../entities/project.entity'
import type { ProjectFile } from '../entities/project-file.entity'

/**
 * Tag representation from database
 */
export type Tag = {
  id: string
  name: string
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

  /**
   * Get all shares for a project
   */
  getShares(projectId: string): Promise<readonly ProjectShare[]>

  /**
   * Create a share for a project
   */
  createShare(projectId: string): Promise<ProjectShare>

  // ============================================================================
  // Tags
  // ============================================================================

  /**
   * Get all tags for a project
   */
  getTags(projectId: string): Promise<readonly Tag[]>

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
   * Add a user share to a project
   */
  addUserShare(projectId: string, userId: string): Promise<UserShare>

  /**
   * Remove a user share from a project
   */
  removeUserShare(projectId: string, userId: string): Promise<void>
}
