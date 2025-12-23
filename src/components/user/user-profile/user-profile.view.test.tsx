import { fireEvent, render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import { UserProfileView } from './user-profile.view'

describe('UserProfileView', () => {
  const defaultProps = {
    username: 'testuser',
    email: 'test@example.com',
    userId: '12345678-abcd-1234-abcd-123456789012',
    loading: false,
    saving: false,
    modalOpen: false,
    newUsername: '',
    onOpenModal: vi.fn(),
    onCloseModal: vi.fn(),
    onUsernameChange: vi.fn(),
    onSaveUsername: vi.fn(),
    onSignOut: vi.fn()
  }

  it('should render profile button with username', () => {
    render(<UserProfileView {...defaultProps} />)

    expect(screen.getByText('testuser')).toBeInTheDocument()
  })

  it('should show loading state', () => {
    render(<UserProfileView {...defaultProps} loading={true} />)

    expect(screen.getByText('...')).toBeInTheDocument()
  })

  it('should show "User" when no username', () => {
    render(<UserProfileView {...defaultProps} username='' />)

    expect(screen.getByText('User')).toBeInTheDocument()
  })

  it('should call onOpenModal when profile button clicked', () => {
    const onOpenModal = vi.fn()
    render(<UserProfileView {...defaultProps} onOpenModal={onOpenModal} />)

    fireEvent.click(screen.getByRole('button'))

    expect(onOpenModal).toHaveBeenCalled()
  })

  it('should render modal when open', () => {
    render(<UserProfileView {...defaultProps} modalOpen={true} />)

    expect(screen.getByText('User Profile')).toBeInTheDocument()
    expect(screen.getByText('test@example.com')).toBeInTheDocument()
    expect(screen.getByText('12345678...')).toBeInTheDocument()
  })

  it('should show username input in modal', () => {
    render(
      <UserProfileView
        {...defaultProps}
        modalOpen={true}
        newUsername='newname'
      />
    )

    const input = screen.getByLabelText('Username') as HTMLInputElement
    expect(input.value).toBe('newname')
  })

  it('should call onUsernameChange when input changes', () => {
    const onUsernameChange = vi.fn()
    render(
      <UserProfileView
        {...defaultProps}
        modalOpen={true}
        onUsernameChange={onUsernameChange}
      />
    )

    fireEvent.change(screen.getByLabelText('Username'), {
      target: { value: 'updated' }
    })

    expect(onUsernameChange).toHaveBeenCalledWith('updated')
  })

  it('should call onSaveUsername when save button clicked', () => {
    const onSaveUsername = vi.fn()
    render(
      <UserProfileView
        {...defaultProps}
        modalOpen={true}
        onSaveUsername={onSaveUsername}
      />
    )

    fireEvent.click(screen.getByText('Save Username'))

    expect(onSaveUsername).toHaveBeenCalled()
  })

  it('should show saving state on button', () => {
    render(<UserProfileView {...defaultProps} modalOpen={true} saving={true} />)

    expect(screen.getByText('Saving...')).toBeInTheDocument()
  })

  it('should disable buttons when saving', () => {
    render(<UserProfileView {...defaultProps} modalOpen={true} saving={true} />)

    expect(screen.getByText('Saving...')).toBeDisabled()
    expect(screen.getByText('Sign Out')).toBeDisabled()
  })

  it('should call onSignOut when sign out button clicked', () => {
    const onSignOut = vi.fn()
    render(
      <UserProfileView
        {...defaultProps}
        modalOpen={true}
        onSignOut={onSignOut}
      />
    )

    fireEvent.click(screen.getByText('Sign Out'))

    expect(onSignOut).toHaveBeenCalled()
  })
})
