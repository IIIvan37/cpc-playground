/**
 * Delete File Use Case
 * Business logic for deleting a file from a project
 */

import {
  NotFoundError,
  UnauthorizedError,
  ValidationError
} from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

export type DeleteFileInput = {
  projectId: string
  userId: string
  fileId: string
}

export type DeleteFileOutput = {
  success: boolean
}

export type DeleteFileUseCase = {
  execute(input: DeleteFileInput): Promise<DeleteFileOutput>
}

export function createDeleteFileUseCase(
  projectsRepository: IProjectsRepository
): DeleteFileUseCase {
  return {
    async execute(input: DeleteFileInput): Promise<DeleteFileOutput> {
      // Verify project exists and user has access
      const project = await projectsRepository.findById(input.projectId)

      if (!project) {
        throw new NotFoundError('Project not found')
      }

      if (project.userId !== input.userId) {
        throw new UnauthorizedError(
          'You do not have permission to delete this file'
        )
      }

      // Find the file
      const fileExists = project.files.some((f) => f.id === input.fileId)

      if (!fileExists) {
        throw new NotFoundError('File not found')
      }

      // Don't allow deleting the last file
      if (project.files.length === 1) {
        throw new ValidationError('Cannot delete the last file in a project')
      }

      // Remove the file
      const updatedFiles = project.files.filter((f) => f.id !== input.fileId)

      // If we deleted the main file, make the first file main
      const hadMainFile = project.files.some((f) => f.isMain)
      const hasMainFileAfter = updatedFiles.some((f) => f.isMain)

      if (hadMainFile && !hasMainFileAfter && updatedFiles.length > 0) {
        updatedFiles[0] = { ...updatedFiles[0], isMain: true }
      }

      // Update project
      const updatedProject = { ...project, files: updatedFiles }
      await projectsRepository.update(project.id, updatedProject)

      return { success: true }
    }
  }
}
