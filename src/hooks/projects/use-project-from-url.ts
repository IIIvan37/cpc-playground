import { useSetAtom } from 'jotai'
import { useEffect, useRef } from 'react'
import { useSearchParams } from 'react-router-dom'
import { codeAtom } from '@/store'
import { isReadOnlyModeAtom, viewOnlyProjectAtom } from '@/store/projects'
import { useAuth } from '../auth'
import { useFetchProject } from './use-projects'

/**
 * Module-level ref to track loaded project+user combo
 * Must be at module level to survive React StrictMode double-mounting
 */
let loadedProjectState: {
  projectId: string
  userId: string | undefined
} | null = null

/**
 * Hook to load a project from URL query parameter
 * Handles both authenticated users (own projects) and anonymous users (public projects)
 */
export function useProjectFromUrl() {
  const { user, loading: authLoading } = useAuth()
  const { fetchProject } = useFetchProject()
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)
  const setCode = useSetAtom(codeAtom)
  const [searchParams] = useSearchParams()

  // Get project ID from URL search params (reactive)
  const projectId = searchParams.get('project')

  // Store fetchProject in a ref to avoid it triggering effect re-runs
  const fetchProjectRef = useRef(fetchProject)
  fetchProjectRef.current = fetchProject

  useEffect(() => {
    // Wait for auth to be ready
    if (authLoading) return

    if (!projectId) {
      // No project in URL - clear read-only state
      setViewOnlyProject(null)
      setIsReadOnlyMode(false)
      loadedProjectState = null
      return
    }

    // Skip if we've already loaded this exact project+user combo
    if (
      loadedProjectState?.projectId === projectId &&
      loadedProjectState?.userId === user?.id
    ) {
      return
    }
    loadedProjectState = { projectId, userId: user?.id }

    fetchProjectRef
      .current({
        projectId,
        userId: user?.id
      })
      .then((project) => {
        // Load the main file content into the editor
        if (project) {
          const mainFile = project.files.find((f) => f.isMain)
          if (mainFile) {
            setCode(mainFile.content.value)
          } else if (project.files.length > 0) {
            setCode(project.files[0].content.value)
          }
        }
      })
      .catch((err) => {
        console.error('Failed to load project from URL:', err)
        // Reset on error so we can retry
        loadedProjectState = null
      })
    // eslint-disable-next-line react-hooks/exhaustive-deps -- fetchProject is accessed via ref to avoid triggering effect
  }, [
    authLoading,
    user?.id,
    projectId,
    setCode,
    setViewOnlyProject,
    setIsReadOnlyMode
  ])
}
