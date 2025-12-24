import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { useAuth } from '@/hooks'
import { supabase } from '@/lib/supabase'
import styles from './reset-password.module.css'

/**
 * Reset Password Page
 * This page handles the password reset callback from Supabase.
 * When users click the reset link in their email, they are redirected here
 * with a token in the URL hash that Supabase uses to authenticate the session.
 */
export function ResetPasswordPage() {
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)
  const [loading, setLoading] = useState(false)
  const [sessionReady, setSessionReady] = useState(false)

  const { updatePassword } = useAuth()
  const navigate = useNavigate()

  // Listen for the PASSWORD_RECOVERY event from Supabase
  useEffect(() => {
    const {
      data: { subscription }
    } = supabase.auth.onAuthStateChange((event) => {
      if (event === 'PASSWORD_RECOVERY') {
        setSessionReady(true)
      }
    })

    // Check if we already have a session (user might have refreshed the page)
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        setSessionReady(true)
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)

    if (password !== confirmPassword) {
      setError('Passwords do not match')
      return
    }

    if (password.length < 6) {
      setError('Password must be at least 6 characters')
      return
    }

    setLoading(true)

    try {
      const { error } = await updatePassword(password)

      if (error) {
        setError(error.message)
      } else {
        setSuccess(true)
        // Redirect to home after 2 seconds
        setTimeout(() => {
          navigate('/')
        }, 2000)
      }
    } finally {
      setLoading(false)
    }
  }

  if (!sessionReady) {
    return (
      <div className={styles.container}>
        <div className={styles.card}>
          <div className={styles.loading}>
            <p>Loading...</p>
            <p>If this takes too long, the link may have expired.</p>
            <Link to='/' className={styles.homeLink}>
              Return to CPC Playground
            </Link>
          </div>
        </div>
      </div>
    )
  }

  if (success) {
    return (
      <div className={styles.container}>
        <div className={styles.card}>
          <h1 className={styles.title}>Password Updated!</h1>
          <p className={styles.success}>
            Your password has been successfully updated. Redirecting...
          </p>
          <Link to='/' className={styles.homeLink}>
            Return to CPC Playground
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <h1 className={styles.title}>Reset Password</h1>
        <p className={styles.subtitle}>Enter your new password below</p>

        <form onSubmit={handleSubmit} className={styles.form}>
          {error && <div className={styles.error}>{error}</div>}

          <Input
            label='New Password'
            id='password'
            type='password'
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            minLength={6}
            disabled={loading}
            autoFocus
          />

          <Input
            label='Confirm Password'
            id='confirmPassword'
            type='password'
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            required
            minLength={6}
            disabled={loading}
          />

          <Button type='submit' disabled={loading} fullWidth>
            {loading ? 'Updating...' : 'Update Password'}
          </Button>
        </form>

        <Link to='/' className={styles.homeLink}>
          Return to CPC Playground
        </Link>
      </div>
    </div>
  )
}
