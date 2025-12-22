import { useState } from 'react'
import { useAuth } from '@/hooks/use-auth'
import { AuthModalView, type AuthMode } from './auth-modal.view'

interface AuthModalProps {
  onClose: () => void
}

/**
 * Container component for authentication modal
 * Handles business logic and delegates rendering to AuthModalView
 */
export function AuthModal({ onClose }: AuthModalProps) {
  const [mode, setMode] = useState<AuthMode>('signin')
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
    <AuthModalView
      mode={mode}
      email={email}
      password={password}
      error={error}
      loading={loading}
      onClose={onClose}
      onEmailChange={setEmail}
      onPasswordChange={setPassword}
      onSubmit={handleSubmit}
      onGithubAuth={handleGithub}
      onModeChange={setMode}
    />
  )
}
