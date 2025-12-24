import { fireEvent, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { AuthModalView, type AuthMode } from './auth-modal.view'

describe('AuthModalView', () => {
  const createDefaultProps = () => ({
    mode: 'signin' as AuthMode,
    email: '',
    password: '',
    error: null,
    successMessage: null,
    loading: false,
    onClose: vi.fn(),
    onEmailChange: vi.fn(),
    onPasswordChange: vi.fn(),
    onSubmit: vi.fn(),
    onGithubAuth: vi.fn(),
    onModeChange: vi.fn()
  })

  // Keep for backwards compatibility in simple render tests
  const defaultProps = createDefaultProps()

  describe('rendering', () => {
    it('renders modal with Sign In title', () => {
      render(<AuthModalView {...defaultProps} mode='signin' />)
      expect(
        screen.getByRole('heading', { name: 'Sign In' })
      ).toBeInTheDocument()
    })

    it('renders modal with Sign Up title', () => {
      render(<AuthModalView {...defaultProps} mode='signup' />)
      expect(
        screen.getByRole('heading', { name: 'Sign Up' })
      ).toBeInTheDocument()
    })

    it('renders modal with Reset Password title', () => {
      render(<AuthModalView {...defaultProps} mode='forgot-password' />)
      expect(
        screen.getByRole('heading', { name: 'Reset Password' })
      ).toBeInTheDocument()
    })

    it('renders email input', () => {
      render(<AuthModalView {...defaultProps} />)
      expect(screen.getByLabelText('Email')).toBeInTheDocument()
    })

    it('renders password input for signin mode', () => {
      render(<AuthModalView {...defaultProps} mode='signin' />)
      expect(screen.getByLabelText('Password')).toBeInTheDocument()
    })

    it('renders password input for signup mode', () => {
      render(<AuthModalView {...defaultProps} mode='signup' />)
      expect(screen.getByLabelText('Password')).toBeInTheDocument()
    })

    it('does not render password input for forgot-password mode', () => {
      render(<AuthModalView {...defaultProps} mode='forgot-password' />)
      expect(screen.queryByLabelText('Password')).not.toBeInTheDocument()
    })

    it('renders GitHub auth button for signin mode', () => {
      render(<AuthModalView {...defaultProps} mode='signin' />)
      expect(
        screen.getByRole('button', { name: /github/i })
      ).toBeInTheDocument()
    })

    it('does not render GitHub auth button for forgot-password mode', () => {
      render(<AuthModalView {...defaultProps} mode='forgot-password' />)
      expect(
        screen.queryByRole('button', { name: /github/i })
      ).not.toBeInTheDocument()
    })
  })

  describe('form values', () => {
    it('displays email value', () => {
      render(<AuthModalView {...defaultProps} email='test@example.com' />)
      expect(screen.getByLabelText('Email')).toHaveValue('test@example.com')
    })

    it('displays password value', () => {
      render(<AuthModalView {...defaultProps} password='secret123' />)
      expect(screen.getByLabelText('Password')).toHaveValue('secret123')
    })
  })

  describe('messages', () => {
    it('displays error message', () => {
      render(<AuthModalView {...defaultProps} error='Invalid credentials' />)
      expect(screen.getByText('Invalid credentials')).toBeInTheDocument()
    })

    it('displays success message', () => {
      render(
        <AuthModalView
          {...defaultProps}
          successMessage='Check your email for reset link'
        />
      )
      expect(
        screen.getByText('Check your email for reset link')
      ).toBeInTheDocument()
    })
  })

  describe('loading state', () => {
    it('shows Loading text when loading', () => {
      render(<AuthModalView {...defaultProps} loading={true} />)
      expect(screen.getByText('Loading...')).toBeInTheDocument()
    })

    it('disables inputs when loading', () => {
      render(<AuthModalView {...defaultProps} loading={true} />)
      expect(screen.getByLabelText('Email')).toBeDisabled()
      expect(screen.getByLabelText('Password')).toBeDisabled()
    })

    it('disables submit button when loading', () => {
      render(<AuthModalView {...defaultProps} loading={true} />)
      expect(screen.getByRole('button', { name: /loading/i })).toBeDisabled()
    })
  })

  describe('interactions', () => {
    it('calls onEmailChange when email is typed', async () => {
      const user = userEvent.setup()
      const props = createDefaultProps()
      render(<AuthModalView {...props} />)

      await user.type(screen.getByLabelText('Email'), 'test@example.com')

      expect(props.onEmailChange).toHaveBeenCalled()
    })

    it('calls onPasswordChange when password is typed', async () => {
      const props = createDefaultProps()
      render(<AuthModalView {...props} />)

      // Use fireEvent for controlled input that doesn't update state
      fireEvent.change(screen.getByLabelText('Password'), {
        target: { value: 'password' }
      })

      expect(props.onPasswordChange).toHaveBeenCalledWith('password')
    })

    it('calls onSubmit when form is submitted', async () => {
      const user = userEvent.setup()
      const handleSubmit = vi.fn((e) => e.preventDefault())
      render(
        <AuthModalView
          {...defaultProps}
          email='test@example.com'
          password='password123'
          onSubmit={handleSubmit}
        />
      )

      await user.click(screen.getByRole('button', { name: 'Sign In' }))

      expect(handleSubmit).toHaveBeenCalledTimes(1)
    })

    it('calls onGithubAuth when GitHub button is clicked', async () => {
      const user = userEvent.setup()
      const handleGithubAuth = vi.fn()
      render(
        <AuthModalView {...defaultProps} onGithubAuth={handleGithubAuth} />
      )

      await user.click(screen.getByRole('button', { name: /github/i }))

      expect(handleGithubAuth).toHaveBeenCalledTimes(1)
    })

    it('calls onModeChange when switching to signup', async () => {
      const user = userEvent.setup()
      const handleModeChange = vi.fn()
      render(
        <AuthModalView {...defaultProps} onModeChange={handleModeChange} />
      )

      await user.click(screen.getByRole('button', { name: /sign up/i }))

      expect(handleModeChange).toHaveBeenCalledWith('signup')
    })

    it('calls onModeChange when switching to forgot password', async () => {
      const user = userEvent.setup()
      const handleModeChange = vi.fn()
      render(
        <AuthModalView
          {...defaultProps}
          mode='signin'
          onModeChange={handleModeChange}
        />
      )

      await user.click(screen.getByRole('button', { name: /forgot password/i }))

      expect(handleModeChange).toHaveBeenCalledWith('forgot-password')
    })
  })

  describe('submit button text', () => {
    it('shows Sign In for signin mode', () => {
      render(<AuthModalView {...defaultProps} mode='signin' />)
      expect(
        screen.getByRole('button', { name: 'Sign In' })
      ).toBeInTheDocument()
    })

    it('shows Sign Up for signup mode', () => {
      render(<AuthModalView {...defaultProps} mode='signup' />)
      expect(
        screen.getByRole('button', { name: 'Sign Up' })
      ).toBeInTheDocument()
    })

    it('shows Send Reset Link for forgot-password mode', () => {
      render(<AuthModalView {...defaultProps} mode='forgot-password' />)
      expect(
        screen.getByRole('button', { name: 'Send Reset Link' })
      ).toBeInTheDocument()
    })
  })
})
