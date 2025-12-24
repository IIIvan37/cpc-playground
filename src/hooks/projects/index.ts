/**
 * Project management hooks
 */

export {
  projectKeys,
  useActiveProject,
  useCurrentFile,
  useCurrentProject,
  useIsMarkdownFile,
  useMainFile,
  useProjectFiles
} from './use-current-project'
// Dependencies
export {
  useAddDependency,
  useFetchDependencyFiles,
  useRemoveDependency
} from './use-dependencies'
export { useFetchVisibleProjects } from './use-fetch-visible-projects'
export { useProjectFromUrl } from './use-project-from-url'
// Project settings operations
export {
  useHandleAddDependency,
  useHandleAddShare,
  useHandleAddTag,
  useHandleDeleteProject,
  useHandleRemoveDependency,
  useHandleRemoveShare,
  useHandleRemoveTag,
  useHandleSaveProject
} from './use-project-settings'
// Core CRUD operations
export {
  useCreateProject,
  useDeleteProject,
  useFetchProject,
  useGetProject,
  useGetProjects,
  useGetProjectWithDependencies,
  useUpdateProject
} from './use-projects'
// Shares
export { useAddUserShare, useRemoveUserShare } from './use-shares'
// Tags
export { useAddTag, useRemoveTag } from './use-tags'
// New React Query based hooks (single source of truth)
export {
  projectsKeys,
  useAvailableDependencies,
  useAvailableLibraries,
  useProjectFromCache,
  useUserProjects
} from './use-user-projects'
