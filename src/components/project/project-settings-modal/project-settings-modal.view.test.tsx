import { fireEvent, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { ProjectSettingsModalView } from './project-settings-modal.view'

describe('ProjectSettingsModalView', () => {
  const defaultProps = {
    name: 'Test Project',
    description: 'Test description',
    visibility: 'private' as const,
    isLibrary: false,
    newTag: '',
    selectedDependency: '',
    shareUsername: '',
    loading: false,
    currentTags: [] as readonly string[],
    currentDependencies: [] as readonly { id: string; name: string }[],
    currentUserShares: [] as readonly { userId: string; username: string }[],
    availableDependencies: [] as readonly { id: string; name: string }[],
    onNameChange: vi.fn(),
    onDescriptionChange: vi.fn(),
    onVisibilityChange: vi.fn(),
    onIsLibraryChange: vi.fn(),
    onNewTagChange: vi.fn(),
    onSelectedDependencyChange: vi.fn(),
    onShareUsernameChange: vi.fn(),
    onSave: vi.fn(),
    onClose: vi.fn(),
    onAddTag: vi.fn(),
    onRemoveTag: vi.fn(),
    onAddDependency: vi.fn(),
    onRemoveDependency: vi.fn(),
    onAddShare: vi.fn(),
    onRemoveShare: vi.fn()
  }

  describe('modal rendering', () => {
    it('renders modal with title', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(
        screen.getByRole('heading', { name: 'Project Settings' })
      ).toBeInTheDocument()
    })

    it('renders Save Changes button', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(
        screen.getByRole('button', { name: 'Save Changes' })
      ).toBeInTheDocument()
    })

    it('renders Cancel button', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(screen.getByRole('button', { name: 'Cancel' })).toBeInTheDocument()
    })
  })

  describe('basic information section', () => {
    it('renders name input with value', () => {
      render(<ProjectSettingsModalView {...defaultProps} name='My Project' />)
      expect(screen.getByLabelText('Name')).toHaveValue('My Project')
    })

    it('renders description textarea with value', () => {
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          description='Project description'
        />
      )
      expect(screen.getByLabelText('Description')).toHaveValue(
        'Project description'
      )
    })

    it('renders library checkbox', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(
        screen.getByLabelText('This is a library project')
      ).toBeInTheDocument()
    })

    it('shows library checkbox as checked when isLibrary is true', () => {
      render(<ProjectSettingsModalView {...defaultProps} isLibrary={true} />)
      expect(screen.getByLabelText('This is a library project')).toBeChecked()
    })
  })

  describe('visibility section', () => {
    it('renders visibility select', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(screen.getByText('Visibility')).toBeInTheDocument()
    })

    it('shows private help text for private visibility', () => {
      render(
        <ProjectSettingsModalView {...defaultProps} visibility='private' />
      )
      expect(
        screen.getByText('Only you can see and edit this project')
      ).toBeInTheDocument()
    })

    it('shows public help text for public visibility', () => {
      render(<ProjectSettingsModalView {...defaultProps} visibility='public' />)
      expect(
        screen.getByText(
          'Everyone can see this project, but only you can edit it'
        )
      ).toBeInTheDocument()
    })

    it('shows shared help text for shared visibility', () => {
      render(<ProjectSettingsModalView {...defaultProps} visibility='shared' />)
      expect(
        screen.getByText(
          'Only you and users you share with can see this project'
        )
      ).toBeInTheDocument()
    })
  })

  describe('user shares section', () => {
    it('shows shared with section when visibility is shared', () => {
      render(<ProjectSettingsModalView {...defaultProps} visibility='shared' />)
      expect(screen.getByText('Shared with')).toBeInTheDocument()
    })

    it('does not show shared with section when visibility is private', () => {
      render(
        <ProjectSettingsModalView {...defaultProps} visibility='private' />
      )
      expect(screen.queryByText('Shared with')).not.toBeInTheDocument()
    })

    it('renders user shares list', () => {
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          visibility='shared'
          currentUserShares={[{ userId: '1', username: 'john_doe' }]}
        />
      )
      expect(screen.getByText('john_doe')).toBeInTheDocument()
    })
  })

  describe('tags section', () => {
    it('renders tags section', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(screen.getByText('Tags')).toBeInTheDocument()
    })

    it('renders current tags', () => {
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          currentTags={['tag1', 'tag2']}
        />
      )
      expect(screen.getByText('tag1')).toBeInTheDocument()
      expect(screen.getByText('tag2')).toBeInTheDocument()
    })
  })

  describe('dependencies section', () => {
    it('renders dependencies section', () => {
      render(<ProjectSettingsModalView {...defaultProps} />)
      expect(screen.getByText('Dependencies')).toBeInTheDocument()
    })

    it('renders current dependencies', () => {
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          currentDependencies={[{ id: '1', name: 'lib1' }]}
        />
      )
      expect(screen.getByText('lib1')).toBeInTheDocument()
    })
  })

  describe('loading state', () => {
    it('shows Saving text when loading', () => {
      render(<ProjectSettingsModalView {...defaultProps} loading={true} />)
      expect(screen.getByText('Saving...')).toBeInTheDocument()
    })

    it('disables save button when loading', () => {
      render(<ProjectSettingsModalView {...defaultProps} loading={true} />)
      expect(screen.getByRole('button', { name: 'Saving...' })).toBeDisabled()
    })

    it('disables cancel button when loading', () => {
      render(<ProjectSettingsModalView {...defaultProps} loading={true} />)
      expect(screen.getByRole('button', { name: 'Cancel' })).toBeDisabled()
    })
  })

  describe('form interactions', () => {
    it('calls onNameChange when name is changed', () => {
      const handleNameChange = vi.fn()
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          onNameChange={handleNameChange}
        />
      )

      fireEvent.change(screen.getByLabelText('Name'), {
        target: { value: 'New Name' }
      })

      expect(handleNameChange).toHaveBeenCalledWith('New Name')
    })

    it('calls onDescriptionChange when description is changed', () => {
      const handleDescriptionChange = vi.fn()
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          onDescriptionChange={handleDescriptionChange}
        />
      )

      fireEvent.change(screen.getByLabelText('Description'), {
        target: { value: 'New Description' }
      })

      expect(handleDescriptionChange).toHaveBeenCalledWith('New Description')
    })

    it('calls onIsLibraryChange when library checkbox is toggled', async () => {
      const user = userEvent.setup()
      const handleIsLibraryChange = vi.fn()
      render(
        <ProjectSettingsModalView
          {...defaultProps}
          onIsLibraryChange={handleIsLibraryChange}
        />
      )

      await user.click(screen.getByLabelText('This is a library project'))

      expect(handleIsLibraryChange).toHaveBeenCalledWith(true)
    })

    it('calls onSave when save button is clicked', async () => {
      const user = userEvent.setup()
      const handleSave = vi.fn()
      render(<ProjectSettingsModalView {...defaultProps} onSave={handleSave} />)

      await user.click(screen.getByRole('button', { name: 'Save Changes' }))

      expect(handleSave).toHaveBeenCalledTimes(1)
    })

    it('calls onClose when cancel button is clicked', async () => {
      const user = userEvent.setup()
      const handleClose = vi.fn()
      render(
        <ProjectSettingsModalView {...defaultProps} onClose={handleClose} />
      )

      await user.click(screen.getByRole('button', { name: 'Cancel' }))

      expect(handleClose).toHaveBeenCalledTimes(1)
    })
  })
})
