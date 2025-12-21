import type { Project, ProjectShare } from '../entities/project.entity'

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
   * Find all projects for a user
   */
  findAll(userId: string): Promise<readonly Project[]>

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
}
