import type { IProjectsRepository } from '../../domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

/**
 * File with project context for compilation
 */
export interface FileWithProject {
  id: string
  projectId: string
  projectName: string
  name: string
  content: string
  isMain: boolean
  order: number
}

/**
 * Parameters for getting a project with all its dependencies
 */
export interface GetProjectWithDependenciesInput {
  projectId: string
  userId: string
}

/**
 * Output type for get project with dependencies use case
 */
export type GetProjectWithDependenciesOutput = {
  files: FileWithProject[]
}

/**
 * Use Case: Get a project with all its dependencies
 */
export type GetProjectWithDependenciesUseCase = {
  execute(
    input: GetProjectWithDependenciesInput
  ): Promise<GetProjectWithDependenciesOutput>
}

/**
 * Factory for creating a get project with dependencies use case
 */
export const createGetProjectWithDependenciesUseCase = (
  repository: IProjectsRepository,
  authorizationService: AuthorizationService
): GetProjectWithDependenciesUseCase => {
  return {
    /**
     * Gets a project and all files from its dependencies recursively
     * Returns files from the project and all dependency projects
     */
    async execute(
      input: GetProjectWithDependenciesInput
    ): Promise<GetProjectWithDependenciesOutput> {
      const { projectId, userId } = input

      const allFiles: FileWithProject[] = []
      const visitedProjects = new Set<string>()

      async function fetchProjectFiles(id: string): Promise<void> {
        // Prevent circular dependencies
        if (visitedProjects.has(id)) return
        visitedProjects.add(id)

        // Fetch the project
        const project = await repository.findById(id)
        if (!project) {
          throw new Error(`Project not found: ${id}`)
        }

        // Check user has access to this project as a dependency
        // User can access if: they own it, it's public, or it's a library
        const canAccess = await authorizationService.canAccessAsDependency(
          id,
          userId
        )
        if (!canAccess) {
          throw new Error('Access denied to project')
        }

        // Add files from this project
        const projectFiles = project.files.map((file) => ({
          id: file.id,
          projectId: project.id,
          projectName: project.name.value,
          name: file.name.value,
          content: file.content.value,
          isMain: file.isMain,
          order: file.order
        }))

        allFiles.push(...projectFiles)

        // Recursively fetch dependencies
        for (const dependencyId of project.dependencies) {
          await fetchProjectFiles(dependencyId)
        }
      }

      await fetchProjectFiles(projectId)
      return { files: allFiles }
    }
  }
}
