import { useEffect } from 'react'
import { container } from '@/infrastructure/container'
import { useUseCase } from './use-use-case'

export function useFetchVisibleProjects(userId?: string) {
  const { execute, loading, error, data } = useUseCase(
    container.getVisibleProjects
  )

  useEffect(() => {
    execute({ userId })
  }, [userId, execute])

  return {
    projects: data?.projects ?? [],
    loading,
    error: error?.message ?? null
  }
}
