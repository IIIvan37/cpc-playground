import { type Project, updateProject } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'

/**
 * Use Case: Update a project
 */

export type UpdateProjectInput = {
  projectId: string
  userId: string
  updates: {
    name?: string
    description?: string | null
    visibility?: 'private' | 'unlisted' | 'public'
    isLibrary?: boolean
  }
}

export type UpdateProjectOutput = {
  project: Project
}

export type UpdateProjectUseCase = {
  execute(input: UpdateProjectInput): Promise<UpdateProjectOutput>
}

/**
 * Factory function that creates UpdateProjectUseCase
 */
export function createUpdateProjectUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): UpdateProjectUseCase {
  return {
    async execute(input: UpdateProjectInput): Promise<UpdateProjectOutput> {
      // Get existing project and verify ownership
      const existingProject = await authorizationService.mustOwnProject(
        input.projectId,
        input.userId
      )

      // Create value objects from updates
      const updates: Parameters<typeof updateProject>[1] = {}

      if (input.updates.name !== undefined) {
        updates.name = createProjectName(input.updates.name)
      }

      if (input.updates.description !== undefined) {
        updates.description = input.updates.description
      }

      if (input.updates.visibility !== undefined) {
        updates.visibility = createVisibility(input.updates.visibility)
      }

      if (input.updates.isLibrary !== undefined) {
        updates.isLibrary = input.updates.isLibrary
      }

      // Update entity
      const updatedProject = updateProject(existingProject, updates)

      // Persist
      const savedProject = await projectsRepository.update(
        input.projectId,
        updatedProject
      )

      return { project: savedProject }
    }
  }
}
