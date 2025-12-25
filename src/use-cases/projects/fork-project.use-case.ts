import { createProject, type Project } from '@/domain/entities/project.entity'
import {
  createProjectFile,
  type ProjectFile
} from '@/domain/entities/project-file.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'

/**
 * Use Case: Fork (copy) a project
 * Creates a copy of an existing project for the current user
 */

export type ForkProjectInput = {
  /** ID of the project to fork */
  projectId: string
  /** ID of the user creating the fork */
  userId: string
  /** Optional new name for the forked project */
  newName?: string
}

export type ForkProjectOutput = {
  project: Project
}

export type ForkProjectUseCase = {
  execute(input: ForkProjectInput): Promise<ForkProjectOutput>
}

/**
 * Factory function that creates ForkProjectUseCase
 */
export function createForkProjectUseCase(
  projectsRepository: IProjectsRepository
): ForkProjectUseCase {
  return {
    async execute(input: ForkProjectInput): Promise<ForkProjectOutput> {
      // Get the source project
      const sourceProject = await projectsRepository.findById(input.projectId)

      if (!sourceProject) {
        throw new NotFoundError('Project not found')
      }

      // Check access: user can fork if:
      // - They own the project
      // - The project is public
      // - The project is shared with them
      const isOwner = sourceProject.userId === input.userId
      const isPublic = sourceProject.visibility.value === 'public'
      const isSharedWithUser = sourceProject.userShares?.some(
        (share) => share.userId === input.userId
      )

      if (!isOwner && !isPublic && !isSharedWithUser) {
        throw new UnauthorizedError(
          'You do not have access to fork this project'
        )
      }

      // Create a unique name for the fork
      // Use "- copy" suffix instead of "(copy)" to comply with project name validation
      const baseName = input.newName || sourceProject.name.value
      const forkName = isOwner ? `${baseName} - copy` : baseName

      // Copy files from the source project
      const files: ProjectFile[] = sourceProject.files.map((file, index) =>
        createProjectFile({
          projectId: '', // Will be set after project creation
          name: createFileName(file.name.value),
          content: createFileContent(file.content.value),
          isMain: file.isMain,
          order: index
        })
      )

      // Copy tags from the source project
      const tags = [...(sourceProject.tags ?? [])]

      // Copy dependency IDs from the source project
      const dependencyIds = (sourceProject.dependencies ?? []).map(
        (dep) => dep.id
      )

      // Create the new project (always private, inherit library type)
      const forkedProject = createProject({
        userId: input.userId,
        name: createProjectName(forkName),
        description: sourceProject.description,
        visibility: Visibility.PRIVATE,
        isLibrary: sourceProject.isLibrary,
        files,
        tags
      })

      // Persist via repository
      const createdProject = await projectsRepository.create(forkedProject)

      // Add dependencies to the forked project
      if (dependencyIds.length > 0) {
        for (const dependencyId of dependencyIds) {
          await projectsRepository.addDependency(
            createdProject.id,
            dependencyId
          )
        }
      }

      // Fetch the complete project with dependencies
      const completeProject = await projectsRepository.findById(
        createdProject.id
      )

      return { project: completeProject ?? createdProject }
    }
  }
}
