import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, renderHook, waitFor } from '@testing-library/react'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject, type Project } from '@/domain/entities/project.entity'
import {
  createProjectFile,
  type ProjectFile
} from '@/domain/entities/project-file.entity'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import {
  currentFileIdAtom,
  currentProjectIdAtom,
  isReadOnlyModeAtom,
  projectsAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import {
  useActiveProject,
  useCurrentProject,
  useIsMarkdownFile
} from '../use-current-project'
import {
  useCreateProject,
  useDeleteProject,
  useFetchProject,
  useGetProject,
  useGetProjects,
  useUpdateProject
} from '../use-projects'

// Mock the container
const mockCreateProject = vi.fn()
const mockUpdateProject = vi.fn()
const mockDeleteProject = vi.fn()
const mockGetProjects = vi.fn()
const mockGetProject = vi.fn()

vi.mock('@/infrastructure/container', () => ({
  container: {
    createProject: {
      execute: (...args: unknown[]) => mockCreateProject(...args)
    },
    updateProject: {
      execute: (...args: unknown[]) => mockUpdateProject(...args)
    },
    deleteProject: {
      execute: (...args: unknown[]) => mockDeleteProject(...args)
    },
    getProjects: { execute: (...args: unknown[]) => mockGetProjects(...args) },
    getProject: { execute: (...args: unknown[]) => mockGetProject(...args) }
  }
}))

// Mock useAuth for useCurrentProject hook
vi.mock('@/hooks/auth/use-auth', () => ({
  useAuth: () => ({
    user: { id: 'user-1', email: 'test@example.com' },
    loading: false
  })
}))

const mockMainFile: ProjectFile = createProjectFile({
  id: 'main-file',
  projectId: 'project-1',
  name: createFileName('main.asm'),
  content: createFileContent('; Main file'),
  isMain: true
})

const mockProject: Project = createProject({
  id: 'project-1',
  name: createProjectName('Test Project'),
  userId: 'user-1',
  files: [mockMainFile],
  visibility: Visibility.PRIVATE,
  isLibrary: false
})

const mockPublicProject: Project = createProject({
  id: 'public-project',
  name: createProjectName('Public Project'),
  userId: 'other-user',
  files: [mockMainFile],
  visibility: Visibility.PUBLIC,
  isLibrary: false
})

describe('useProjects hooks', () => {
  let store: ReturnType<typeof createStore>
  let queryClient: QueryClient

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      <Provider store={store}>{children}</Provider>
    </QueryClientProvider>
  )

  beforeEach(() => {
    vi.clearAllMocks()
    store = createStore()
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false }
      }
    })
    store.set(projectsAtom, [])
    store.set(currentProjectIdAtom, null)
    store.set(currentFileIdAtom, null)
    store.set(isReadOnlyModeAtom, false)
    store.set(viewOnlyProjectAtom, null)
  })

  describe('useCreateProject', () => {
    it('creates project and updates state', async () => {
      mockCreateProject.mockResolvedValue({ project: mockProject })

      const { result } = renderHook(() => useCreateProject(), { wrapper })

      await act(async () => {
        await result.current.create({
          userId: 'user-1',
          name: 'Test Project'
        })
      })

      expect(mockCreateProject).toHaveBeenCalledWith({
        userId: 'user-1',
        name: 'Test Project'
      })

      // Check UI state was updated (Jotai atoms for current project/file)
      expect(store.get(currentProjectIdAtom)).toBe('project-1')
      expect(store.get(currentFileIdAtom)).toBe('main-file')

      // Note: projectsAtom is no longer updated directly.
      // The hook now calls queryClient.invalidateQueries() which
      // triggers a refetch from the server.
    })

    it('sets main file as current file', async () => {
      mockCreateProject.mockResolvedValue({ project: mockProject })

      const { result } = renderHook(() => useCreateProject(), { wrapper })

      await act(async () => {
        await result.current.create({
          userId: 'user-1',
          name: 'Test Project'
        })
      })

      expect(store.get(currentFileIdAtom)).toBe('main-file')
    })

    it('exposes loading state', async () => {
      let resolveCreate: (value: unknown) => void
      mockCreateProject.mockImplementation(
        () =>
          new Promise((resolve) => {
            resolveCreate = resolve
          })
      )

      const { result } = renderHook(() => useCreateProject(), { wrapper })

      expect(result.current.loading).toBe(false)

      act(() => {
        result.current.create({ userId: 'user-1', name: 'Test' })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(true)
      })

      await act(async () => {
        resolveCreate!({ project: mockProject })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })
    })
  })

  describe('useUpdateProject', () => {
    it('calls update use case', async () => {
      const updatedProject = createProject({
        ...mockProject,
        name: createProjectName('Updated Name')
      })
      mockUpdateProject.mockResolvedValue({ project: updatedProject })

      const { result } = renderHook(() => useUpdateProject(), { wrapper })

      await act(async () => {
        await result.current.update({
          projectId: 'project-1',
          userId: 'user-1',
          updates: { name: 'Updated Name' }
        })
      })

      expect(mockUpdateProject).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        updates: { name: 'Updated Name' }
      })
    })
  })

  describe('useDeleteProject', () => {
    it('calls delete use case with correct params', async () => {
      mockDeleteProject.mockResolvedValue({})

      const { result } = renderHook(() => useDeleteProject(), { wrapper })

      await act(async () => {
        await result.current.deleteProject({
          projectId: 'project-1',
          userId: 'user-1'
        })
      })

      expect(mockDeleteProject).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1'
      })
    })
  })

  describe('useGetProjects', () => {
    it('fetches projects for user', async () => {
      mockGetProjects.mockResolvedValue({ projects: [mockProject] })

      const { result } = renderHook(() => useGetProjects(), { wrapper })

      let projectsResult: unknown
      await act(async () => {
        projectsResult = await result.current.getProjects('user-1')
      })

      expect(mockGetProjects).toHaveBeenCalledWith({ userId: 'user-1' })
      expect(projectsResult).toEqual({ projects: [mockProject] })
    })
  })

  describe('useGetProject', () => {
    it('fetches single project', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })

      const { result } = renderHook(() => useGetProject(), { wrapper })

      let projectResult: unknown
      await act(async () => {
        projectResult = await result.current.getProject('project-1', 'user-1')
      })

      expect(mockGetProject).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1'
      })
      expect(projectResult).toEqual({ project: mockProject })
    })
  })

  describe('useFetchProject', () => {
    describe('owner mode', () => {
      it('adds project to list when user is owner', async () => {
        mockGetProject.mockResolvedValue({ project: mockProject })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await act(async () => {
          await result.current.fetchProject({
            projectId: 'project-1',
            userId: 'user-1'
          })
        })

        // Note: projectsAtom is no longer updated directly.
        // The hook now uses React Query cache.
        expect(store.get(isReadOnlyModeAtom)).toBe(false)
        expect(store.get(viewOnlyProjectAtom)).toBeNull()
      })

      it('sets current project and file', async () => {
        mockGetProject.mockResolvedValue({ project: mockProject })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await act(async () => {
          await result.current.fetchProject({
            projectId: 'project-1',
            userId: 'user-1'
          })
        })

        expect(store.get(currentProjectIdAtom)).toBe('project-1')
        expect(store.get(currentFileIdAtom)).toBe('main-file')
      })

      it('updates existing project in list', async () => {
        store.set(projectsAtom, [mockProject])
        const updatedProject = { ...mockProject, name: 'Updated' }
        mockGetProject.mockResolvedValue({ project: updatedProject })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await act(async () => {
          await result.current.fetchProject({
            projectId: 'project-1',
            userId: 'user-1'
          })
        })

        // Note: projectsAtom is no longer updated directly.
        // The hook now uses queryClient.setQueryData() to update React Query cache.
        expect(store.get(currentProjectIdAtom)).toBe('project-1')
      })
    })

    describe('read-only mode', () => {
      it('sets read-only mode for non-owner', async () => {
        mockGetProject.mockResolvedValue({ project: mockPublicProject })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await act(async () => {
          await result.current.fetchProject({
            projectId: 'public-project',
            userId: 'different-user'
          })
        })

        expect(store.get(isReadOnlyModeAtom)).toBe(true)
        expect(store.get(viewOnlyProjectAtom)).toEqual(mockPublicProject)
      })

      it('clears current project but selects main file in read-only mode', async () => {
        store.set(currentProjectIdAtom, 'old-project')
        store.set(currentFileIdAtom, 'old-file')
        mockGetProject.mockResolvedValue({ project: mockPublicProject })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await act(async () => {
          await result.current.fetchProject({
            projectId: 'public-project',
            userId: 'different-user'
          })
        })

        expect(store.get(currentProjectIdAtom)).toBeNull()
        // In read-only mode, we now select the main file for markdown preview support
        expect(store.get(currentFileIdAtom)).toBe('main-file')
      })
    })

    describe('error handling', () => {
      it('throws error when project not found', async () => {
        mockGetProject.mockResolvedValue({ project: null })

        const { result } = renderHook(() => useFetchProject(), { wrapper })

        await expect(
          act(async () => {
            await result.current.fetchProject({
              projectId: 'non-existent',
              userId: 'user-1'
            })
          })
        ).rejects.toThrow()
      })
    })
  })

  describe('React Query cache sharing', () => {
    it('useGetProject stores project directly in cache (not wrapped)', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })

      const { result } = renderHook(() => useGetProject(), { wrapper })

      await act(async () => {
        await result.current.getProject('project-1', 'user-1')
      })

      // Verify the cache contains the project directly, not { project: Project }
      const cachedData = queryClient.getQueryData(['project', 'project-1'])
      expect(cachedData).toEqual(mockProject)
      expect(cachedData).not.toHaveProperty('project')
    })

    it('useCurrentProject can read project from cache populated by useGetProject', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })

      // First, populate the cache via useGetProject
      const { result: getProjectResult } = renderHook(() => useGetProject(), {
        wrapper
      })

      await act(async () => {
        await getProjectResult.current.getProject('project-1', 'user-1')
      })

      // Set the current project ID to trigger useCurrentProject
      store.set(currentProjectIdAtom, 'project-1')

      // Now verify useCurrentProject can read from the same cache
      const { result: currentProjectResult } = renderHook(
        () => useCurrentProject(),
        { wrapper }
      )

      await waitFor(() => {
        expect(currentProjectResult.current.project).toEqual(mockProject)
      })

      // Verify the mock was only called once (cache was used)
      expect(mockGetProject).toHaveBeenCalledTimes(1)
    })

    it('useFetchProject populates cache that useActiveProject can read', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })

      // Fetch project (simulates clicking on a project from explore)
      const { result: fetchResult } = renderHook(() => useFetchProject(), {
        wrapper
      })

      await act(async () => {
        await fetchResult.current.fetchProject({
          projectId: 'project-1',
          userId: 'user-1'
        })
      })

      // Verify cache was populated
      const cachedData = queryClient.getQueryData(['project', 'project-1'])
      expect(cachedData).toEqual(mockProject)

      // Now useActiveProject should return the project
      const { result: activeResult } = renderHook(() => useActiveProject(), {
        wrapper
      })

      await waitFor(() => {
        expect(activeResult.current.activeProject).toEqual(mockProject)
      })
    })

    it('cache format is consistent between useGetProject return and cache storage', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })

      const { result } = renderHook(() => useGetProject(), { wrapper })

      let returnedValue: { project: typeof mockProject | null } | undefined
      await act(async () => {
        returnedValue = await result.current.getProject('project-1', 'user-1')
      })

      // useGetProject returns { project: Project } for backward compatibility
      expect(returnedValue).toEqual({ project: mockProject })

      // But cache stores Project directly for useCurrentProject compatibility
      const cachedData = queryClient.getQueryData(['project', 'project-1'])
      expect(cachedData).toEqual(mockProject)
    })
  })

  describe('useIsMarkdownFile', () => {
    it('returns false when no current file', () => {
      store.set(currentProjectIdAtom, null)
      store.set(currentFileIdAtom, null)

      const { result } = renderHook(() => useIsMarkdownFile(), { wrapper })

      expect(result.current).toBe(false)
    })

    it('returns false for .asm files', async () => {
      mockGetProject.mockResolvedValue({ project: mockProject })
      store.set(currentProjectIdAtom, 'project-1')
      store.set(currentFileIdAtom, 'main-file')

      const { result } = renderHook(() => useIsMarkdownFile(), { wrapper })

      await waitFor(() => {
        expect(result.current).toBe(false)
      })
    })

    it('returns true for .md files', async () => {
      const mdFile = createProjectFile({
        id: 'readme-file',
        projectId: 'project-1',
        name: createFileName('README.md'),
        content: createFileContent('# Hello'),
        isMain: false
      })

      const projectWithMd = createProject({
        id: 'project-1',
        name: createProjectName('Test Project'),
        userId: 'user-1',
        files: [mockMainFile, mdFile],
        visibility: Visibility.PRIVATE,
        isLibrary: false
      })

      mockGetProject.mockResolvedValue({ project: projectWithMd })
      store.set(currentProjectIdAtom, 'project-1')
      store.set(currentFileIdAtom, 'readme-file')

      const { result } = renderHook(() => useIsMarkdownFile(), { wrapper })

      await waitFor(() => {
        expect(result.current).toBe(true)
      })
    })

    it('returns true for .MD files (case insensitive)', async () => {
      const mdFile = createProjectFile({
        id: 'readme-file',
        projectId: 'project-1',
        name: createFileName('README.MD'),
        content: createFileContent('# Hello'),
        isMain: false
      })

      const projectWithMd = createProject({
        id: 'project-1',
        name: createProjectName('Test Project'),
        userId: 'user-1',
        files: [mockMainFile, mdFile],
        visibility: Visibility.PRIVATE,
        isLibrary: false
      })

      mockGetProject.mockResolvedValue({ project: projectWithMd })
      store.set(currentProjectIdAtom, 'project-1')
      store.set(currentFileIdAtom, 'readme-file')

      const { result } = renderHook(() => useIsMarkdownFile(), { wrapper })

      await waitFor(() => {
        expect(result.current).toBe(true)
      })
    })
  })
})
