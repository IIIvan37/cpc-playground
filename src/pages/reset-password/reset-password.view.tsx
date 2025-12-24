import { Link } from 'react-router-dom'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import styles from './reset-password.module.css'

type ResetPasswordViewProps = Readonly<{
  password: string
  confirmPassword: string
  error: string | null
  loading: boolean
  onPasswordChange: (value: string) => void
  onConfirmPasswordChange: (value: string) => void
  onSubmit: (e: React.FormEvent) => void
}>

/**
 * Loading state view - shown while waiting for session
 */
export function ResetPasswordLoadingView() {
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

/**
 * Success state view - shown after password update
 */
export function ResetPasswordSuccessView() {
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

/**
 * Form view - main password reset form
 */
export function ResetPasswordFormView({
  password,
  confirmPassword,
  error,
  loading,
  onPasswordChange,
  onConfirmPasswordChange,
  onSubmit
}: ResetPasswordViewProps) {
  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <h1 className={styles.title}>Reset Password</h1>
        <p className={styles.subtitle}>Enter your new password below</p>

        <form onSubmit={onSubmit} className={styles.form}>
          {error && <div className={styles.error}>{error}</div>}

          <Input
            label='New Password'
            id='password'
            type='password'
            value={password}
            onChange={(e) => onPasswordChange(e.target.value)}
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
            onChange={(e) => onConfirmPasswordChange(e.target.value)}
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
