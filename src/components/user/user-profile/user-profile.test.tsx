import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createStore, Provider } from 'jotai'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { User } from '@/domain/entities/user.entity'
import { userAtom } from '@/hooks'
import { UserProfile } from './user-profile'

// Mock hooks
const mockSignOut = vi.fn()
const mockUpdateUsername = vi.fn().mockResolvedValue(undefined)
const mockConfirm = vi.fn()

vi.mock('@/hooks', async () => {
  const actual = await vi.importActual('@/hooks')
  return {
    ...actual,
    useAuth: () => ({
      signOut: mockSignOut
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
    useUserProfile: () => ({
      profile: { username: 'testuser' },
      loading: false,
      updateUsername: mockUpdateUsername
    })
  }
})

const mockUser: User = {
  id: 'user-123',
  email: 'test@example.com',
  profile: {
    id: 'profile-123',
    username: 'testuser',
    createdAt: new Date(),
    updatedAt: new Date()
  }
}

function renderWithStore(user: User | null = mockUser) {
  const store = createStore()
  store.set(userAtom, user)

  return {
    store,
    ...render(
      <Provider store={store}>
        <UserProfile />
      </Provider>
    )
  }
}

describe('UserProfile', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mockSignOut.mockResolvedValue({ error: null })
    mockUpdateUsername.mockResolvedValue(undefined)
    mockConfirm.mockResolvedValue(true)
  })

  describe('rendering', () => {
    it('renders nothing when user is null', () => {
      const { container } = renderWithStore(null)
      expect(container).toBeEmptyDOMElement()
    })

    it('renders user profile button when user is logged in', () => {
      renderWithStore()
      expect(
        screen.getByRole('button', { name: /testuser/i })
      ).toBeInTheDocument()
    })

    it('displays user email in modal', async () => {
      const user = userEvent.setup()
      renderWithStore()

      await user.click(screen.getByRole('button', { name: /testuser/i }))

      expect(screen.getByText('test@example.com')).toBeInTheDocument()
    })
  })

  describe('sign out', () => {
    it('calls signOut when confirmed', async () => {
      const user = userEvent.setup()
      renderWithStore()

      // Open modal first
      await user.click(screen.getByRole('button', { name: /testuser/i }))
      // Then click sign out
      await user.click(screen.getByRole('button', { name: /sign out/i }))

      expect(mockConfirm).toHaveBeenCalled()
      expect(mockSignOut).toHaveBeenCalled()
    })

    it('does not call signOut when cancelled', async () => {
      mockConfirm.mockResolvedValue(false)
      const user = userEvent.setup()
      renderWithStore()

      // Open modal first
      await user.click(screen.getByRole('button', { name: /testuser/i }))
      await user.click(screen.getByRole('button', { name: /sign out/i }))

      expect(mockSignOut).not.toHaveBeenCalled()
    })
  })

  describe('username editing', () => {
    it('opens modal with current username', async () => {
      const user = userEvent.setup()
      renderWithStore()

      // Click the profile button to open modal
      await user.click(screen.getByRole('button', { name: /testuser/i }))

      expect(screen.getByRole('dialog')).toBeInTheDocument()
      expect(screen.getByDisplayValue('testuser')).toBeInTheDocument()
    })

    it('closes modal on close button', async () => {
      const user = userEvent.setup()
      renderWithStore()

      await user.click(screen.getByRole('button', { name: /testuser/i }))
      expect(screen.getByRole('dialog')).toBeInTheDocument()

      // Find close button in modal header
      const closeButton = screen.getByRole('button', { name: /close/i })
      await user.click(closeButton)

      await waitFor(() => {
        expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
      })
    })

    it('calls updateUsername with new value on save', async () => {
      const user = userEvent.setup()
      renderWithStore()

      await user.click(screen.getByRole('button', { name: /testuser/i }))

      const input = screen.getByDisplayValue('testuser')
      await user.clear(input)
      await user.type(input, 'newusername')

      await user.click(screen.getByRole('button', { name: /save username/i }))

      await waitFor(() => {
        expect(mockUpdateUsername).toHaveBeenCalledWith('newusername')
      })
    })

    it('closes modal after successful save', async () => {
      const user = userEvent.setup()
      renderWithStore()

      await user.click(screen.getByRole('button', { name: /testuser/i }))

      const input = screen.getByDisplayValue('testuser')
      await user.clear(input)
      await user.type(input, 'newusername')

      await user.click(screen.getByRole('button', { name: /save username/i }))

      // Wait for updateUsername to be called, then check modal closes
      await waitFor(() => {
        expect(mockUpdateUsername).toHaveBeenCalledWith('newusername')
      })

      await waitFor(
        () => {
          expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
        },
        { timeout: 2000 }
      )
    })

    it('does not save empty username', async () => {
      const user = userEvent.setup()
      renderWithStore()

      await user.click(screen.getByRole('button', { name: /testuser/i }))

      const input = screen.getByDisplayValue('testuser')
      await user.clear(input)

      await user.click(screen.getByRole('button', { name: /save username/i }))

      expect(mockUpdateUsername).not.toHaveBeenCalled()
    })
  })
})
