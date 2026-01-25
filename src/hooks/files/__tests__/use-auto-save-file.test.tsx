import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, renderHook } from '@testing-library/react'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
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
import { currentFileIdAtom, projectsAtom } from '@/store/projects'
import { useAutoSaveFile } from '../use-auto-save-file'

// Mock updateFile
const mockUpdateFile = vi.fn()

vi.mock('../use-files', () => ({
  useUpdateFile: () => ({
    updateFile: mockUpdateFile,
    loading: false
  })
}))

// Mock useAuth
const mockUser = { id: 'user-1', email: 'test@example.com' }
vi.mock('@/hooks/auth/use-auth', () => ({
  useAuth: () => ({
    user: mockUser,
    loading: false
  })
}))

// Mock useCurrentFile and useCurrentProject
let mockCurrentFile: ProjectFile | null = null
let mockCurrentProject: Project | null = null

vi.mock('@/hooks/projects/use-current-project', () => ({
  useCurrentFile: () => mockCurrentFile,
  useCurrentProject: () => ({ project: mockCurrentProject })
}))

const DEBOUNCE_MS = 300

const mockMainFile: ProjectFile = createProjectFile({
  id: 'main-file',
  projectId: 'project-1',
  name: createFileName('main.asm'),
  content: createFileContent('; Main file content'),
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

describe('useAutoSaveFile', () => {
  let store: ReturnType<typeof createStore>
  let queryClient: QueryClient

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      <Provider store={store}>{children}</Provider>
    </QueryClientProvider>
  )

  beforeEach(() => {
    vi.clearAllMocks()
    vi.useFakeTimers()
    store = createStore()
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false }
      }
    })
    store.set(projectsAtom, [mockProject])
    store.set(currentFileIdAtom, mockMainFile.id)
    store.set(codeAtom, mockMainFile.content.value)
    // Setup mocks
    mockCurrentFile = mockMainFile
    mockCurrentProject = mockProject
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  it('should save file after debounce when code changes', async () => {
    renderHook(() => useAutoSaveFile(), { wrapper })

    // Change the code
    act(() => {
      store.set(codeAtom, '; Modified code')
    })

    // Should not save immediately
    expect(mockUpdateFile).not.toHaveBeenCalled()

    // Advance timers past debounce
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    expect(mockUpdateFile).toHaveBeenCalledWith({
      projectId: 'project-1',
      userId: 'user-1',
      fileId: 'main-file',
      content: '; Modified code'
    })
  })

  it('should NOT save when code is empty but file has content', async () => {
    renderHook(() => useAutoSaveFile(), { wrapper })

    // Set code to empty string (simulating race condition during navigation)
    act(() => {
      store.set(codeAtom, '')
    })

    // Advance timers past debounce
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    // Should NOT have called updateFile - this is the critical protection
    expect(mockUpdateFile).not.toHaveBeenCalled()
  })

  it('should NOT save when code equals file content', async () => {
    renderHook(() => useAutoSaveFile(), { wrapper })

    // Code is already set to file content in beforeEach
    // Advance timers
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    expect(mockUpdateFile).not.toHaveBeenCalled()
  })

  it('should NOT save when currentFileId does not match file id', async () => {
    // Set a different file ID
    store.set(currentFileIdAtom, 'different-file-id')

    renderHook(() => useAutoSaveFile(), { wrapper })

    // Change the code
    act(() => {
      store.set(codeAtom, '; Modified code')
    })

    // Advance timers
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    expect(mockUpdateFile).not.toHaveBeenCalled()
  })

  it('should cancel pending save when file changes', async () => {
    renderHook(() => useAutoSaveFile(), { wrapper })

    // Change the code
    act(() => {
      store.set(codeAtom, '; Modified code')
    })

    // Before debounce completes, change the file ID
    await act(async () => {
      vi.advanceTimersByTime(100) // Only partial debounce
    })

    act(() => {
      store.set(currentFileIdAtom, 'another-file-id')
    })

    // Complete the debounce
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS)
    })

    // Should NOT have saved because file changed
    expect(mockUpdateFile).not.toHaveBeenCalled()
  })

  it('should allow saving empty content if file was already empty', async () => {
    // Create a file with empty content
    const emptyFile: ProjectFile = createProjectFile({
      id: 'empty-file',
      projectId: 'project-1',
      name: createFileName('empty.asm'),
      content: createFileContent(''),
      isMain: false
    })

    const projectWithEmptyFile: Project = createProject({
      id: 'project-1',
      name: createProjectName('Test Project'),
      userId: 'user-1',
      files: [emptyFile],
      visibility: Visibility.PRIVATE,
      isLibrary: false
    })

    // Update mocks for this test
    mockCurrentFile = emptyFile
    mockCurrentProject = projectWithEmptyFile

    store.set(projectsAtom, [projectWithEmptyFile])
    store.set(currentFileIdAtom, emptyFile.id)
    store.set(codeAtom, '')

    renderHook(() => useAutoSaveFile(), { wrapper })

    // Change code to something
    act(() => {
      store.set(codeAtom, '; some content')
    })

    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    // This should save because we changed from empty to content
    expect(mockUpdateFile).toHaveBeenCalledWith({
      projectId: 'project-1',
      userId: 'user-1',
      fileId: 'empty-file',
      content: '; some content'
    })
  })

  it('should debounce rapid changes', async () => {
    renderHook(() => useAutoSaveFile(), { wrapper })

    // Make multiple rapid changes
    act(() => {
      store.set(codeAtom, '; Change 1')
    })

    await act(async () => {
      vi.advanceTimersByTime(100)
    })

    act(() => {
      store.set(codeAtom, '; Change 2')
    })

    await act(async () => {
      vi.advanceTimersByTime(100)
    })

    act(() => {
      store.set(codeAtom, '; Change 3')
    })

    // Should not have saved yet
    expect(mockUpdateFile).not.toHaveBeenCalled()

    // Now wait for full debounce
    await act(async () => {
      vi.advanceTimersByTime(DEBOUNCE_MS + 50)
    })

    // Should only save once with final value
    expect(mockUpdateFile).toHaveBeenCalledTimes(1)
    expect(mockUpdateFile).toHaveBeenCalledWith({
      projectId: 'project-1',
      userId: 'user-1',
      fileId: 'main-file',
      content: '; Change 3'
    })
  })
})
