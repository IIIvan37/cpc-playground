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

      // Find the file to update
      const fileIndex = project.files.findIndex((f) => f.id === input.fileId)

      if (fileIndex === -1) {
        throw new NotFoundError('File not found')
      }

      const existingFile = project.files[fileIndex]

      // Update file with new values
      const updatedFile = {
        ...existingFile,
        ...(input.name && { name: createFileName(input.name) }),
        ...(input.content !== undefined && {
          content: createFileContent(input.content)
        }),
        ...(input.isMain !== undefined && { isMain: input.isMain })
      }

      // If setting as main, unset other main files
      let updatedFiles = [...project.files]
      if (input.isMain === true) {
        updatedFiles = updatedFiles.map((f, idx) =>
          idx === fileIndex ? updatedFile : { ...f, isMain: false }
        )
      } else {
        updatedFiles[fileIndex] = updatedFile
      }

      // Update project
      const updatedProject = { ...project, files: updatedFiles }
      await projectsRepository.update(project.id, updatedProject)

      return { file: updatedFile }
    }
  }
}
