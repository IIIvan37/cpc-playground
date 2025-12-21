/**
 * Delete File Use Case
 * Business logic for deleting a file from a project
 */

import { NotFoundError, ValidationError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): DeleteFileUseCase {
  return {
    async execute(input: DeleteFileInput): Promise<DeleteFileOutput> {
      // Verify project exists and user has access
      const project = await authorizationService.mustOwnProject(
        input.projectId,
        input.userId
      )

      // Find the file
      const fileExists = project.files.some((f) => f.id === input.fileId)

      if (!fileExists) {
        throw new NotFoundError('File not found')
      }

      // Don't allow deleting the last file
      if (project.files.length === 1) {
        throw new ValidationError('Cannot delete the last file in a project')
      }

      // Check if we're deleting the main file
      const fileToDelete = project.files.find((f) => f.id === input.fileId)
      const isDeletingMainFile = fileToDelete?.isMain

      // Delete the file from database
      await projectsRepository.deleteFile(input.projectId, input.fileId)

      // If we deleted the main file, make another file main
      if (isDeletingMainFile) {
        const remainingFiles = project.files.filter(
          (f) => f.id !== input.fileId
        )
        if (remainingFiles.length > 0) {
          await projectsRepository.updateFile(
            input.projectId,
            remainingFiles[0].id,
            {
              isMain: true
            }
          )
        }
      }

      return { success: true }
    }
  }
}
