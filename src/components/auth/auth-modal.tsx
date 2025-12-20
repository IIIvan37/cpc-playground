import { GitHubLogoIcon } from '@radix-ui/react-icons'
import { useState } from 'react'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { useAuth } from '@/hooks/use-auth'
import styles from './auth-modal.module.css'

interface AuthModalProps {
  onClose: () => void
}

export function AuthModal({ onClose }: AuthModalProps) {
  const [mode, setMode] = useState<'signin' | 'signup'>('signin')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  const { signIn, signUp, signInWithGithub } = useAuth()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const { error } =
        mode === 'signin'
          ? await signIn(email, password)
          : await signUp(email, password)

      if (error) {
        setError(error.message)
      } else {
        if (mode === 'signup') {
          setError('Check your email to confirm your account')
        } else {
          onClose()
        }
      }
    } finally {
      setLoading(false)
    }
  }

  const handleGithub = async () => {
    setError(null)
    setLoading(true)
    const { error } = await signInWithGithub()
    if (error) {
      setError(error.message)
      setLoading(false)
    }
    // OAuth will redirect, so no need to handle success
  }

  return (
    <div className={styles.overlay} onClick={onClose}>
      <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        <div className={styles.header}>
          <h2>{mode === 'signin' ? 'Sign In' : 'Sign Up'}</h2>
          <Button
            type='button'
            variant='icon'
            className={styles.closeButton}
            onClick={onClose}
            aria-label='Close'
          >
            ×
          </Button>
        </div>

        <form onSubmit={handleSubmit} className={styles.form}>
          {error && <div className={styles.error}>{error}</div>}

          <Input
            label='Email'
            id='email'
            type='email'
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            disabled={loading}
          />

          <Input
            label='Password'
            id='password'
            type='password'
            value={password}
            onChange={(e) => setPassword(e.target.value)}
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
            onClick={handleGithub}
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
                  onClick={() => setMode('signup')}
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
                  onClick={() => setMode('signin')}
                  disabled={loading}
                >
                  Sign in
                </Button>
              </>
            )}
          </div>
        </form>
      </div>
    </div>
  )
}
