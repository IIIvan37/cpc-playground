/**
 * React hooks for projects use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useState } from 'react'
import { container } from '@/infrastructure/container'
import type {
  CreateProjectInput,
  UpdateProjectInput
} from '@/use-cases/projects'

/**
 * Hook to create a new project
 */
export function useCreateProject() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const create = async (input: CreateProjectInput) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.createProject.execute(input)
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { create, loading, error }
}

/**
 * Hook to update an existing project
 */
export function useUpdateProject() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const update = async (input: UpdateProjectInput) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.updateProject.execute(input)
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { update, loading, error }
}

/**
 * Hook to delete a project
 */
export function useDeleteProject() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const deleteProject = async (projectId: string, userId: string) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.deleteProject.execute({
        projectId,
        userId
      })
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { deleteProject, loading, error }
}

/**
 * Hook to fetch all projects for a user
 */
export function useGetProjects() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const getProjects = async (userId: string) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.getProjects.execute({ userId })
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { getProjects, loading, error }
}

/**
 * Hook to fetch a single project by ID
 */
export function useGetProject() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const getProject = async (projectId: string, userId: string) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.getProject.execute({ projectId, userId })
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { getProject, loading, error }
}
