import { render, screen, waitFor } from '@testing-library/react'
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
import { currentProjectIdAtom, projectsAtom } from '@/store/projects'
import { ProjectSettingsModal } from './project-settings-modal'

// Mock react-router-dom
const mockNavigate = vi.fn()
vi.mock('react-router-dom', () => ({
  useNavigate: () => mockNavigate
}))

// Mock hooks - use vi.hoisted for mocks used inside vi.mock
const {
  mockHandleSave,
  mockHandleDelete,
  mockHandleAddTag,
  mockHandleRemoveTag,
  mockHandleAddDependency,
  mockHandleRemoveDependency,
  mockHandleAddShare,
  mockHandleRemoveShare,
  mockSearchUsers,
  mockToastError,
  mockToastSuccess,
  mockConfirm
} = vi.hoisted(() => ({
  mockHandleSave: vi.fn(),
  mockHandleDelete: vi.fn(),
  mockHandleAddTag: vi.fn(),
  mockHandleRemoveTag: vi.fn(),
  mockHandleAddDependency: vi.fn(),
  mockHandleRemoveDependency: vi.fn(),
  mockHandleAddShare: vi.fn(),
  mockHandleRemoveShare: vi.fn(),
  mockSearchUsers: vi.fn(),
  mockToastError: vi.fn(),
  mockToastSuccess: vi.fn(),
  mockConfirm: vi.fn()
}))

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

// Mock data that will be used by the mock hooks
let mockCurrentProjectForHook: Project | null = null
let mockAvailableDepsForHook: Project[] = []

vi.mock('@/hooks', () => ({
  useAuth: () => ({
    user: mockUser
  }),
  useConfirmDialog: () => ({
    confirm: mockConfirm,
    dialogProps: {
      open: false,
      title: '',
      message: '',
      onConfirm: vi.fn(),
      onCancel: vi.fn()
    }
  }),
  useCurrentProject: () => ({
    project: mockCurrentProjectForHook,
    isLoading: false
  }),
  useUserProjects: () => ({
    projects: mockAvailableDepsForHook,
    isLoading: false
  }),
  useAvailableDependencies: () => mockAvailableDepsForHook,
  useHandleSaveProject: () => ({
    handleSave: mockHandleSave,
    loading: false
  }),
  useHandleDeleteProject: () => ({
    handleDelete: mockHandleDelete,
    loading: false
  }),
  useHandleAddTag: () => ({
    handleAddTag: mockHandleAddTag,
    loading: false
  }),
  useHandleRemoveTag: () => ({
    handleRemoveTag: mockHandleRemoveTag,
    loading: false
  }),
  useHandleAddDependency: () => ({
    handleAddDependency: mockHandleAddDependency,
    loading: false
  }),
  useHandleRemoveDependency: () => ({
    handleRemoveDependency: mockHandleRemoveDependency,
    loading: false
  }),
  useHandleAddShare: () => ({
    handleAddShare: mockHandleAddShare,
    loading: false
  }),
  useHandleRemoveShare: () => ({
    handleRemoveShare: mockHandleRemoveShare,
    loading: false
  }),
  useSearchUsers: () => ({
    users: [],
    loading: false,
    error: null,
    searchUsers: mockSearchUsers
  }),
  useToastActions: () => ({
    success: mockToastSuccess,
    error: mockToastError,
    warning: vi.fn(),
    info: vi.fn(),
    remove: vi.fn()
  })
}))

const mockFile = createProjectFile({
  id: 'file-1',
  projectId: 'project-1',
  name: createFileName('main.asm'),
  content: createFileContent('; Main file'),
  isMain: true
})

const mockProject: Project = createProject({
  id: 'project-1',
  name: createProjectName('Test Project'),
  userId: 'user-1',
  files: [mockFile],
  visibility: createVisibility('private'),
  isLibrary: false,
  tags: ['tag1', 'tag2'],
  dependencies: [{ id: 'lib-1', name: 'Library One' }],
  userShares: []
})

const mockLibraryProject: Project = createProject({
  id: 'lib-2',
  name: createProjectName('Library Two'),
  userId: 'user-1',
  files: [mockFile],
  visibility: createVisibility('public'),
  isLibrary: true
})

describe('ProjectSettingsModal', () => {
  let store: ReturnType<typeof createStore>
  const mockOnClose = vi.fn()

  const wrapper = ({ children }: { children: ReactNode }) => (
    <Provider store={store}>{children}</Provider>
  )

  const renderComponent = () => {
    return render(<ProjectSettingsModal onClose={mockOnClose} />, { wrapper })
  }

  beforeEach(() => {
    vi.clearAllMocks()
    store = createStore()
    store.set(projectsAtom, [mockProject, mockLibraryProject])
    store.set(currentProjectIdAtom, 'project-1')

    // Set mock hook values
    mockCurrentProjectForHook = mockProject
    mockAvailableDepsForHook = [mockLibraryProject]

    // Default mock implementations
    mockHandleSave.mockResolvedValue({ success: true })
    mockHandleDelete.mockResolvedValue({ success: true })
    mockHandleAddTag.mockResolvedValue({ success: true })
    mockHandleRemoveTag.mockResolvedValue({ success: true })
    mockHandleAddDependency.mockResolvedValue({ success: true })
    mockHandleRemoveDependency.mockResolvedValue({ success: true })
    mockHandleAddShare.mockResolvedValue({ success: true })
    mockHandleRemoveShare.mockResolvedValue({ success: true })

    // Mock confirm dialog
    mockConfirm.mockResolvedValue(true)
  })

  describe('rendering', () => {
    it('renders nothing when no project', () => {
      mockCurrentProjectForHook = null
      store.set(currentProjectIdAtom, null)

      const { container } = renderComponent()
      expect(container).toBeEmptyDOMElement()
    })

    it('renders project name in input', () => {
      renderComponent()

      expect(screen.getByDisplayValue('Test Project')).toBeInTheDocument()
    })

    it('renders current tags', () => {
      renderComponent()

      expect(screen.getByText('tag1')).toBeInTheDocument()
      expect(screen.getByText('tag2')).toBeInTheDocument()
    })

    it('renders current dependencies', () => {
      renderComponent()

      expect(screen.getByText('Library One')).toBeInTheDocument()
    })

    it('renders modal title', () => {
      renderComponent()

      expect(screen.getByText('Project Settings')).toBeInTheDocument()
    })
  })

  describe('save project', () => {
    it('calls handleSave with form values', async () => {
      const user = userEvent.setup()
      renderComponent()

      // Change project name
      const nameInput = screen.getByDisplayValue('Test Project')
      await user.clear(nameInput)
      await user.type(nameInput, 'Updated Project')

      // Save
      await user.click(screen.getByRole('button', { name: /save/i }))

      await waitFor(() => {
        expect(mockHandleSave).toHaveBeenCalledWith({
          projectId: 'project-1',
          userId: 'user-1',
          name: 'Updated Project',
          description: '',
          visibility: 'private',
          isLibrary: false
        })
      })
    })

    it('closes modal on successful save', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /save/i }))

      await waitFor(() => {
        expect(mockOnClose).toHaveBeenCalled()
      })
    })

    it('shows error on save failure', async () => {
      mockHandleSave.mockResolvedValue({
        success: false,
        error: 'Save failed'
      })
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /save/i }))

      await waitFor(() => {
        expect(mockToastError).toHaveBeenCalledWith(
          'Failed to save settings',
          'Save failed'
        )
      })
    })
  })

  describe('delete project', () => {
    it('calls handleDelete', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /delete project/i }))

      await waitFor(() => {
        expect(mockConfirm).toHaveBeenCalled()
        expect(mockHandleDelete).toHaveBeenCalledWith('project-1', 'user-1')
      })
    })

    it('navigates to explore on successful delete', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /delete project/i }))

      await waitFor(() => {
        expect(mockNavigate).toHaveBeenCalledWith('/explore')
      })
    })
  })

  describe('tags', () => {
    it('renders current tags', () => {
      renderComponent()

      expect(screen.getByText('tag1')).toBeInTheDocument()
      expect(screen.getByText('tag2')).toBeInTheDocument()
    })

    it('has tag input field', () => {
      renderComponent()

      const tagInput = screen.getByPlaceholderText('Add a tag...')
      expect(tagInput).toBeInTheDocument()
    })
  })

  describe('dependencies', () => {
    it('renders dependencies section', () => {
      renderComponent()

      // Check that the dependencies section is rendered
      expect(screen.getByText('Library One')).toBeInTheDocument()
    })
  })

  describe('library flag', () => {
    it('toggles library flag', async () => {
      const user = userEvent.setup()
      renderComponent()

      const libraryCheckbox = screen.getByRole('checkbox', {
        name: /library project/i
      })
      await user.click(libraryCheckbox)

      await user.click(screen.getByRole('button', { name: /save/i }))

      await waitFor(() => {
        expect(mockHandleSave).toHaveBeenCalledWith(
          expect.objectContaining({
            isLibrary: true
          })
        )
      })
    })
  })

  describe('close modal', () => {
    it('calls onClose when clicking cancel button', async () => {
      const user = userEvent.setup()
      renderComponent()

      await user.click(screen.getByRole('button', { name: /cancel/i }))

      expect(mockOnClose).toHaveBeenCalled()
    })
  })
})
