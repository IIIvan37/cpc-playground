/**
 * Authorization Service
 * Centralized access control logic for projects
 */

import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import { AUTH_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

export type AuthorizationService = {
  /**
   * Check if user can read a project (owner, public, library, or shared)
   * @param project - The project to check (avoids refetching)
   * @param userId - The user ID to check access for
   * @returns true if accessible, false otherwise
   */
  canReadProject(project: Project, userId: string): Promise<boolean>

  /**
   * Verify user owns a project (for write operations)
   * Returns the project if owner, throws otherwise
   */
  mustOwnProject(projectId: string, userId: string): Promise<Project>

  /**
   * Check if user can access a project as dependency (owner, public, or library)
   * @param project - The project to check (avoids refetching)
   * @param userId - The user ID to check access for
   * @returns true if accessible, false otherwise
   */
  canAccessAsDependency(project: Project, userId: string): boolean
}

/**
 * Factory function to create authorization service
 */
export function createAuthorizationService(
  projectsRepository: IProjectsRepository
): AuthorizationService {
  return {
    async canReadProject(project: Project, userId: string): Promise<boolean> {
      // Owner can always read
      if (project.userId === userId) {
        return true
      }

      // Public projects are readable by anyone
      if (project.visibility.value === 'public') {
        return true
      }

      // Libraries are readable by anyone
      if (project.isLibrary) {
        return true
      }

      // Check if project is shared with user
      const shares = await projectsRepository.getUserShares(project.id)
      if (shares.some((share) => share.userId === userId)) {
        return true
      }

      return false
    },

    async mustOwnProject(projectId: string, userId: string): Promise<Project> {
      const project = await projectsRepository.findById(projectId)

      if (!project) {
        throw new NotFoundError(AUTH_ERRORS.PROJECT_NOT_FOUND)
      }

      if (project.userId !== userId) {
        throw new UnauthorizedError(AUTH_ERRORS.UNAUTHORIZED_MODIFY)
      }

      return project
    },

    canAccessAsDependency(project: Project, userId: string): boolean {
      // Owner can always access
      if (project.userId === userId) {
        return true
      }

      // Public projects are accessible
      if (project.visibility.value === 'public') {
        return true
      }

      // Libraries are always accessible as dependencies
      if (project.isLibrary) {
        return true
      }

      return false
    }
  }
}
