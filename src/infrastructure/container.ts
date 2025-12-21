/**
 * Dependency Injection Container
 * Wires up all use-cases with their repository dependencies
 */

import type {
  AddDependencyUseCase,
  RemoveDependencyUseCase
} from '@/use-cases/dependencies'
import {
  createAddDependencyUseCase,
  createRemoveDependencyUseCase
} from '@/use-cases/dependencies'
import type {
  CreateFileUseCase,
  DeleteFileUseCase,
  UpdateFileUseCase
} from '@/use-cases/files'
import {
  createCreateFileUseCase,
  createDeleteFileUseCase,
  createUpdateFileUseCase
} from '@/use-cases/files'
import type {
  CreateProjectUseCase,
  DeleteProjectUseCase,
  GetProjectsUseCase,
  GetProjectUseCase,
  GetProjectWithDependenciesUseCase,
  UpdateProjectUseCase
} from '@/use-cases/projects'
import {
  createCreateProjectUseCase,
  createDeleteProjectUseCase,
  createGetProjectsUseCase,
  createGetProjectUseCase,
  createGetProjectWithDependenciesUseCase,
  createUpdateProjectUseCase
} from '@/use-cases/projects'
import type {
  AddUserShareUseCase,
  RemoveUserShareUseCase
} from '@/use-cases/shares'
import {
  createAddUserShareUseCase,
  createRemoveUserShareUseCase
} from '@/use-cases/shares'
import type { AddTagUseCase, RemoveTagUseCase } from '@/use-cases/tags'
import { createAddTagUseCase, createRemoveTagUseCase } from '@/use-cases/tags'
import { createSupabaseProjectsRepository } from './repositories/supabase-projects.repository'

export type Container = {
  // Projects use cases
  createProject: CreateProjectUseCase
  getProjects: GetProjectsUseCase
  getProject: GetProjectUseCase
  getProjectWithDependencies: GetProjectWithDependenciesUseCase
  updateProject: UpdateProjectUseCase
  deleteProject: DeleteProjectUseCase
  // Files use cases
  createFile: CreateFileUseCase
  updateFile: UpdateFileUseCase
  deleteFile: DeleteFileUseCase
  // Tags use cases
  addTag: AddTagUseCase
  removeTag: RemoveTagUseCase
  // Dependencies use cases
  addDependency: AddDependencyUseCase
  removeDependency: RemoveDependencyUseCase
  // Shares use cases
  addUserShare: AddUserShareUseCase
  removeUserShare: RemoveUserShareUseCase
}

/**
 * Creates the application container with all dependencies wired up
 */
export function createContainer(): Container {
  // Infrastructure layer - repositories
  const projectsRepository = createSupabaseProjectsRepository()

  // Use cases layer - inject repository dependencies
  return {
    createProject: createCreateProjectUseCase(projectsRepository),
    getProjects: createGetProjectsUseCase(projectsRepository),
    getProject: createGetProjectUseCase(projectsRepository),
    getProjectWithDependencies:
      createGetProjectWithDependenciesUseCase(projectsRepository),
    updateProject: createUpdateProjectUseCase(projectsRepository),
    deleteProject: createDeleteProjectUseCase(projectsRepository),
    createFile: createCreateFileUseCase(projectsRepository),
    updateFile: createUpdateFileUseCase(projectsRepository),
    deleteFile: createDeleteFileUseCase(projectsRepository),
    addTag: createAddTagUseCase(projectsRepository),
    removeTag: createRemoveTagUseCase(projectsRepository),
    addDependency: createAddDependencyUseCase(projectsRepository),
    removeDependency: createRemoveDependencyUseCase(projectsRepository),
    addUserShare: createAddUserShareUseCase(projectsRepository),
    removeUserShare: createRemoveUserShareUseCase(projectsRepository)
  }
}

/**
 * Singleton container instance for the application
 */
export const container = createContainer()
