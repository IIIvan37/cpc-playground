import { GitHubLogoIcon } from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import styles from './auth-modal.module.css'

// ============================================================================
// Types
// ============================================================================

export type AuthMode = 'signin' | 'signup'

export type AuthModalViewProps = Readonly<{
  mode: AuthMode
  email: string
  password: string
  error: string | null
  loading: boolean
  onClose: () => void
  onEmailChange: (value: string) => void
  onPasswordChange: (value: string) => void
  onSubmit: (e: React.FormEvent) => void
  onGithubAuth: () => void
  onModeChange: (mode: AuthMode) => void
}>

// ============================================================================
// View Component
// ============================================================================

export function AuthModalView({
  mode,
  email,
  password,
  error,
  loading,
  onClose,
  onEmailChange,
  onPasswordChange,
  onSubmit,
  onGithubAuth,
  onModeChange
}: AuthModalViewProps) {
  return (
    <Modal
      open={true}
      onClose={onClose}
      title={mode === 'signin' ? 'Sign In' : 'Sign Up'}
    >
      <form onSubmit={onSubmit} className={styles.form}>
        {error && <div className={styles.error}>{error}</div>}

        <Input
          label='Email'
          id='email'
          type='email'
          value={email}
          onChange={(e) => onEmailChange(e.target.value)}
          required
          disabled={loading}
        />

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

        <Button type='submit' disabled={loading} fullWidth>
          {loading ? 'Loading...' : mode === 'signin' ? 'Sign In' : 'Sign Up'}
        </Button>

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

        <div className={styles.toggle}>
          {mode === 'signin' ? (
            <>
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
          ) : (
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
        </div>
      </form>
    </Modal>
  )
}
