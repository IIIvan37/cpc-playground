import type { ProjectFile } from '../entities/project-file.entity'

/**
 * Repository interface for ProjectFiles (Port in Hexagonal Architecture)
 * The implementation will be in infrastructure layer
 */
export interface IFilesRepository {
  /**
   * Find all files for a project
   */
  findByProjectId(projectId: string): Promise<readonly ProjectFile[]>

  /**
   * Find a file by ID
   */
  findById(fileId: string): Promise<ProjectFile | null>

  /**
   * Create a new file
   */
  create(file: ProjectFile): Promise<ProjectFile>

  /**
   * Update an existing file
   */
  update(fileId: string, updates: Partial<ProjectFile>): Promise<ProjectFile>

  /**
   * Delete a file
   */
  delete(fileId: string): Promise<void>

  /**
   * Reorder files in a project
   */
  reorder(
    projectId: string,
    fileOrders: Array<{ id: string; order: number }>
  ): Promise<void>
}
