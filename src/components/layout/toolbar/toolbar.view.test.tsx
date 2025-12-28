import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import styles from './toolbar.module.css'
import {
  OutputFormatSelectView,
  RunControlsView,
  ToolbarView,
  ViewModeSelectView
} from './toolbar.view'

describe('OutputFormatSelectView', () => {
  it('renders output label', () => {
    render(<OutputFormatSelectView value='sna' onChange={vi.fn()} />)
    expect(screen.getByText('Output:')).toBeInTheDocument()
  })

  it('displays current value for SNA', () => {
    render(<OutputFormatSelectView value='sna' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('SNA')
  })

  it('displays current value for DSK', () => {
    render(<OutputFormatSelectView value='dsk' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('DSK')
  })
})

describe('RunControlsView', () => {
  const defaultProps = {
    isReady: true,
    isCompiling: false,
    isLibrary: false,
    outputFormat: 'sna',
    onRun: vi.fn(),
    onInject: vi.fn(),
    isInjectAvailable: true,
    onReset: vi.fn(),
    onExportBinary: vi.fn(),
    hasCompiledOutput: false
  }

  it('renders Run button', () => {
    render(<RunControlsView {...defaultProps} />)
    expect(screen.getByRole('button', { name: /run/i })).toBeInTheDocument()
  })

  it('renders Reset button', () => {
    render(<RunControlsView {...defaultProps} />)
    expect(screen.getByRole('button', { name: /reset/i })).toBeInTheDocument()
  })

  it('shows Compiling text when isCompiling is true', () => {
    render(<RunControlsView {...defaultProps} isCompiling={true} />)
    expect(screen.getByText('Compiling...')).toBeInTheDocument()
  })

  it('disables Run button when not ready', () => {
    render(<RunControlsView {...defaultProps} isReady={false} />)
    expect(screen.getByRole('button', { name: /run/i })).toBeDisabled()
  })

  it('disables Run button when compiling', () => {
    render(<RunControlsView {...defaultProps} isCompiling={true} />)
    expect(screen.getByRole('button', { name: /compiling/i })).toBeDisabled()
  })

  it('disables Run button for library projects', () => {
    render(<RunControlsView {...defaultProps} isLibrary={true} />)
    expect(screen.getByRole('button', { name: /run/i })).toBeDisabled()
  })

  it('disables Reset button when not ready', () => {
    render(<RunControlsView {...defaultProps} isReady={false} />)
    expect(screen.getByRole('button', { name: /reset/i })).toBeDisabled()
  })

  it('calls onRun when Run button is clicked', async () => {
    const user = userEvent.setup()
    const handleRun = vi.fn()
    render(<RunControlsView {...defaultProps} onRun={handleRun} />)

    await user.click(screen.getByRole('button', { name: /run/i }))

    expect(handleRun).toHaveBeenCalledTimes(1)
  })

  it('calls onReset when Reset button is clicked', async () => {
    const user = userEvent.setup()
    const handleReset = vi.fn()
    render(<RunControlsView {...defaultProps} onReset={handleReset} />)

    await user.click(screen.getByRole('button', { name: /reset/i }))

    expect(handleReset).toHaveBeenCalledTimes(1)
  })

  it('renders Inject button when outputFormat is dsk', () => {
    render(<RunControlsView {...defaultProps} outputFormat='dsk' />)
    expect(screen.getByRole('button', { name: /inject/i })).toBeInTheDocument()
  })

  it('does not render Inject button when outputFormat is sna', () => {
    render(<RunControlsView {...defaultProps} outputFormat='sna' />)
    expect(
      screen.queryByRole('button', { name: /inject/i })
    ).not.toBeInTheDocument()
  })

  it('calls onInject when Inject button is clicked', async () => {
    const user = userEvent.setup()
    const handleInject = vi.fn()
    render(
      <RunControlsView
        {...defaultProps}
        outputFormat='dsk'
        onInject={handleInject}
      />
    )

    await user.click(screen.getByRole('button', { name: /inject/i }))

    expect(handleInject).toHaveBeenCalledTimes(1)
  })

  it('disables Inject button when not ready', () => {
    render(
      <RunControlsView {...defaultProps} outputFormat='dsk' isReady={false} />
    )
    expect(screen.getByRole('button', { name: /inject/i })).toBeDisabled()
  })
})

describe('ViewModeSelectView', () => {
  it('renders view label', () => {
    render(<ViewModeSelectView value='split' onChange={vi.fn()} />)
    expect(screen.getByText('View:')).toBeInTheDocument()
  })

  it('displays split value', () => {
    render(<ViewModeSelectView value='split' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('Split')
  })

  it('displays editor value', () => {
    render(<ViewModeSelectView value='editor' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('Editor')
  })

  it('displays emulator value', () => {
    render(<ViewModeSelectView value='emulator' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('Emulator')
  })

  it('displays markdown value', () => {
    render(<ViewModeSelectView value='markdown' onChange={vi.fn()} />)
    expect(screen.getByRole('combobox')).toHaveTextContent('Markdown')
  })

  it('always shows all view options regardless of isMarkdownFile', () => {
    render(<ViewModeSelectView value='editor' onChange={vi.fn()} />)
    // All options should be available
    expect(screen.getByRole('combobox')).toHaveTextContent('Editor')
  })
})

describe('ToolbarView', () => {
  const defaultProps = {
    programManager: <div data-testid='program-manager'>Program Manager</div>,
    outputFormat: 'sna',
    onOutputFormatChange: vi.fn(),
    isReady: true,
    isCompiling: false,
    isLibrary: false,
    onRun: vi.fn(),
    onInject: vi.fn(),
    isInjectAvailable: true,
    onReset: vi.fn(),
    onExportBinary: vi.fn(),
    hasCompiledOutput: false,
    viewMode: 'split',
    onViewModeChange: vi.fn(),
    // New project creation props
    isAuthenticated: true,
    hasActiveProject: false,
    onExportProject: vi.fn(),
    exportingProject: false,
    onCreateProjectFromCode: vi.fn(),
    showCreateProjectDialog: false,
    newProjectName: '',
    newProjectIsLibrary: false,
    creatingProject: false,
    onNewProjectNameChange: vi.fn(),
    onNewProjectIsLibraryChange: vi.fn(),
    onCreateProjectSubmit: vi.fn(),
    onCloseCreateProjectDialog: vi.fn()
  }

  it('renders program manager slot', () => {
    render(<ToolbarView {...defaultProps} />)
    expect(screen.getByTestId('program-manager')).toBeInTheDocument()
  })

  it('renders output format select', () => {
    render(<ToolbarView {...defaultProps} />)
    expect(screen.getByText('Output:')).toBeInTheDocument()
  })

  it('renders run controls', () => {
    render(<ToolbarView {...defaultProps} />)
    expect(screen.getByRole('button', { name: /run/i })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /reset/i })).toBeInTheDocument()
  })

  it('renders view mode select', () => {
    render(<ToolbarView {...defaultProps} />)
    expect(screen.getByText('View:')).toBeInTheDocument()
  })

  it('has toolbar class', () => {
    const { container } = render(<ToolbarView {...defaultProps} />)
    expect(container.querySelector(`.${styles.toolbar}`)).toBeInTheDocument()
  })
})
