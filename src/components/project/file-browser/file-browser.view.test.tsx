import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import styles from './file-browser.module.css'
import { FileBrowserView } from './file-browser.view'

describe('FileBrowserView', () => {
  const defaultProject = {
    name: 'Test Project',
    visibility: 'private' as const,
    isLibrary: false,
    tags: [] as readonly string[]
  }

  const defaultFiles = [
    { id: 'file-1', name: 'main.asm', isMain: true },
    { id: 'file-2', name: 'utils.asm', isMain: false }
  ]

  const defaultProps = {
    project: defaultProject,
    files: defaultFiles,
    selectedFileId: 'file-1',
    canEdit: true,
    isReadOnly: false,
    onSelectFile: vi.fn(),
    onNewFileClick: vi.fn(),
    onSetMainFile: vi.fn(),
    onRenameFile: vi.fn(),
    onDeleteFile: vi.fn()
  }

  describe('project header', () => {
    it('renders project name', () => {
      render(<FileBrowserView {...defaultProps} />)
      expect(screen.getByText('Test Project')).toBeInTheDocument()
    })

    it('shows new file button when canEdit is true', () => {
      render(<FileBrowserView {...defaultProps} canEdit={true} />)
      expect(
        screen.getByRole('button', { name: 'New File' })
      ).toBeInTheDocument()
    })

    it('hides new file button when canEdit is false', () => {
      render(<FileBrowserView {...defaultProps} canEdit={false} />)
      expect(
        screen.queryByRole('button', { name: 'New File' })
      ).not.toBeInTheDocument()
    })

    it('calls onNewFileClick when new file button is clicked', async () => {
      const user = userEvent.setup()
      const handleNewFile = vi.fn()
      render(
        <FileBrowserView {...defaultProps} onNewFileClick={handleNewFile} />
      )

      await user.click(screen.getByRole('button', { name: 'New File' }))

      expect(handleNewFile).toHaveBeenCalledTimes(1)
    })

    it('shows Read-only badge when in read-only mode', () => {
      render(<FileBrowserView {...defaultProps} isReadOnly={true} />)
      expect(screen.getByText('Read-only')).toBeInTheDocument()
    })

    it('does not show Read-only badge when not in read-only mode', () => {
      render(<FileBrowserView {...defaultProps} isReadOnly={false} />)
      expect(screen.queryByText('Read-only')).not.toBeInTheDocument()
    })
  })

  describe('project badges', () => {
    it('shows Public badge for public projects', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, visibility: 'public' }}
        />
      )
      expect(screen.getByText('Public')).toBeInTheDocument()
    })

    it('does not show Public badge for private projects', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, visibility: 'private' }}
        />
      )
      expect(screen.queryByText('Public')).not.toBeInTheDocument()
    })

    it('shows Library badge for library projects', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, isLibrary: true }}
        />
      )
      expect(screen.getByText('Library')).toBeInTheDocument()
    })

    it('does not show Library badge for non-library projects', () => {
      render(<FileBrowserView {...defaultProps} />)
      expect(screen.queryByText('Library')).not.toBeInTheDocument()
    })
  })

  describe('file list', () => {
    it('renders all files', () => {
      render(<FileBrowserView {...defaultProps} />)
      expect(screen.getByText('main.asm')).toBeInTheDocument()
      expect(screen.getByText('utils.asm')).toBeInTheDocument()
    })

    it('marks selected file as active', () => {
      const { container } = render(
        <FileBrowserView {...defaultProps} selectedFileId='file-1' />
      )
      const fileItems = container.querySelectorAll(`.${styles.fileItem}`)
      expect(fileItems[0]).toHaveClass(styles.active)
      expect(fileItems[1]).not.toHaveClass(styles.active)
    })

    it('calls onSelectFile when file is clicked', async () => {
      const user = userEvent.setup()
      const handleSelectFile = vi.fn()
      render(
        <FileBrowserView {...defaultProps} onSelectFile={handleSelectFile} />
      )

      await user.click(screen.getByText('utils.asm'))

      expect(handleSelectFile).toHaveBeenCalledWith('file-2')
    })
  })

  describe('main file indicator', () => {
    it('shows star icon for main file', () => {
      const { container } = render(<FileBrowserView {...defaultProps} />)
      const mainFileItem = container.querySelector(
        `.${styles.fileItem}.${styles.active}`
      )
      expect(
        mainFileItem?.querySelector(`.${styles.mainIcon}`)
      ).toBeInTheDocument()
    })

    it('does not show star icon for non-main files', () => {
      const { container } = render(<FileBrowserView {...defaultProps} />)
      const fileItems = container.querySelectorAll(`.${styles.fileItem}`)
      expect(
        fileItems[1].querySelector(`.${styles.mainIcon}`)
      ).not.toBeInTheDocument()
    })
  })

  describe('file actions', () => {
    it('shows set main button for non-main files when canEdit is true', async () => {
      render(<FileBrowserView {...defaultProps} canEdit={true} />)
      expect(
        screen.getByRole('button', { name: 'Set as main file' })
      ).toBeInTheDocument()
    })

    it('hides set main button when canEdit is false', () => {
      render(<FileBrowserView {...defaultProps} canEdit={false} />)
      expect(
        screen.queryByRole('button', { name: 'Set as main file' })
      ).not.toBeInTheDocument()
    })

    it('does not show set main button for library projects', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, isLibrary: true }}
        />
      )
      expect(
        screen.queryByRole('button', { name: 'Set as main file' })
      ).not.toBeInTheDocument()
    })

    it('calls onSetMainFile when set main button is clicked', async () => {
      const user = userEvent.setup()
      const handleSetMainFile = vi.fn()
      render(
        <FileBrowserView {...defaultProps} onSetMainFile={handleSetMainFile} />
      )

      await user.click(screen.getByRole('button', { name: 'Set as main file' }))

      expect(handleSetMainFile).toHaveBeenCalledWith('file-2')
    })

    it('shows delete button when canEdit is true and multiple files exist', () => {
      render(<FileBrowserView {...defaultProps} canEdit={true} />)
      expect(
        screen.getAllByRole('button', { name: 'Delete file' })
      ).toHaveLength(2)
    })

    it('hides delete buttons when only one file exists', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          files={[{ id: 'file-1', name: 'main.asm', isMain: true }]}
        />
      )
      expect(
        screen.queryByRole('button', { name: 'Delete file' })
      ).not.toBeInTheDocument()
    })

    it('calls onDeleteFile when delete button is clicked', async () => {
      const user = userEvent.setup()
      const handleDeleteFile = vi.fn()
      render(
        <FileBrowserView {...defaultProps} onDeleteFile={handleDeleteFile} />
      )

      const deleteButtons = screen.getAllByRole('button', {
        name: 'Delete file'
      })
      await user.click(deleteButtons[0])

      expect(handleDeleteFile).toHaveBeenCalledWith('file-1')
    })

    it('shows rename button when canEdit is true', () => {
      render(<FileBrowserView {...defaultProps} canEdit={true} />)
      expect(
        screen.getAllByRole('button', { name: 'Rename file' })
      ).toHaveLength(2)
    })

    it('hides rename buttons when canEdit is false', () => {
      render(<FileBrowserView {...defaultProps} canEdit={false} />)
      expect(
        screen.queryByRole('button', { name: 'Rename file' })
      ).not.toBeInTheDocument()
    })

    it('calls onRenameFile when rename button is clicked', async () => {
      const user = userEvent.setup()
      const handleRenameFile = vi.fn()
      render(
        <FileBrowserView {...defaultProps} onRenameFile={handleRenameFile} />
      )

      const renameButtons = screen.getAllByRole('button', {
        name: 'Rename file'
      })
      await user.click(renameButtons[0])

      expect(handleRenameFile).toHaveBeenCalledWith('file-1')
    })
  })

  describe('tags', () => {
    it('renders tags when provided', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, tags: ['assembly', 'game'] }}
        />
      )
      expect(screen.getByText('assembly')).toBeInTheDocument()
      expect(screen.getByText('game')).toBeInTheDocument()
    })

    it('does not render tags section when no tags', () => {
      const { container } = render(
        <FileBrowserView
          {...defaultProps}
          project={{ ...defaultProject, tags: [] }}
        />
      )
      expect(container.querySelector('.tags')).not.toBeInTheDocument()
    })
  })

  describe('newFileDialog slot', () => {
    it('does not render dialog when undefined', () => {
      render(<FileBrowserView {...defaultProps} />)
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    })

    it('renders newFileDialog when provided', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          newFileDialog={<div role='dialog'>New File Dialog</div>}
        />
      )
      expect(screen.getByRole('dialog')).toBeInTheDocument()
    })
  })

  describe('renameFileDialog slot', () => {
    it('does not render rename dialog when undefined', () => {
      render(<FileBrowserView {...defaultProps} />)
      expect(screen.queryByText('Rename File Dialog')).not.toBeInTheDocument()
    })

    it('renders renameFileDialog when provided', () => {
      render(
        <FileBrowserView
          {...defaultProps}
          renameFileDialog={<div>Rename File Dialog</div>}
        />
      )
      expect(screen.getByText('Rename File Dialog')).toBeInTheDocument()
    })
  })
})
