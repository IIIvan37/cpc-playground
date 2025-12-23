import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { ProgramManagerView } from './program-manager.view'

describe('ProgramManagerView', () => {
  const defaultProps = {
    savedPrograms: [
      { id: '1', name: 'Program 1' },
      { id: '2', name: 'Program 2' }
    ],
    currentProgramName: undefined,
    currentProgramId: null,
    selectKey: 0,
    hasCurrentProject: false,
    canSave: true,
    showSaveDialog: false,
    showDeleteDialog: false,
    programName: '',
    onLoad: vi.fn(),
    onNew: vi.fn(),
    onSave: vi.fn(),
    onDelete: vi.fn(),
    onOpenSettings: vi.fn(),
    onSaveConfirm: vi.fn(),
    onDeleteConfirm: vi.fn(),
    onCloseSaveDialog: vi.fn(),
    onCloseDeleteDialog: vi.fn(),
    onProgramNameChange: vi.fn()
  }

  describe('program list', () => {
    it('renders program select with placeholder', () => {
      render(<ProgramManagerView {...defaultProps} />)
      expect(screen.getByRole('combobox')).toHaveTextContent(
        'Select program...'
      )
    })

    it('renders current program name when set', () => {
      render(
        <ProgramManagerView {...defaultProps} currentProgramName='My Program' />
      )
      expect(screen.getByRole('combobox')).toHaveTextContent('My Program')
    })
  })

  describe('action buttons', () => {
    it('renders new button', () => {
      render(<ProgramManagerView {...defaultProps} />)
      expect(
        screen.getByRole('button', { name: /new program/i })
      ).toBeInTheDocument()
    })

    it('renders save button', () => {
      render(<ProgramManagerView {...defaultProps} />)
      expect(
        screen.getByRole('button', { name: /save program/i })
      ).toBeInTheDocument()
    })

    it('renders delete button', () => {
      render(<ProgramManagerView {...defaultProps} />)
      expect(
        screen.getByRole('button', { name: /delete/i })
      ).toBeInTheDocument()
    })

    it('does not render settings button when no project', () => {
      render(<ProgramManagerView {...defaultProps} hasCurrentProject={false} />)
      expect(
        screen.queryByRole('button', { name: /project settings/i })
      ).not.toBeInTheDocument()
    })

    it('renders settings button when project exists', () => {
      render(<ProgramManagerView {...defaultProps} hasCurrentProject={true} />)
      expect(
        screen.getByRole('button', { name: /project settings/i })
      ).toBeInTheDocument()
    })

    it('disables save button when canSave is false', () => {
      render(<ProgramManagerView {...defaultProps} canSave={false} />)
      expect(
        screen.getByRole('button', { name: /cannot save/i })
      ).toBeDisabled()
    })

    it('disables delete button when no program selected', () => {
      render(<ProgramManagerView {...defaultProps} currentProgramId={null} />)
      expect(screen.getByRole('button', { name: /delete/i })).toBeDisabled()
    })

    it('enables delete button when program is selected', () => {
      render(<ProgramManagerView {...defaultProps} currentProgramId='1' />)
      expect(screen.getByRole('button', { name: /delete/i })).not.toBeDisabled()
    })
  })

  describe('interactions', () => {
    it('calls onNew when new button is clicked', async () => {
      const user = userEvent.setup()
      const handleNew = vi.fn()
      render(<ProgramManagerView {...defaultProps} onNew={handleNew} />)

      await user.click(screen.getByRole('button', { name: /new program/i }))

      expect(handleNew).toHaveBeenCalledTimes(1)
    })

    it('calls onSave when save button is clicked', async () => {
      const user = userEvent.setup()
      const handleSave = vi.fn()
      render(<ProgramManagerView {...defaultProps} onSave={handleSave} />)

      await user.click(screen.getByRole('button', { name: /save program/i }))

      expect(handleSave).toHaveBeenCalledTimes(1)
    })

    it('calls onDelete when delete button is clicked', async () => {
      const user = userEvent.setup()
      const handleDelete = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          currentProgramId='1'
          onDelete={handleDelete}
        />
      )

      await user.click(screen.getByRole('button', { name: /delete/i }))

      expect(handleDelete).toHaveBeenCalledTimes(1)
    })

    it('calls onOpenSettings when settings button is clicked', async () => {
      const user = userEvent.setup()
      const handleOpenSettings = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          hasCurrentProject={true}
          onOpenSettings={handleOpenSettings}
        />
      )

      await user.click(
        screen.getByRole('button', { name: /project settings/i })
      )

      expect(handleOpenSettings).toHaveBeenCalledTimes(1)
    })
  })

  describe('save dialog', () => {
    it('renders save dialog when showSaveDialog is true', () => {
      render(<ProgramManagerView {...defaultProps} showSaveDialog={true} />)
      expect(
        screen.getByRole('heading', { name: 'Save Program' })
      ).toBeInTheDocument()
    })

    it('does not render save dialog when showSaveDialog is false', () => {
      render(<ProgramManagerView {...defaultProps} showSaveDialog={false} />)
      expect(
        screen.queryByRole('heading', { name: 'Save Program' })
      ).not.toBeInTheDocument()
    })

    it('renders program name input in save dialog', () => {
      render(
        <ProgramManagerView
          {...defaultProps}
          showSaveDialog={true}
          programName='Test Program'
        />
      )
      expect(screen.getByPlaceholderText('Program name')).toHaveValue(
        'Test Program'
      )
    })

    it('disables save button when program name is empty', () => {
      render(
        <ProgramManagerView
          {...defaultProps}
          showSaveDialog={true}
          programName=''
        />
      )
      expect(screen.getByRole('button', { name: 'Save' })).toBeDisabled()
    })

    it('enables save button when program name is not empty', () => {
      render(
        <ProgramManagerView
          {...defaultProps}
          showSaveDialog={true}
          programName='Test'
        />
      )
      expect(screen.getByRole('button', { name: 'Save' })).not.toBeDisabled()
    })

    it('calls onSaveConfirm when save is clicked', async () => {
      const user = userEvent.setup()
      const handleSaveConfirm = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          showSaveDialog={true}
          programName='Test'
          onSaveConfirm={handleSaveConfirm}
        />
      )

      await user.click(screen.getByRole('button', { name: 'Save' }))

      expect(handleSaveConfirm).toHaveBeenCalledTimes(1)
    })

    it('calls onCloseSaveDialog when cancel is clicked', async () => {
      const user = userEvent.setup()
      const handleCloseSaveDialog = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          showSaveDialog={true}
          onCloseSaveDialog={handleCloseSaveDialog}
        />
      )

      await user.click(screen.getByRole('button', { name: 'Cancel' }))

      expect(handleCloseSaveDialog).toHaveBeenCalledTimes(1)
    })
  })

  describe('delete dialog', () => {
    it('renders delete dialog when showDeleteDialog is true', () => {
      render(
        <ProgramManagerView
          {...defaultProps}
          showDeleteDialog={true}
          currentProgramName='My Program'
        />
      )
      expect(
        screen.getByRole('heading', { name: 'Delete Program' })
      ).toBeInTheDocument()
    })

    it('shows program name in confirmation message', () => {
      render(
        <ProgramManagerView
          {...defaultProps}
          showDeleteDialog={true}
          currentProgramName='My Program'
        />
      )
      expect(
        screen.getByText(/are you sure you want to delete "My Program"/i)
      ).toBeInTheDocument()
    })

    it('calls onDeleteConfirm when delete is clicked', async () => {
      const user = userEvent.setup()
      const handleDeleteConfirm = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          showDeleteDialog={true}
          onDeleteConfirm={handleDeleteConfirm}
        />
      )

      // Get all Delete buttons and click the one in the modal
      const deleteButtons = screen.getAllByRole('button', { name: 'Delete' })
      await user.click(deleteButtons[deleteButtons.length - 1])

      expect(handleDeleteConfirm).toHaveBeenCalledTimes(1)
    })

    it('calls onCloseDeleteDialog when cancel is clicked', async () => {
      const user = userEvent.setup()
      const handleCloseDeleteDialog = vi.fn()
      render(
        <ProgramManagerView
          {...defaultProps}
          showDeleteDialog={true}
          onCloseDeleteDialog={handleCloseDeleteDialog}
        />
      )

      await user.click(screen.getByRole('button', { name: 'Cancel' }))

      expect(handleCloseDeleteDialog).toHaveBeenCalledTimes(1)
    })
  })
})
