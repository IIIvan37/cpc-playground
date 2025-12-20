import { type Project, updateProject } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
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

export class UpdateProjectUseCase {
  constructor(private readonly projectsRepository: IProjectsRepository) {}

  async execute(input: UpdateProjectInput): Promise<UpdateProjectOutput> {
    // Get existing project
    const existingProject = await this.projectsRepository.findById(
      input.projectId
    )

    if (!existingProject) {
      throw new NotFoundError(`Project ${input.projectId} not found`)
    }

    // Authorization check
    if (existingProject.userId !== input.userId) {
      throw new UnauthorizedError(
        'You are not authorized to update this project'
      )
    }

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
    const savedProject = await this.projectsRepository.update(
      input.projectId,
      updatedProject
    )

    return { project: savedProject }
  }
}

export function createUpdateProjectUseCase(
  projectsRepository: IProjectsRepository
): UpdateProjectUseCase {
  return new UpdateProjectUseCase(projectsRepository)
}
