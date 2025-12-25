import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '@/hooks'
import {
  ResetPasswordFormView,
  ResetPasswordLoadingView,
  ResetPasswordSuccessView
} from './reset-password.view'

/**
 * Reset Password Page Container
 * Handles the password reset callback from Supabase.
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

  const { updatePassword, hasSession, onPasswordRecovery } = useAuth()
  const navigate = useNavigate()

  // Listen for the PASSWORD_RECOVERY event
  useEffect(() => {
    const unsubscribe = onPasswordRecovery(() => {
      setSessionReady(true)
    })

    // Check if we already have a session (user might have refreshed the page)
    hasSession().then((hasActiveSession) => {
      if (hasActiveSession) {
        setSessionReady(true)
      }
    })

    return unsubscribe
  }, [onPasswordRecovery, hasSession])

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
    return <ResetPasswordLoadingView />
  }

  if (success) {
    return <ResetPasswordSuccessView />
  }

  return (
    <ResetPasswordFormView
      password={password}
      confirmPassword={confirmPassword}
      error={error}
      loading={loading}
      onPasswordChange={setPassword}
      onConfirmPasswordChange={setConfirmPassword}
      onSubmit={handleSubmit}
    />
  )
}
