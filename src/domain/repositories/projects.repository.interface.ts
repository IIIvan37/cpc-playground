import type { Project, ProjectShare } from '../entities/project.entity'

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
