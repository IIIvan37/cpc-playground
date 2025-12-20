import { createProject, type Project } from '@/domain/entities/project.entity'
import {
  createProjectFile,
  type ProjectFile
} from '@/domain/entities/project-file.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import {
  createFileContent,
  type FileContent
} from '@/domain/value-objects/file-content.vo'
import {
  createFileName,
  type FileName
} from '@/domain/value-objects/file-name.vo'
import {
  createProjectName,
  type ProjectName
} from '@/domain/value-objects/project-name.vo'
import {
  Visibility,
  type Visibility as VisibilityType
} from '@/domain/value-objects/visibility.vo'

/**
 * Use Case: Create a new project
 */

export type CreateProjectInput = {
  userId: string
  name: string
  description?: string
  visibility?: 'private' | 'unlisted' | 'public'
  isLibrary?: boolean
  files?: Array<{
    name: string
    content: string
    isMain?: boolean
  }>
}

export type CreateProjectOutput = {
  project: Project
}

export type CreateProjectUseCase = {
  execute(input: CreateProjectInput): Promise<CreateProjectOutput>
}

/**
 * Factory function that creates CreateProjectUseCase
 */
export function createCreateProjectUseCase(
  projectsRepository: IProjectsRepository
): CreateProjectUseCase {
  return {
    async execute(input: CreateProjectInput): Promise<CreateProjectOutput> {
      // Create value objects from primitive inputs
      const projectName: ProjectName = createProjectName(input.name)
      const visibility: VisibilityType = input.visibility
        ? Visibility[input.visibility.toUpperCase() as keyof typeof Visibility]
        : Visibility.PRIVATE

      // Create project files if provided
      const files: ProjectFile[] = []
      if (input.files && input.files.length > 0) {
        for (const [index, fileInput] of input.files.entries()) {
          const fileName: FileName = createFileName(fileInput.name)
          const fileContent: FileContent = createFileContent(fileInput.content)

          const file = createProjectFile({
            projectId: '', // Will be set after project creation
            name: fileName,
            content: fileContent,
            isMain: fileInput.isMain ?? index === 0,
            order: index
          })

          files.push(file)
        }
      }

      // Create project entity
      const project = createProject({
        userId: input.userId,
        name: projectName,
        description: input.description ?? null,
        visibility,
        isLibrary: input.isLibrary ?? false,
        files
      })

      // Persist via repository
      const createdProject = await projectsRepository.create(project)

      return { project: createdProject }
    }
  }
}
