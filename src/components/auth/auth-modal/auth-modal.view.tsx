import { GitHubLogoIcon } from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import styles from './auth-modal.module.css'

// ============================================================================
// Types
// ============================================================================

export type AuthMode = 'signin' | 'signup' | 'forgot-password'

export type AuthModalViewProps = Readonly<{
  mode: AuthMode
  email: string
  password: string
  error: string | null
  successMessage: string | null
  loading: boolean
  onClose: () => void
  onEmailChange: (value: string) => void
  onPasswordChange: (value: string) => void
  onSubmit: (e: React.FormEvent) => void
  onGithubAuth: () => void
  onModeChange: (mode: AuthMode) => void
}>

// ============================================================================
// Helper function
// ============================================================================

function getModalTitle(mode: AuthMode): string {
  switch (mode) {
    case 'signin':
      return 'Sign In'
    case 'signup':
      return 'Sign Up'
    case 'forgot-password':
      return 'Reset Password'
  }
}

// ============================================================================
// View Component
// ============================================================================

export function AuthModalView({
  mode,
  email,
  password,
  error,
  successMessage,
  loading,
  onClose,
  onEmailChange,
  onPasswordChange,
  onSubmit,
  onGithubAuth,
  onModeChange
}: AuthModalViewProps) {
  return (
    <Modal open={true} onClose={onClose} title={getModalTitle(mode)}>
      <form onSubmit={onSubmit} className={styles.form}>
        {error && <div className={styles.error}>{error}</div>}
        {successMessage && (
          <div className={styles.success}>{successMessage}</div>
        )}

        <Input
          label='Email'
          id='email'
          type='email'
          value={email}
          onChange={(e) => onEmailChange(e.target.value)}
          required
          disabled={loading}
        />

        {mode !== 'forgot-password' && (
          <Input
            label='Password'
            id='password'
            type='password'
            value={password}
            onChange={(e) => onPasswordChange(e.target.value)}
            required
            minLength={6}
            disabled={loading}
          />
        )}

        <Button type='submit' disabled={loading} fullWidth>
          {loading && 'Loading...'}
          {!loading && mode === 'signin' && 'Sign In'}
          {!loading && mode === 'signup' && 'Sign Up'}
          {!loading && mode === 'forgot-password' && 'Send Reset Link'}
        </Button>

        {mode !== 'forgot-password' && (
          <>
            <div className={styles.divider}>
              <span>or</span>
            </div>

            <Button
              type='button'
              variant='outline'
              onClick={onGithubAuth}
              disabled={loading}
              fullWidth
            >
              <GitHubLogoIcon />
              Continue with GitHub
            </Button>
          </>
        )}

        <div className={styles.toggle}>
          {mode === 'signin' && (
            <>
              <Button
                type='button'
                variant='link'
                onClick={() => onModeChange('forgot-password')}
                disabled={loading}
              >
                Forgot password?
              </Button>
              <span className={styles.toggleSeparator}>·</span>
              Don't have an account?{' '}
              <Button
                type='button'
                variant='link'
                onClick={() => onModeChange('signup')}
                disabled={loading}
              >
                Sign up
              </Button>
            </>
          )}
          {mode === 'signup' && (
            <>
              Already have an account?{' '}
              <Button
                type='button'
                variant='link'
                onClick={() => onModeChange('signin')}
                disabled={loading}
              >
                Sign in
              </Button>
            </>
          )}
          {mode === 'forgot-password' && (
            <>
              Remember your password?{' '}
              <Button
                type='button'
                variant='link'
                onClick={() => onModeChange('signin')}
                disabled={loading}
              >
                Sign in
              </Button>
            </>
          )}
        </div>
      </form>
    </Modal>
  )
}
