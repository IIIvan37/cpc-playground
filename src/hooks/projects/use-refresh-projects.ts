/**
 * Hook to refresh projects in global state
 * Bridges Clean Architecture use-cases with Jotai global state
 */

import { useSetAtom } from 'jotai'
import { useCallback } from 'react'
import { projectsAtom } from '@/store/projects'
import { useGetProjects } from './use-projects'

/**
 * Hook to refresh the global projects state
 * Uses the Clean Architecture useGetProjects hook and updates the Jotai atom
 */
export function useRefreshProjects() {
  const { getProjects } = useGetProjects()
  const setProjects = useSetAtom(projectsAtom)

  const refreshProjects = useCallback(
    async (userId: string) => {
      const result = await getProjects(userId)
      if (result?.projects) {
        setProjects([...result.projects])
      }
    },
    [getProjects, setProjects]
  )

  return { refreshProjects }
}
