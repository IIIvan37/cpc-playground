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
import { currentFileIdAtom, projectsAtom } from '@/store/projects'
import {
  useCreateFile,
  useDeleteFile,
  useSetMainFile,
  useUpdateFile
} from '../use-files'

// Mock the container
const mockCreateFile = vi.fn()
const mockUpdateFile = vi.fn()
const mockDeleteFile = vi.fn()

vi.mock('@/infrastructure/container', () => ({
  container: {
    createFile: { execute: (...args: unknown[]) => mockCreateFile(...args) },
    updateFile: { execute: (...args: unknown[]) => mockUpdateFile(...args) },
    deleteFile: { execute: (...args: unknown[]) => mockDeleteFile(...args) }
  }
}))

const mockFile: ProjectFile = createProjectFile({
  id: 'file-1',
  projectId: 'project-1',
  name: createFileName('test.asm'),
  content: createFileContent('; Test file'),
  isMain: false
})

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

describe('useFiles hooks', () => {
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
    store.set(projectsAtom, [mockProject])
    store.set(currentFileIdAtom, mockMainFile.id)
  })

  describe('useCreateFile', () => {
    it('creates file and updates projects state', async () => {
      const newFile = { ...mockFile, id: 'new-file-1' }
      mockCreateFile.mockResolvedValue({ file: newFile })

      const { result } = renderHook(() => useCreateFile(), { wrapper })

      await act(async () => {
        await result.current.createFile({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'test.asm',
          content: '; Test file'
        })
      })

      expect(mockCreateFile).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        name: 'test.asm',
        content: '; Test file'
      })

      // Note: projectsAtom is no longer updated directly.
      // The hook now calls queryClient.invalidateQueries() which
      // triggers a refetch from the server. Tests should verify
      // that the use case was called correctly.
    })

    it('sets current file when creating main file', async () => {
      const newMainFile = { ...mockFile, id: 'new-main', isMain: true }
      mockCreateFile.mockResolvedValue({ file: newMainFile })

      const { result } = renderHook(() => useCreateFile(), { wrapper })

      await act(async () => {
        await result.current.createFile({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'newmain.asm',
          content: '; Main',
          isMain: true
        })
      })

      expect(store.get(currentFileIdAtom)).toBe('new-main')
    })

    it('exposes loading state', async () => {
      let resolveCreate: (value: unknown) => void
      mockCreateFile.mockImplementation(
        () =>
          new Promise((resolve) => {
            resolveCreate = resolve
          })
      )

      const { result } = renderHook(() => useCreateFile(), { wrapper })

      expect(result.current.loading).toBe(false)

      act(() => {
        result.current.createFile({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'test.asm',
          content: ''
        })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(true)
      })

      await act(async () => {
        resolveCreate!({ file: mockFile })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })
    })
  })

  describe('useUpdateFile', () => {
    beforeEach(() => {
      store.set(projectsAtom, [
        { ...mockProject, files: [mockMainFile, mockFile] }
      ])
    })

    it('updates file and projects state', async () => {
      const updatedFile = { ...mockFile, content: '; Updated content' }
      mockUpdateFile.mockResolvedValue({ file: updatedFile })

      const { result } = renderHook(() => useUpdateFile(), { wrapper })

      await act(async () => {
        await result.current.updateFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1',
          content: '; Updated content'
        })
      })

      expect(mockUpdateFile).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        fileId: 'file-1',
        content: '; Updated content'
      })

      // Note: projectsAtom is no longer updated directly.
      // The hook now calls queryClient.invalidateQueries() which
      // triggers a refetch from the server.
    })

    it('updates isMain flag on all files when setting main', async () => {
      const newMainFile = { ...mockFile, isMain: true }
      mockUpdateFile.mockResolvedValue({ file: newMainFile })

      const { result } = renderHook(() => useUpdateFile(), { wrapper })

      await act(async () => {
        await result.current.updateFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1',
          isMain: true
        })
      })

      expect(mockUpdateFile).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        fileId: 'file-1',
        isMain: true
      })

      // Note: projectsAtom is no longer updated directly.
      // The hook now calls queryClient.invalidateQueries() which
      // triggers a refetch from the server.
    })
  })

  describe('useDeleteFile', () => {
    beforeEach(() => {
      store.set(projectsAtom, [
        { ...mockProject, files: [mockMainFile, mockFile] }
      ])
      store.set(currentFileIdAtom, 'file-1')
    })

    it('deletes file and updates projects state', async () => {
      mockDeleteFile.mockResolvedValue({})

      const { result } = renderHook(() => useDeleteFile(), { wrapper })

      await act(async () => {
        await result.current.deleteFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      })

      expect(mockDeleteFile).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        fileId: 'file-1'
      })

      // Note: projectsAtom is no longer updated directly.
      // The hook now calls queryClient.invalidateQueries() which
      // triggers a refetch from the server.
    })

    it('clears current file if deleted', async () => {
      mockDeleteFile.mockResolvedValue({})

      const { result } = renderHook(() => useDeleteFile(), { wrapper })

      await act(async () => {
        await result.current.deleteFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      })

      expect(store.get(currentFileIdAtom)).toBeNull()
    })

    it('keeps current file if different file deleted', async () => {
      store.set(currentFileIdAtom, 'main-file')
      mockDeleteFile.mockResolvedValue({})

      const { result } = renderHook(() => useDeleteFile(), { wrapper })

      await act(async () => {
        await result.current.deleteFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      })

      expect(store.get(currentFileIdAtom)).toBe('main-file')
    })
  })

  describe('useSetMainFile', () => {
    beforeEach(() => {
      store.set(projectsAtom, [
        { ...mockProject, files: [mockMainFile, mockFile] }
      ])
    })

    it('sets file as main using updateFile', async () => {
      const newMainFile = { ...mockFile, isMain: true }
      mockUpdateFile.mockResolvedValue({ file: newMainFile })

      const { result } = renderHook(() => useSetMainFile(), { wrapper })

      await act(async () => {
        await result.current.setMainFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      })

      expect(mockUpdateFile).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1',
        fileId: 'file-1',
        isMain: true
      })
    })

    it('exposes loading state during update', async () => {
      let resolveUpdate: (value: unknown) => void
      mockUpdateFile.mockImplementation(
        () =>
          new Promise((resolve) => {
            resolveUpdate = resolve
          })
      )

      const { result } = renderHook(() => useSetMainFile(), { wrapper })

      expect(result.current.loading).toBe(false)

      act(() => {
        result.current.setMainFile({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(true)
      })

      await act(async () => {
        resolveUpdate!({ file: { ...mockFile, isMain: true } })
      })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })
    })
  })
})
