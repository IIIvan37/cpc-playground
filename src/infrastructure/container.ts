/**
 * Dependency Injection Container
 * Wires up all use-cases with their repository dependencies
 */

import type {
  CreateProjectUseCase,
  DeleteProjectUseCase,
  GetProjectsUseCase,
  GetProjectUseCase,
  UpdateProjectUseCase
} from '@/use-cases/projects'
import {
  createCreateProjectUseCase,
  createDeleteProjectUseCase,
  createGetProjectsUseCase,
  createGetProjectUseCase,
  createUpdateProjectUseCase
} from '@/use-cases/projects'
import { createSupabaseProjectsRepository } from './repositories/supabase-projects.repository'

export type Container = {
  // Projects use cases
  createProject: CreateProjectUseCase
  getProjects: GetProjectsUseCase
  getProject: GetProjectUseCase
  updateProject: UpdateProjectUseCase
  deleteProject: DeleteProjectUseCase
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
    updateProject: createUpdateProjectUseCase(projectsRepository),
    deleteProject: createDeleteProjectUseCase(projectsRepository)
  }
}

/**
 * Singleton container instance for the application
 */
export const container = createContainer()
