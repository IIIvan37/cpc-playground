/**
 * Dependency Injection Container
 * Wires up all use-cases with their repository dependencies
 */

import {
  type AuthorizationService,
  createAuthorizationService
} from '@/domain/services'
import { supabase } from '@/lib/supabase'
import type {
  GetCurrentUserUseCase,
  GetUserProfileUseCase,
  RequestPasswordResetUseCase,
  SignInUseCase,
  SignInWithOAuthUseCase,
  SignOutUseCase,
  SignUpUseCase,
  UpdatePasswordUseCase,
  UpdateUserProfileUseCase
} from '@/use-cases/auth'
import {
  createGetCurrentUserUseCase,
  createGetUserProfileUseCase,
  createRequestPasswordResetUseCase,
  createSignInUseCase,
  createSignInWithOAuthUseCase,
  createSignOutUseCase,
  createSignUpUseCase,
  createUpdatePasswordUseCase,
  createUpdateUserProfileUseCase
} from '@/use-cases/auth'
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
  ForkProjectUseCase,
  GetProjectsUseCase,
  GetProjectUseCase,
  GetProjectWithDependenciesUseCase,
  GetVisibleProjectsUseCase,
  SaveThumbnailUseCase,
  UpdateProjectUseCase
} from '@/use-cases/projects'
import {
  createCreateProjectUseCase,
  createDeleteProjectUseCase,
  createForkProjectUseCase,
  createGetProjectsUseCase,
  createGetProjectUseCase,
  createGetProjectWithDependenciesUseCase,
  createGetVisibleProjectsUseCase,
  createSaveThumbnailUseCase,
  createUpdateProjectUseCase
} from '@/use-cases/projects'
import type { GetSharedCodeUseCase } from '@/use-cases/shared-code'
import { createGetSharedCodeUseCase } from '@/use-cases/shared-code'
import type {
  AddUserShareUseCase,
  RemoveUserShareUseCase,
  SearchUsersUseCase
} from '@/use-cases/shares'
import {
  createAddUserShareUseCase,
  createRemoveUserShareUseCase,
  createSearchUsersUseCase
} from '@/use-cases/shares'
import type { AddTagUseCase, RemoveTagUseCase } from '@/use-cases/tags'
import { createAddTagUseCase, createRemoveTagUseCase } from '@/use-cases/tags'
import { createApiSharedCodeRepository } from './repositories/api-shared-code.repository'
import { createSupabaseAuthRepository } from './repositories/supabase-auth.repository'
import { createSupabaseProjectsRepository } from './repositories/supabase-projects.repository'
import { createSupabaseThumbnailStorage } from './repositories/supabase-thumbnail-storage'

export type Container = {
  // Auth repository (exposed for onAuthStateChange subscription)
  authRepository: ReturnType<typeof createSupabaseAuthRepository>
  // Services
  authorizationService: AuthorizationService
  // Auth use cases
  signIn: SignInUseCase
  signUp: SignUpUseCase
  signOut: SignOutUseCase
  signInWithOAuth: SignInWithOAuthUseCase
  getCurrentUser: GetCurrentUserUseCase
  getUserProfile: GetUserProfileUseCase
  updateUserProfile: UpdateUserProfileUseCase
  requestPasswordReset: RequestPasswordResetUseCase
  updatePassword: UpdatePasswordUseCase
  // Projects use cases
  createProject: CreateProjectUseCase
  getProjects: GetProjectsUseCase
  getVisibleProjects: GetVisibleProjectsUseCase
  getProject: GetProjectUseCase
  getProjectWithDependencies: GetProjectWithDependenciesUseCase
  updateProject: UpdateProjectUseCase
  deleteProject: DeleteProjectUseCase
  forkProject: ForkProjectUseCase
  saveThumbnail: SaveThumbnailUseCase
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
  searchUsers: SearchUsersUseCase
  // Shared code use cases
  getSharedCode: GetSharedCodeUseCase
}

/**
 * Creates the application container with all dependencies wired up
 */
export function createContainer(): Container {
  // Infrastructure layer - repositories
  const authRepository = createSupabaseAuthRepository(supabase)
  const projectsRepository = createSupabaseProjectsRepository(supabase)
  const sharedCodeRepository = createApiSharedCodeRepository()
  const thumbnailStorage = createSupabaseThumbnailStorage(supabase)

  // Domain services
  const authorizationService = createAuthorizationService(projectsRepository)

  // Use cases layer - inject repository dependencies
  return {
    // Repository (for subscriptions)
    authRepository,
    // Services
    authorizationService,
    // Auth use cases
    signIn: createSignInUseCase(authRepository),
    signUp: createSignUpUseCase(authRepository),
    signOut: createSignOutUseCase(authRepository),
    signInWithOAuth: createSignInWithOAuthUseCase(authRepository),
    getCurrentUser: createGetCurrentUserUseCase(authRepository),
    getUserProfile: createGetUserProfileUseCase(authRepository),
    updateUserProfile: createUpdateUserProfileUseCase(authRepository),
    requestPasswordReset: createRequestPasswordResetUseCase(authRepository),
    updatePassword: createUpdatePasswordUseCase(authRepository),
    // Projects use cases
    createProject: createCreateProjectUseCase(projectsRepository),
    getProjects: createGetProjectsUseCase(projectsRepository),
    getVisibleProjects: createGetVisibleProjectsUseCase(projectsRepository),
    getProject: createGetProjectUseCase(
      projectsRepository,
      authorizationService
    ),
    getProjectWithDependencies: createGetProjectWithDependenciesUseCase(
      projectsRepository,
      authorizationService
    ),
    updateProject: createUpdateProjectUseCase(
      projectsRepository,
      authorizationService
    ),
    deleteProject: createDeleteProjectUseCase(
      projectsRepository,
      authorizationService
    ),
    forkProject: createForkProjectUseCase(projectsRepository),
    saveThumbnail: createSaveThumbnailUseCase(
      projectsRepository,
      authorizationService,
      thumbnailStorage
    ),
    createFile: createCreateFileUseCase(
      projectsRepository,
      authorizationService
    ),
    updateFile: createUpdateFileUseCase(
      projectsRepository,
      authorizationService
    ),
    deleteFile: createDeleteFileUseCase(
      projectsRepository,
      authorizationService
    ),
    addTag: createAddTagUseCase(projectsRepository, authorizationService),
    removeTag: createRemoveTagUseCase(projectsRepository, authorizationService),
    addDependency: createAddDependencyUseCase(
      projectsRepository,
      authorizationService
    ),
    removeDependency: createRemoveDependencyUseCase(
      projectsRepository,
      authorizationService
    ),
    addUserShare: createAddUserShareUseCase(
      projectsRepository,
      authorizationService
    ),
    removeUserShare: createRemoveUserShareUseCase(
      projectsRepository,
      authorizationService
    ),
    searchUsers: createSearchUsersUseCase(projectsRepository),
    // Shared code use cases
    getSharedCode: createGetSharedCodeUseCase(sharedCodeRepository)
  }
}

/**
 * Singleton container instance for the application
 */
export const container = createContainer()
