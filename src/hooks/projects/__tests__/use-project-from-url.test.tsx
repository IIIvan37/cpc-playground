import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, renderHook, waitFor } from '@testing-library/react'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { MemoryRouter } from 'react-router-dom'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject, type Project } from '@/domain/entities/project.entity'
import {
  createProjectFile,
  type ProjectFile
} from '@/domain/entities/project-file.entity'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { codeAtom } from '@/store/editor'
import { isReadOnlyModeAtom, viewOnlyProjectAtom } from '@/store/projects'
import {
  _resetLoadedProjectStateForTesting,
  useProjectFromUrl
} from '../use-project-from-url'

// Mock fetchProject
const mockFetchProject = vi.fn()

vi.mock('../use-projects', () => ({
  useFetchProject: () => ({
    fetchProject: mockFetchProject
  })
}))

// Mock useAuth
let mockUser: { id: string; email: string } | null = {
  id: 'user-1',
  email: 'test@example.com'
}
let mockAuthLoading = false

vi.mock('@/hooks/auth/use-auth', () => ({
  useAuth: () => ({
    user: mockUser,
    loading: mockAuthLoading
  })
}))

const mockMainFile: ProjectFile = createProjectFile({
  id: 'main-file',
  projectId: 'project-1',
  name: createFileName('main.asm'),
  content: createFileContent('; Main file content'),
  isMain: true
})

const mockSecondFile: ProjectFile = createProjectFile({
  id: 'second-file',
  projectId: 'project-1',
  name: createFileName('second.asm'),
  content: createFileContent('; Second file content'),
  isMain: false
})

const mockProject: Project = createProject({
  id: 'project-1',
  name: createProjectName('Test Project'),
  userId: 'user-1',
  files: [mockMainFile, mockSecondFile],
  visibility: Visibility.PRIVATE,
  isLibrary: false
})

describe('useProjectFromUrl', () => {
  let store: ReturnType<typeof createStore>
  let queryClient: QueryClient

  const createWrapper =
    (initialEntry: string) =>
    ({ children }: { children: ReactNode }) => (
      <MemoryRouter initialEntries={[initialEntry]}>
        <QueryClientProvider client={queryClient}>
          <Provider store={store}>{children}</Provider>
        </QueryClientProvider>
      </MemoryRouter>
    )

  beforeEach(() => {
    vi.clearAllMocks()
    // Reset module-level state
    _resetLoadedProjectStateForTesting()
    store = createStore()
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false }
      }
    })
    mockUser = { id: 'user-1', email: 'test@example.com' }
    mockAuthLoading = false
    // Set initial code to simulate existing content
    store.set(codeAtom, '; Initial code in editor')
  })

  afterEach(() => {
    vi.clearAllMocks()
  })

  it('should fetch project when projectId is in URL', async () => {
    mockFetchProject.mockResolvedValue(mockProject)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    await waitFor(() => {
      expect(mockFetchProject).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1'
      })
    })
  })

  it('should set code to main file content after loading', async () => {
    mockFetchProject.mockResolvedValue(mockProject)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    await waitFor(() => {
      expect(store.get(codeAtom)).toBe('; Main file content')
    })
  })

  it('should NOT clear code before loading project', async () => {
    // This is the critical test - we must NOT set code to empty string
    // during the loading process, as this would trigger auto-save
    let codeWasCleared = false

    // Watch for code changes
    store.sub(codeAtom, () => {
      const currentCode = store.get(codeAtom)
      if (currentCode === '') {
        codeWasCleared = true
      }
    })

    // Delay the fetch to ensure we can check intermediate states
    mockFetchProject.mockImplementation(
      () =>
        new Promise((resolve) => {
          setTimeout(() => resolve(mockProject), 100)
        })
    )

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    // Wait a bit to ensure the hook has started
    await act(async () => {
      await new Promise((resolve) => setTimeout(resolve, 50))
    })

    // Code should NOT have been cleared during loading
    expect(codeWasCleared).toBe(false)

    // Wait for fetch to complete
    await waitFor(() => {
      expect(store.get(codeAtom)).toBe('; Main file content')
    })
  })

  it('should use first file if no main file exists', async () => {
    const projectNoMain: Project = createProject({
      id: 'project-2',
      name: createProjectName('No Main Project'),
      userId: 'user-1',
      files: [
        createProjectFile({
          id: 'file-1',
          projectId: 'project-2',
          name: createFileName('first.asm'),
          content: createFileContent('; First file'),
          isMain: false
        })
      ],
      visibility: Visibility.PRIVATE,
      isLibrary: false
    })

    mockFetchProject.mockResolvedValue(projectNoMain)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-2')
    })

    await waitFor(() => {
      expect(store.get(codeAtom)).toBe('; First file')
    })
  })

  it('should clear read-only state when no project in URL', async () => {
    // First set read-only state
    store.set(isReadOnlyModeAtom, true)
    store.set(viewOnlyProjectAtom, mockProject)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/')
    })

    await waitFor(() => {
      expect(store.get(isReadOnlyModeAtom)).toBe(false)
      expect(store.get(viewOnlyProjectAtom)).toBe(null)
    })
  })

  it('should not fetch while auth is loading', async () => {
    mockAuthLoading = true
    mockFetchProject.mockResolvedValue(mockProject)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    // Wait a bit
    await act(async () => {
      await new Promise((resolve) => setTimeout(resolve, 100))
    })

    // Should not have fetched
    expect(mockFetchProject).not.toHaveBeenCalled()
  })

  it('should handle fetch error gracefully', async () => {
    const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
    mockFetchProject.mockRejectedValue(new Error('Network error'))

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    await waitFor(() => {
      expect(mockFetchProject).toHaveBeenCalled()
    })

    // Code should remain unchanged on error
    expect(store.get(codeAtom)).toBe('; Initial code in editor')

    consoleSpy.mockRestore()
  })

  it('should fetch for anonymous users', async () => {
    mockUser = null
    mockFetchProject.mockResolvedValue(mockProject)

    renderHook(() => useProjectFromUrl(), {
      wrapper: createWrapper('/?project=project-1')
    })

    await waitFor(() => {
      expect(mockFetchProject).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: undefined
      })
    })
  })
})
