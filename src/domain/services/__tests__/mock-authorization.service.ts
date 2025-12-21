/**
 * Mock Authorization Service for tests
 */

import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '../authorization.service'

/**
 * Creates an AuthorizationService that works with an in-memory repository
 */
export function createMockAuthorizationService(
  projectsRepository: IProjectsRepository
): AuthorizationService {
  return {
    async canReadProject(projectId: string, userId: string): Promise<boolean> {
      const project = await projectsRepository.findById(projectId)
      if (!project) return false

      // Owner can always read
      if (project.userId === userId) return true

      // Public projects are readable by anyone
      if (project.visibility.value === 'public') return true

      // Libraries are readable by anyone
      if (project.isLibrary) return true

      // Check if project is shared with user
      const shares = await projectsRepository.getUserShares(projectId)
      if (shares.some((share) => share.userId === userId)) return true

      return false
    },

    async mustOwnProject(projectId: string, userId: string): Promise<Project> {
      const project = await projectsRepository.findById(projectId)

      if (!project) {
        throw new NotFoundError('Project not found')
      }

      if (project.userId !== userId) {
        throw new UnauthorizedError(
          'You do not have permission to modify this project'
        )
      }

      return project
    },

    async canAccessAsDependency(
      projectId: string,
      userId: string
    ): Promise<boolean> {
      const project = await projectsRepository.findById(projectId)
      if (!project) return false

      // Owner can always access
      if (project.userId === userId) return true

      // Public projects are accessible
      if (project.visibility.value === 'public') return true

      // Libraries are always accessible as dependencies
      if (project.isLibrary) return true

      return false
    }
  }
}
