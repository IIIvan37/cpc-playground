/**
 * Project management hooks
 */

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

// Utilities
export { useRefreshProjects } from './use-refresh-projects'
// Shares
export { useAddUserShare, useRemoveUserShare } from './use-shares'
// Tags
export { useAddTag, useRemoveTag } from './use-tags'
