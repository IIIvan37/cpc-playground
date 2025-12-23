import { useSetAtom } from 'jotai'
import { useEffect } from 'react'
import { codeAtom } from '@/store'
import {
  fetchProjectAtom,
  isReadOnlyModeAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { useAuth } from './use-auth'

/**
 * Hook to load a project from URL query parameter
 * Handles both authenticated users (own projects) and anonymous users (public projects)
 */
export function useProjectFromUrl() {
  const { user, loading: authLoading } = useAuth()
  const fetchProject = useSetAtom(fetchProjectAtom)
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)
  const setCode = useSetAtom(codeAtom)

  useEffect(() => {
    // Wait for auth to be ready
    if (authLoading) return

    const params = new URLSearchParams(globalThis.location.search)
    const projectId = params.get('project')

    if (!projectId) {
      // No project in URL - clear read-only state
      setViewOnlyProject(null)
      setIsReadOnlyMode(false)
      return
    }

    fetchProject({
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
      })
  }, [
    authLoading,
    user?.id,
    fetchProject,
    setCode,
    setViewOnlyProject,
    setIsReadOnlyMode
  ])
}
