import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { AuthModal } from './auth-modal'

// Mock useAuth hook
const mockSignIn = vi.fn()
const mockSignUp = vi.fn()
const mockSignInWithGithub = vi.fn()
const mockRequestPasswordReset = vi.fn()

vi.mock('@/hooks', () => ({
  useAuth: () => ({
    signIn: mockSignIn,
    signUp: mockSignUp,
    signInWithGithub: mockSignInWithGithub,
    requestPasswordReset: mockRequestPasswordReset
  })
}))

// Helper to fill form with fireEvent (works with controlled inputs)
function fillForm(email: string, password?: string) {
  fireEvent.change(screen.getByLabelText('Email'), {
    target: { value: email }
  })
  if (password) {
    fireEvent.change(screen.getByLabelText('Password'), {
      target: { value: password }
    })
  }
}

describe('AuthModal', () => {
  const defaultProps = {
    onClose: vi.fn()
  }

  beforeEach(() => {
    vi.clearAllMocks()
    mockSignIn.mockResolvedValue({ error: null })
    mockSignUp.mockResolvedValue({ error: null })
    mockSignInWithGithub.mockResolvedValue({ error: null })
    mockRequestPasswordReset.mockResolvedValue({ error: null })
  })

  describe('rendering', () => {
    it('renders sign in mode by default', () => {
      render(<AuthModal {...defaultProps} />)

      expect(
        screen.getByRole('heading', { name: 'Sign In' })
      ).toBeInTheDocument()
    })
  })

  describe('sign in flow', () => {
    it('calls signIn with email and password', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      fillForm('test@example.com', 'password123')
      await user.click(screen.getByRole('button', { name: 'Sign In' }))

      await waitFor(() => {
        expect(mockSignIn).toHaveBeenCalledWith(
          'test@example.com',
          'password123'
        )
      })
    })

    it('calls onClose on successful sign in', async () => {
      const user = userEvent.setup()
      const onClose = vi.fn()
      render(<AuthModal onClose={onClose} />)

      fillForm('test@example.com', 'password123')
      await user.click(screen.getByRole('button', { name: 'Sign In' }))

      await waitFor(() => {
        expect(onClose).toHaveBeenCalled()
      })
    })

    it('displays error on sign in failure', async () => {
      mockSignIn.mockResolvedValue({
        error: { message: 'Invalid credentials' }
      })
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      fillForm('test@example.com', 'wrongpassword')
      await user.click(screen.getByRole('button', { name: 'Sign In' }))

      await waitFor(() => {
        expect(screen.getByText('Invalid credentials')).toBeInTheDocument()
      })
    })
  })

  describe('sign up flow', () => {
    it('switches to sign up mode and calls signUp', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      // Switch to sign up mode - look for the link button "Sign up"
      const signUpLinks = screen.getAllByRole('button', { name: /sign up/i })
      // The link is the one in the toggle section (last one)
      await user.click(signUpLinks[signUpLinks.length - 1])

      expect(
        screen.getByRole('heading', { name: 'Sign Up' })
      ).toBeInTheDocument()

      fillForm('new@example.com', 'newpassword')
      await user.click(screen.getByRole('button', { name: 'Sign Up' }))

      await waitFor(() => {
        expect(mockSignUp).toHaveBeenCalledWith(
          'new@example.com',
          'newpassword'
        )
      })
    })

    it('shows success message on sign up', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      const signUpLinks = screen.getAllByRole('button', { name: /sign up/i })
      await user.click(signUpLinks[signUpLinks.length - 1])
      fillForm('new@example.com', 'newpassword')
      await user.click(screen.getByRole('button', { name: 'Sign Up' }))

      await waitFor(() => {
        expect(
          screen.getByText(/check your email to confirm/i)
        ).toBeInTheDocument()
      })
    })

    it('displays error on sign up failure', async () => {
      mockSignUp.mockResolvedValue({
        error: { message: 'Email already exists' }
      })
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      const signUpLinks = screen.getAllByRole('button', { name: /sign up/i })
      await user.click(signUpLinks[signUpLinks.length - 1])
      fillForm('existing@example.com', 'password123')
      await user.click(screen.getByRole('button', { name: 'Sign Up' }))

      await waitFor(() => {
        expect(screen.getByText('Email already exists')).toBeInTheDocument()
      })
    })
  })

  describe('forgot password flow', () => {
    it('switches to forgot password mode', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      await user.click(screen.getByText(/forgot password/i))

      expect(
        screen.getByRole('heading', { name: 'Reset Password' })
      ).toBeInTheDocument()
    })

    it('calls requestPasswordReset with email', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      await user.click(screen.getByText(/forgot password/i))
      fillForm('reset@example.com')
      await user.click(screen.getByRole('button', { name: 'Send Reset Link' }))

      await waitFor(() => {
        expect(mockRequestPasswordReset).toHaveBeenCalledWith(
          'reset@example.com'
        )
      })
    })

    it('shows success message on password reset request', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      await user.click(screen.getByText(/forgot password/i))
      fillForm('reset@example.com')
      await user.click(screen.getByRole('button', { name: 'Send Reset Link' }))

      await waitFor(() => {
        expect(
          screen.getByText(/check your email for a password reset link/i)
        ).toBeInTheDocument()
      })
    })
  })

  describe('github auth', () => {
    it('calls signInWithGithub when GitHub button is clicked', async () => {
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      await user.click(screen.getByRole('button', { name: /github/i }))

      await waitFor(() => {
        expect(mockSignInWithGithub).toHaveBeenCalled()
      })
    })

    it('displays error on GitHub auth failure', async () => {
      mockSignInWithGithub.mockResolvedValue({
        error: { message: 'GitHub auth failed' }
      })
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      await user.click(screen.getByRole('button', { name: /github/i }))

      await waitFor(() => {
        expect(screen.getByText('GitHub auth failed')).toBeInTheDocument()
      })
    })
  })

  describe('mode switching', () => {
    it('clears error when switching modes', async () => {
      mockSignIn.mockResolvedValue({ error: { message: 'Some error' } })
      const user = userEvent.setup()
      render(<AuthModal {...defaultProps} />)

      // Trigger an error
      fillForm('test@example.com', 'password')
      await user.click(screen.getByRole('button', { name: 'Sign In' }))

      await waitFor(() => {
        expect(screen.getByText('Some error')).toBeInTheDocument()
      })

      // Switch mode - click the Sign up link
      const signUpLinks = screen.getAllByRole('button', { name: /sign up/i })
      await user.click(signUpLinks[signUpLinks.length - 1])

      // Error should be cleared
      expect(screen.queryByText('Some error')).not.toBeInTheDocument()
    })
  })
})
