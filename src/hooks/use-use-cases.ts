/**
 * Dependency Injection Container
 * Simple factory-based DI for use-cases
 */

import { createSupabaseProjectsRepository } from '@/infrastructure/repositories/supabase-projects.repository'
import {
  createCreateProjectUseCase,
  createDeleteProjectUseCase,
  createGetProjectsUseCase,
  createGetProjectUseCase,
  createUpdateProjectUseCase
} from '@/use-cases/projects'

// Singleton instances (lazy initialization)
let projectsRepositoryInstance: ReturnType<
  typeof createSupabaseProjectsRepository
> | null = null

function getProjectsRepository() {
  if (!projectsRepositoryInstance) {
    projectsRepositoryInstance = createSupabaseProjectsRepository()
  }
  return projectsRepositoryInstance
}

// Use-case factories
export function useGetProjectsUseCase() {
  return createGetProjectsUseCase(getProjectsRepository())
}

export function useGetProjectUseCase() {
  return createGetProjectUseCase(getProjectsRepository())
}

export function useCreateProjectUseCase() {
  return createCreateProjectUseCase(getProjectsRepository())
}

export function useUpdateProjectUseCase() {
  return createUpdateProjectUseCase(getProjectsRepository())
}

export function useDeleteProjectUseCase() {
  return createDeleteProjectUseCase(getProjectsRepository())
}
