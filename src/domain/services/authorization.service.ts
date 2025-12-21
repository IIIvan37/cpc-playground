/**
 * Authorization Service
 * Centralized access control logic for projects
 */

import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

/**
 * Error messages used by the AuthorizationService
 * Exported for use in tests
 */
export const AUTH_ERROR_MESSAGES = {
  PROJECT_NOT_FOUND: 'Project not found',
  UNAUTHORIZED_MODIFY: 'You do not have permission to modify this project'
} as const

export type AuthorizationService = {
  /**
   * Verify user can read a project (owner, public, library, or shared)
   * Returns the project if accessible, throws otherwise
   */
  canReadProject(projectId: string, userId: string): Promise<boolean>

  /**
   * Verify user owns a project (for write operations)
   * Returns the project if owner, throws otherwise
   */
  mustOwnProject(projectId: string, userId: string): Promise<Project>

  /**
   * Verify user can access a project as dependency (public or library)
   * Returns true if accessible, false otherwise (does not throw)
   */
  canAccessAsDependency(projectId: string, userId: string): Promise<boolean>
}

/**
 * Factory function to create authorization service
 */
export function createAuthorizationService(
  projectsRepository: IProjectsRepository
): AuthorizationService {
  return {
    async canReadProject(projectId: string, userId: string): Promise<boolean> {
      const project = await projectsRepository.findById(projectId)

      if (!project) {
        return false
      }

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
      const shares = await projectsRepository.getUserShares(projectId)
      if (shares.some((share) => share.userId === userId)) {
        return true
      }

      return false
    },

    async mustOwnProject(projectId: string, userId: string): Promise<Project> {
      const project = await projectsRepository.findById(projectId)

      if (!project) {
        throw new NotFoundError(AUTH_ERROR_MESSAGES.PROJECT_NOT_FOUND)
      }

      if (project.userId !== userId) {
        throw new UnauthorizedError(AUTH_ERROR_MESSAGES.UNAUTHORIZED_MODIFY)
      }

      return project
    },

    async canAccessAsDependency(
      projectId: string,
      userId: string
    ): Promise<boolean> {
      const project = await projectsRepository.findById(projectId)

      if (!project) {
        return false
      }

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
