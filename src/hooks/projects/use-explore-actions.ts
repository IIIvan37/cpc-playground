/**
 * Hooks for Explore page actions
 */

import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { MINIMAL_ASM_TEMPLATE } from '@/lib/constants'
import { createLogger } from '@/lib/logger'
import { useToastActions } from '../core/use-toast'
import { useCreateProject, useForkProject } from './use-projects'

const logger = createLogger('ExploreActions')

type OperationResult = {
  success: boolean
  error?: string
}

/**
 * Hook to handle creating a new project from the Explore page
 */
export function useHandleCreateProject() {
  const navigate = useNavigate()
  const { create: createProject } = useCreateProject()
  const [loading, setLoading] = useState(false)

  const handleCreate = useCallback(
    async (params: {
      userId: string
      name: string
      isLibrary: boolean
    }): Promise<OperationResult> => {
      setLoading(true)
      try {
        const initialFile = {
          name: params.isLibrary ? 'lib.asm' : 'main.asm',
          content: params.isLibrary ? '' : MINIMAL_ASM_TEMPLATE,
          isMain: !params.isLibrary
        }

        const result = await createProject({
          userId: params.userId,
          name: params.name.trim(),
          visibility: 'private',
          isLibrary: params.isLibrary,
          files: [initialFile]
        })

        if (result?.project) {
          navigate(`/?project=${result.project.id}`)
          return { success: true }
        }

        return { success: false, error: 'Failed to create project' }
      } catch (error) {
        logger.error('Failed to create project:', error)
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Failed to create project'
        }
      } finally {
        setLoading(false)
      }
    },
    [createProject, navigate]
  )

  return { handleCreate, loading }
}

/**
 * Hook to handle forking a project from the Explore page
 */
export function useHandleForkProject() {
  const navigate = useNavigate()
  const toast = useToastActions()
  const { forkProject, loading } = useForkProject()

  const handleFork = useCallback(
    async (params: {
      projectId: string
      userId: string
    }): Promise<OperationResult> => {
      if (loading) return { success: false, error: 'Already forking' }

      try {
        const result = await forkProject(params)
        if (result?.project) {
          toast.success('Project forked successfully!')
          navigate(`/?project=${result.project.id}`)
          return { success: true }
        }

        return { success: false, error: 'Failed to fork project' }
      } catch (error) {
        logger.error('Failed to fork project:', error)
        const errorMessage =
          error instanceof Error ? error.message : 'Failed to fork project'
        toast.error(errorMessage)
        return {
          success: false,
          error: errorMessage
        }
      }
    },
    [forkProject, loading, navigate, toast]
  )

  return { handleFork, loading }
}
