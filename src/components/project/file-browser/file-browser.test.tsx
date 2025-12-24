import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject, type Project } from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type { User } from '@/domain/entities/user.entity'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { codeAtom } from '@/store/editor'
import {
  currentFileIdAtom,
  currentProjectIdAtom,
  dependencyFilesAtom,
  isReadOnlyModeAtom,
  projectsAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { FileBrowser } from './file-browser'

// Mock hooks
const mockCreateFile = vi.fn()
const mockDeleteFile = vi.fn()
const mockSetMainFile = vi.fn()
const mockFetchDependencyFiles = vi.fn()

const mockUser: User = {
  id: 'user-1',
  email: 'test@example.com',
  profile: {
    id: 'profile-1',
    username: 'testuser',
    createdAt: new Date(),
    updatedAt: new Date()
  }
}

vi.mock('@/hooks', () => ({
  useAuth: () => ({
    user: mockUser
  }),
  useCreateFile: () => ({
    createFile: mockCreateFile,
    loading: false
  }),
  useDeleteFile: () => ({
    deleteFile: mockDeleteFile,
    loading: false
  }),
  useSetMainFile: () => ({
    setMainFile: mockSetMainFile,
    loading: false
  }),
  useFetchDependencyFiles: () => ({
    fetchDependencyFiles: mockFetchDependencyFiles,
    loading: false
  })
}))

const mockMainFile = createProjectFile({
  id: 'main-file',
  projectId: 'project-1',
  name: createFileName('main.asm'),
  content: createFileContent('; Main file content'),
  isMain: true
})

const mockSecondFile = createProjectFile({
  id: 'second-file',
  projectId: 'project-1',
  name: createFileName('utils.asm'),
  content: createFileContent('; Utils file'),
  isMain: false
})

const mockProject: Project = createProject({
  id: 'project-1',
  name: createProjectName('Test Project'),
  userId: 'user-1',
  files: [mockMainFile, mockSecondFile],
  visibility: createVisibility('private'),
  isLibrary: false,
  dependencies: []
})

describe('FileBrowser', () => {
  let store: ReturnType<typeof createStore>

  const wrapper = ({ children }: { children: ReactNode }) => (
    <Provider store={store}>{children}</Provider>
  )

  const renderComponent = () => {
    return render(<FileBrowser />, { wrapper })
  }

  beforeEach(() => {
    vi.clearAllMocks()
    store = createStore()
    store.set(projectsAtom, [mockProject])
    store.set(currentProjectIdAtom, 'project-1')
    store.set(currentFileIdAtom, 'main-file')
    store.set(isReadOnlyModeAtom, false)
    store.set(dependencyFilesAtom, [])
    store.set(codeAtom, '')
    store.set(viewOnlyProjectAtom, null)

    // Mock confirm dialog
    vi.spyOn(globalThis, 'confirm').mockReturnValue(true)
  })

  describe('rendering', () => {
    it('renders nothing when no project', () => {
      store.set(projectsAtom, [])
      store.set(currentProjectIdAtom, null)

      const { container } = renderComponent()
      expect(container).toBeEmptyDOMElement()
    })

    it('renders project files', () => {
      renderComponent()

      expect(screen.getByText('main.asm')).toBeInTheDocument()
      expect(screen.getByText('utils.asm')).toBeInTheDocument()
    })

    it('shows new file button when user can edit', () => {
      renderComponent()

      expect(
        screen.getByRole('button', { name: /new file/i })
      ).toBeInTheDocument()
    })

    it('hides new file button in read-only mode', () => {
      store.set(isReadOnlyModeAtom, true)
      store.set(viewOnlyProjectAtom, mockProject)
      store.set(currentProjectIdAtom, null)

      renderComponent()

      expect(
        screen.queryByRole('button', { name: /new file/i })
      ).not.toBeInTheDocument()
    })
  })

  describe('file selection', () => {
    it('selects file on click', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByText('utils.asm'))

      expect(store.get(currentFileIdAtom)).toBe('second-file')
    })

    it('updates code when selecting file', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByText('utils.asm'))

      expect(store.get(codeAtom)).toBe('; Utils file')
    })
  })

  describe('create file', () => {
    it('opens new file dialog', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /new file/i }))

      expect(screen.getByText('New File')).toBeInTheDocument()
      expect(screen.getByPlaceholderText('filename.asm')).toBeInTheDocument()
    })

    it('creates file with entered name', async () => {
      const user = userEvent.setup()
      mockCreateFile.mockResolvedValue({ file: {} })
      renderComponent()

      await user.click(screen.getByRole('button', { name: /new file/i }))

      const input = screen.getByPlaceholderText('filename.asm')
      fireEvent.change(input, { target: { value: 'newfile.asm' } })

      await user.click(screen.getByRole('button', { name: /^create$/i }))

      await waitFor(() => {
        expect(mockCreateFile).toHaveBeenCalledWith({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'newfile.asm'
        })
      })
    })

    it('closes dialog after creation', async () => {
      const user = userEvent.setup()
      mockCreateFile.mockResolvedValue({ file: {} })
      renderComponent()

      await user.click(screen.getByRole('button', { name: /new file/i }))

      const input = screen.getByPlaceholderText('filename.asm')
      fireEvent.change(input, { target: { value: 'newfile.asm' } })

      await user.click(screen.getByRole('button', { name: /^create$/i }))

      await waitFor(() => {
        expect(screen.queryByText('New File')).not.toBeInTheDocument()
      })
    })

    it('cancels dialog', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /new file/i }))
      await user.click(screen.getByRole('button', { name: /cancel/i }))

      expect(screen.queryByText('New File')).not.toBeInTheDocument()
    })

    it('creates file on Enter key', async () => {
      const user = userEvent.setup()
      mockCreateFile.mockResolvedValue({ file: {} })
      renderComponent()

      await user.click(screen.getByRole('button', { name: /new file/i }))

      const input = screen.getByPlaceholderText('filename.asm')
      fireEvent.change(input, { target: { value: 'enter.asm' } })
      fireEvent.keyDown(input, { key: 'Enter' })

      await waitFor(() => {
        expect(mockCreateFile).toHaveBeenCalledWith({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'enter.asm'
        })
      })
    })
  })

  describe('delete file', () => {
    it('confirms before deleting', async () => {
      const user = userEvent.setup()
      renderComponent()

      // Find delete button for utils.asm (non-main file)
      const deleteButtons = screen.getAllByRole('button', { name: /delete/i })
      await user.click(deleteButtons[0])

      expect(globalThis.confirm).toHaveBeenCalledWith('Delete this file?')
    })

    it('deletes file when confirmed', async () => {
      const user = userEvent.setup()
      mockDeleteFile.mockResolvedValue({})
      renderComponent()

      const deleteButtons = screen.getAllByRole('button', { name: /delete/i })
      await user.click(deleteButtons[0])

      await waitFor(() => {
        expect(mockDeleteFile).toHaveBeenCalledWith({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: expect.any(String)
        })
      })
    })

    it('does not delete when cancelled', async () => {
      vi.spyOn(globalThis, 'confirm').mockReturnValue(false)
      const user = userEvent.setup()
      renderComponent()

      const deleteButtons = screen.getAllByRole('button', { name: /delete/i })
      await user.click(deleteButtons[0])

      expect(mockDeleteFile).not.toHaveBeenCalled()
    })
  })

  describe('set main file', () => {
    it('sets file as main', async () => {
      const user = userEvent.setup()
      mockSetMainFile.mockResolvedValue({})
      renderComponent()

      // Find "set as main" button for utils.asm
      const setMainButtons = screen.getAllByRole('button', {
        name: /set as main/i
      })
      await user.click(setMainButtons[0])

      await waitFor(() => {
        expect(mockSetMainFile).toHaveBeenCalledWith({
          projectId: 'project-1',
          userId: 'user-1',
          fileId: expect.any(String)
        })
      })
    })
  })

  describe('read-only mode', () => {
    beforeEach(() => {
      store.set(isReadOnlyModeAtom, true)
      store.set(viewOnlyProjectAtom, mockProject)
      store.set(currentProjectIdAtom, null)
    })

    it('hides edit controls', () => {
      renderComponent()

      expect(
        screen.queryByRole('button', { name: /new file/i })
      ).not.toBeInTheDocument()
      expect(
        screen.queryByRole('button', { name: /delete/i })
      ).not.toBeInTheDocument()
    })

    it('allows file selection', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByText('utils.asm'))

      expect(store.get(codeAtom)).toBe('; Utils file')
    })
  })

  describe('dependencies', () => {
    const mockDependencyProject = {
      id: 'lib-project',
      name: 'Library Project',
      files: [
        {
          id: 'dep-file-1',
          name: 'lib.asm',
          content: '; Library code',
          projectId: 'lib-project'
        }
      ]
    }

    beforeEach(() => {
      store.set(dependencyFilesAtom, [mockDependencyProject])
    })

    it('renders dependency files', () => {
      renderComponent()

      expect(screen.getByText('Library Project')).toBeInTheDocument()
    })

    it('expands dependency project and shows files', async () => {
      const user = userEvent.setup()
      renderComponent()

      // Click to expand dependency project
      await user.click(screen.getByText('Library Project'))

      expect(screen.getByText('lib.asm')).toBeInTheDocument()
    })

    it('selects dependency file', async () => {
      const user = userEvent.setup()
      renderComponent()

      // Expand dependency project
      await user.click(screen.getByText('Library Project'))
      // Select file
      await user.click(screen.getByText('lib.asm'))

      expect(store.get(codeAtom)).toBe('; Library code')
    })
  })
})
