/**
 * Update File Use Case
 * Business logic for updating an existing file
 */

import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'

export type UpdateFileInput = {
  projectId: string
  userId: string
  fileId: string
  name?: string
  content?: string
  isMain?: boolean
}

export type UpdateFileOutput = {
  file: ProjectFile
}

export type UpdateFileUseCase = {
  execute(input: UpdateFileInput): Promise<UpdateFileOutput>
}

export function createUpdateFileUseCase(
  projectsRepository: IProjectsRepository
): UpdateFileUseCase {
  return {
    async execute(input: UpdateFileInput): Promise<UpdateFileOutput> {
      // Verify project exists and user has access
      const project = await projectsRepository.findById(input.projectId)

      if (!project) {
        throw new NotFoundError('Project not found')
      }

      if (project.userId !== input.userId) {
        throw new UnauthorizedError(
          'You do not have permission to update this file'
        )
      }

      // Library projects cannot have a main file
      if (input.isMain && project.isLibrary) {
        throw new Error('Library projects cannot have a main file')
      }

      // Find the file to update
      const existingFile = project.files.find((f) => f.id === input.fileId)

      if (!existingFile) {
        throw new NotFoundError('File not found')
      }

      // Build updates object
      const updates: {
        name?: ReturnType<typeof createFileName>
        content?: ReturnType<typeof createFileContent>
        isMain?: boolean
      } = {}
      if (input.name) updates.name = createFileName(input.name)
      if (input.content !== undefined)
        updates.content = createFileContent(input.content)
      if (input.isMain !== undefined) updates.isMain = input.isMain

      // Update file in database (repository handles unsetting other main files)
      const updatedFile = await projectsRepository.updateFile(
        input.projectId,
        input.fileId,
        updates
      )

      return { file: updatedFile }
    }
  }
}
