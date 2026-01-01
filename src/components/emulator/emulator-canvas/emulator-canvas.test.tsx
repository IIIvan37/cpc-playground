import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { useAuth, useCurrentProject, useEmulator } from '@/hooks'
import { EmulatorCanvas } from './emulator-canvas'

// Mock the custom hooks
const mockInitialize = vi.fn()
const mockLoadSna = vi.fn()
const mockLoadDsk = vi.fn()
const mockInjectDsk = vi.fn()
const mockIsInjectAvailable = vi.fn()
const mockSetKeyboardLayout = vi.fn()
const mockReset = vi.fn()
const mockSaveThumbnail = vi.fn()
const mockUser = { id: 'user-1', email: 'user@example.com' }
const mockProject = createProject({
  id: 'project-1',
  userId: 'user-1',
  name: createProjectName('Test Project'),
  visibility: Visibility.PRIVATE
})

vi.mock('@/hooks', () => ({
  useEmulator: vi.fn(() => ({
    isReady: true,
    isRunning: false,
    initialize: mockInitialize,
    loadSna: mockLoadSna,
    loadDsk: mockLoadDsk,
    injectDsk: mockInjectDsk,
    isInjectAvailable: mockIsInjectAvailable,
    setKeyboardLayout: mockSetKeyboardLayout,
    reset: mockReset
  })),
  useAuth: vi.fn(() => ({
    user: mockUser,
    loading: false,
    signIn: vi.fn(),
    signUp: vi.fn(),
    signOut: vi.fn(),
    signInWithGithub: vi.fn(),
    requestPasswordReset: vi.fn(),
    updatePassword: vi.fn(),
    hasSession: vi.fn(),
    onPasswordRecovery: vi.fn()
  })),
  useCurrentProject: vi.fn(() => ({
    project: mockProject,
    isLoading: false,
    isError: false,
    error: null,
    refetch: vi.fn()
  })),
  useSaveThumbnail: vi.fn(() => ({
    saveThumbnail: mockSaveThumbnail,
    loading: false
  }))
}))

// Mock the keyboard patch
vi.mock('@/lib/cpcec-keyboard-patch', () => ({
  setCpcecKeyboardEnabled: vi.fn()
}))

// Mock globalThis.Module for CPCEC
const mockModule = {
  _em_key_press: vi.fn(),
  _em_key_release: vi.fn(),
  _em_press_fn: vi.fn(),
  _em_release_fn: vi.fn()
}

Object.defineProperty(globalThis, 'Module', {
  value: mockModule,
  writable: true
})

// Mock URL and location
const mockLocation = {
  href: 'http://localhost:3000',
  search: ''
}

Object.defineProperty(globalThis, 'location', {
  value: mockLocation,
  writable: true
})

describe('EmulatorCanvas', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    // Reset the persistent canvas
    const canvas = document.querySelector('canvas')
    if (canvas) {
      canvas.remove()
    }
    // Reset global state
    ;(globalThis as any).emulatorHasFocus = false
  })

  it('renders the emulator canvas container', () => {
    render(<EmulatorCanvas />)

    expect(screen.getByText('CPC Emulator')).toBeInTheDocument()
    expect(screen.getByText('○ Click to type')).toBeInTheDocument()
    expect(
      screen.getByRole('button', { name: /save as project thumbnail/i })
    ).toBeInTheDocument()
  })

  it('shows loading state when emulator is not ready', () => {
    // Temporarily change the mock return value
    const mockedUseEmulator = vi.mocked(useEmulator)
    mockedUseEmulator.mockReturnValue({
      isReady: false,
      isRunning: false,
      initialize: mockInitialize,
      loadSna: mockLoadSna,
      loadDsk: mockLoadDsk,
      injectDsk: mockInjectDsk,
      isInjectAvailable: mockIsInjectAvailable,
      setKeyboardLayout: mockSetKeyboardLayout,
      reset: mockReset
    })

    render(<EmulatorCanvas />)

    expect(screen.getByText('○ Loading...')).toBeInTheDocument()

    // Reset mock
    mockedUseEmulator.mockReturnValue({
      isReady: true,
      isRunning: false,
      initialize: mockInitialize,
      loadSna: mockLoadSna,
      loadDsk: mockLoadDsk,
      injectDsk: mockInjectDsk,
      isInjectAvailable: mockIsInjectAvailable,
      setKeyboardLayout: mockSetKeyboardLayout,
      reset: mockReset
    })
  })

  it('initializes emulator when not ready', () => {
    // Temporarily change the mock return value
    const mockedUseEmulator = vi.mocked(useEmulator)
    mockedUseEmulator.mockReturnValue({
      isReady: false,
      isRunning: false,
      initialize: mockInitialize,
      loadSna: mockLoadSna,
      loadDsk: mockLoadDsk,
      injectDsk: mockInjectDsk,
      isInjectAvailable: mockIsInjectAvailable,
      setKeyboardLayout: mockSetKeyboardLayout,
      reset: mockReset
    })

    render(<EmulatorCanvas />)

    expect(mockInitialize).toHaveBeenCalled()

    // Reset mock
    mockedUseEmulator.mockReturnValue({
      isReady: true,
      isRunning: false,
      initialize: mockInitialize,
      loadSna: mockLoadSna,
      loadDsk: mockLoadDsk,
      injectDsk: mockInjectDsk,
      isInjectAvailable: mockIsInjectAvailable,
      setKeyboardLayout: mockSetKeyboardLayout,
      reset: mockReset
    })
  })

  it('shows inactive state when not focused', async () => {
    const user = userEvent.setup()
    render(<EmulatorCanvas />)

    const canvasWrapper = screen.getByTestId('canvas-wrapper')
    await user.click(canvasWrapper) // Focus
    await user.click(document.body) // Blur

    await waitFor(() => {
      expect(screen.getByText('○ Click to type')).toBeInTheDocument()
    })
  })

  it('calls saveThumbnail when screenshot button is clicked', async () => {
    const user = userEvent.setup()
    render(<EmulatorCanvas />)

    const screenshotButton = screen.getByRole('button', {
      name: /save as project thumbnail/i
    })
    await user.click(screenshotButton)

    expect(mockSaveThumbnail).toHaveBeenCalled()
  })

  it('does not show screenshot button when user cannot save thumbnail', () => {
    // Temporarily change the mocks
    const mockedUseAuth = vi.mocked(useAuth)
    const mockedUseCurrentProject = vi.mocked(useCurrentProject)

    mockedUseAuth.mockReturnValue({
      user: { id: 'user-1', email: 'user@example.com' },
      loading: false,
      signIn: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      signInWithGithub: vi.fn(),
      requestPasswordReset: vi.fn(),
      updatePassword: vi.fn(),
      hasSession: vi.fn(),
      onPasswordRecovery: vi.fn()
    })
    mockedUseCurrentProject.mockReturnValue({
      project: createProject({
        id: 'project-1',
        userId: 'user-2', // Different user
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE
      }),
      isLoading: false,
      isError: false,
      error: null,
      refetch: vi.fn()
    })

    render(<EmulatorCanvas />)

    expect(
      screen.queryByRole('button', { name: /save as project thumbnail/i })
    ).not.toBeInTheDocument()

    // Reset mocks
    mockedUseAuth.mockReturnValue({
      user: mockUser,
      loading: false,
      signIn: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      signInWithGithub: vi.fn(),
      requestPasswordReset: vi.fn(),
      updatePassword: vi.fn(),
      hasSession: vi.fn(),
      onPasswordRecovery: vi.fn()
    })
    mockedUseCurrentProject.mockReturnValue({
      project: mockProject,
      isLoading: false,
      isError: false,
      error: null,
      refetch: vi.fn()
    })
  })

  it('handles Control key press for CPC COPY when focused', () => {
    render(<EmulatorCanvas />)

    // Focus the emulator first
    const canvasWrapper = screen.getByTestId('canvas-wrapper')
    canvasWrapper.focus()

    // Simulate Control key press
    const ctrlEvent = new KeyboardEvent('keydown', {
      code: 'ControlLeft',
      altKey: false,
      shiftKey: false,
      ctrlKey: true,
      metaKey: false
    })
    document.dispatchEvent(ctrlEvent)

    expect(mockModule._em_key_press).toHaveBeenCalledWith(0x09)
  })

  it('handles Shift+F1-F10 key presses for CPC function keys when focused', () => {
    render(<EmulatorCanvas />)

    // Focus the emulator first
    const canvasWrapper = screen.getByTestId('canvas-wrapper')
    canvasWrapper.focus()

    // Simulate Shift+F1 key press
    const f1Event = new KeyboardEvent('keydown', {
      code: 'F1',
      shiftKey: true
    })
    document.dispatchEvent(f1Event)

    expect(mockModule._em_press_fn).toHaveBeenCalledWith(1)

    // Simulate Shift+F10 key press (should map to F0)
    const f10Event = new KeyboardEvent('keydown', {
      code: 'F10',
      shiftKey: true
    })
    document.dispatchEvent(f10Event)

    expect(mockModule._em_press_fn).toHaveBeenCalledWith(0)
  })

  it('handles key releases for Control and function keys when focused', () => {
    render(<EmulatorCanvas />)

    // Focus the emulator first
    const canvasWrapper = screen.getByTestId('canvas-wrapper')
    canvasWrapper.focus()

    // Simulate Control key release
    const ctrlReleaseEvent = new KeyboardEvent('keyup', {
      code: 'ControlLeft'
    })
    document.dispatchEvent(ctrlReleaseEvent)

    expect(mockModule._em_key_release).toHaveBeenCalledWith(0x09)

    // Simulate F1 key release
    const f1ReleaseEvent = new KeyboardEvent('keyup', {
      code: 'F1'
    })
    document.dispatchEvent(f1ReleaseEvent)

    expect(mockModule._em_release_fn).toHaveBeenCalledWith(1)
  })

  it('ignores keyboard events when emulator does not have focus', () => {
    render(<EmulatorCanvas />)

    // Focus the emulator first, then blur it
    const canvasWrapper = screen.getByTestId('canvas-wrapper')
    canvasWrapper.focus()
    canvasWrapper.blur()

    // Simulate Alt key press
    const altEvent = new KeyboardEvent('keydown', {
      code: 'AltLeft',
      altKey: true
    })
    document.dispatchEvent(altEvent)

    expect(mockModule._em_key_press).not.toHaveBeenCalled()
  })

  it('creates and reuses persistent canvas across renders', () => {
    const { rerender } = render(<EmulatorCanvas />)

    const firstCanvas = document.querySelector('canvas')
    expect(firstCanvas).toBeInTheDocument()

    // Unmount and remount
    rerender(<div />)
    rerender(<EmulatorCanvas />)

    const secondCanvas = document.querySelector('canvas')
    expect(secondCanvas).toBe(firstCanvas) // Should be the same canvas
  })

  it('applies correct CSS classes based on focus state', async () => {
    const user = userEvent.setup()
    render(<EmulatorCanvas />)

    const canvasWrapper = screen.getByTestId('canvas-wrapper')

    // Initially not focused - should not have focused class
    expect(canvasWrapper.className).not.toMatch(/focused/)

    // Focus
    await user.click(canvasWrapper)
    await waitFor(() => {
      expect(canvasWrapper.className).toMatch(/focused/)
    })

    // Blur
    await user.click(document.body)
    await waitFor(() => {
      expect(canvasWrapper.className).not.toMatch(/focused/)
    })
  })
})
