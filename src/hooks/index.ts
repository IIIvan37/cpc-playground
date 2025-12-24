/**
 * Hooks barrel export
 * Re-exports all hooks from their respective modules
 */

// Authentication
export { useAuth, userAtom } from './auth'
// Core utilities
export { useUseCase, useUseCaseWithoutInput } from './core'

// Emulator & Assembler
export { useAssembler, useEmulator } from './emulator'

// File management
export {
  useAutoSaveFile,
  useCreateFile,
  useDeleteFile,
  useSetMainFile,
  useUpdateFile
} from './files'

// Project management
export {
  // Dependencies
  useAddDependency,
  // Tags
  useAddTag,
  // Shares
  useAddUserShare,
  // CRUD
  useCreateProject,
  useDeleteProject,
  useFetchDependencyFiles,
  useFetchProject,
  // Utilities
  useFetchVisibleProjects,
  useGetProject,
  useGetProjects,
  useGetProjectWithDependencies,
  // Settings handlers
  useHandleAddDependency,
  useHandleAddShare,
  useHandleAddTag,
  useHandleDeleteProject,
  useHandleRemoveDependency,
  useHandleRemoveShare,
  useHandleRemoveTag,
  useHandleSaveProject,
  useProjectFromUrl,
  useRefreshProjects,
  useRemoveDependency,
  useRemoveTag,
  useRemoveUserShare,
  useUpdateProject
} from './projects'

// Shared/Misc
export { useSharedCode, useUserProfile } from './shared'
