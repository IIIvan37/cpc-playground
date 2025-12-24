/**
 * Hooks barrel export
 * Re-exports all hooks from their respective modules
 */

// Authentication
export { useAuth, userAtom } from './auth'
// Core utilities
export { useUseCase, useUseCaseWithoutInput } from './core'
export { useToast, useToastActions } from './core/use-toast'

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
  projectKeys,
  projectsKeys,
  useActiveProject,
  // Dependencies
  useAddDependency,
  // Tags
  useAddTag,
  // Shares
  useAddUserShare,
  useAvailableDependencies,
  useAvailableLibraries,
  // CRUD
  useCreateProject,
  useCurrentFile,
  useCurrentProject,
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
  // File state
  useIsMarkdownFile,
  useMainFile,
  useProjectFiles,
  useProjectFromCache,
  useProjectFromUrl,
  useRemoveDependency,
  useRemoveTag,
  useRemoveUserShare,
  useUpdateProject,
  // New React Query hooks (single source of truth)
  useUserProjects
} from './projects'

// Shared/Misc
export {
  type UserSearchResult,
  useSearchUsers,
  useSharedCode,
  useUserProfile
} from './shared'
