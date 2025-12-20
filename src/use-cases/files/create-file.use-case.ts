/**
 * Create File Use Case
 * Business logic for creating a new file in a project
 */

import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'

export type CreateFileInput = {
  projectId: string
  userId: string
  name: string
  content?: string
  isMain?: boolean
}

export type CreateFileOutput = {
  file: ProjectFile
}

export type CreateFileUseCase = {
  execute(input: CreateFileInput): Promise<CreateFileOutput>
}

export function createCreateFileUseCase(
  projectsRepository: IProjectsRepository
): CreateFileUseCase {
  return {
    async execute(input: CreateFileInput): Promise<CreateFileOutput> {
      // Verify project exists and user has access
      const project = await projectsRepository.findById(input.projectId)

      if (!project) {
        throw new NotFoundError('Project not found')
      }

      if (project.userId !== input.userId) {
        throw new NotFoundError('Project not found')
      }

      // Create file with validated value objects
      const file = createProjectFile({
        id: crypto.randomUUID(),
        projectId: input.projectId,
        name: createFileName(input.name),
        content: createFileContent(input.content ?? ''),
        isMain: input.isMain ?? false,
        order: project.files.length
      })

      // If this is the main file, unset other main files
      let updatedFiles = project.files
      if (file.isMain) {
        updatedFiles = project.files.map((f) => ({ ...f, isMain: false }))
      }

      // Add the new file
      updatedFiles = [...updatedFiles, file]

      // Update project with new file
      const updatedProject = { ...project, files: updatedFiles }
      await projectsRepository.update(project.id, updatedProject)

      return { file }
    }
  }
}
