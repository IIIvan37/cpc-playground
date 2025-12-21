/**
 * Create File Use Case
 * Business logic for creating a new file in a project
 */

import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): CreateFileUseCase {
  return {
    async execute(input: CreateFileInput): Promise<CreateFileOutput> {
      // Verify project exists and user has access
      const project = await authorizationService.mustOwnProject(
        input.projectId,
        input.userId
      )

      // Create file with validated value objects
      const file = createProjectFile({
        id: crypto.randomUUID(),
        projectId: input.projectId,
        name: createFileName(input.name),
        content: createFileContent(input.content ?? ''),
        isMain: input.isMain ?? false,
        order: project.files.length
      })

      // If this is the main file, unset other main files first
      if (file.isMain) {
        for (const existingFile of project.files) {
          if (existingFile.isMain) {
            await projectsRepository.updateFile(
              input.projectId,
              existingFile.id,
              {
                isMain: false
              }
            )
          }
        }
      }

      // Create the file in the database
      const createdFile = await projectsRepository.createFile(
        input.projectId,
        file
      )

      return { file: createdFile }
    }
  }
}
