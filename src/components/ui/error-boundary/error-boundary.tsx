import { Component, type ErrorInfo, type ReactNode } from 'react'
import { createLogger } from '@/lib/logger'
import Button from '../button/button'
import styles from './error-boundary.module.css'

const logger = createLogger('ErrorBoundary')

function ErrorIcon() {
  return (
    <svg
      viewBox='0 0 24 24'
      fill='none'
      stroke='currentColor'
      strokeWidth='2'
      className={styles.icon}
      aria-hidden='true'
    >
      <circle cx='12' cy='12' r='10' />
      <line x1='12' y1='8' x2='12' y2='12' />
      <line x1='12' y1='16' x2='12.01' y2='16' />
    </svg>
  )
}

type FallbackProps = Readonly<{
  error: Error
  resetError: () => void
  fullPage?: boolean
}>

function DefaultFallback({ error, resetError, fullPage }: FallbackProps) {
  const isDev = import.meta.env.DEV

  return (
    <div
      className={`${styles.errorBoundary} ${fullPage ? styles.fullPage : ''}`}
    >
      <ErrorIcon />
      <h2 className={styles.title}>Something went wrong</h2>
      <p className={styles.message}>
        An unexpected error occurred. Please try again or refresh the page.
      </p>
      <div className={styles.actions}>
        <Button onClick={resetError} variant='outline'>
          Try Again
        </Button>
        <Button onClick={() => window.location.reload()}>Refresh Page</Button>
      </div>
      {isDev && (
        <div className={styles.details}>
          <p className={styles.detailsTitle}>Error Details (Dev Only)</p>
          <pre className={styles.errorStack}>
            {error.message}
            {'\n\n'}
            {error.stack}
          </pre>
        </div>
      )}
    </div>
  )
}

type ErrorBoundaryProps = Readonly<{
  children: ReactNode
  fallback?: ReactNode | ((props: FallbackProps) => ReactNode)
  onError?: (error: Error, errorInfo: ErrorInfo) => void
  fullPage?: boolean
}>

type ErrorBoundaryState = {
  hasError: boolean
  error: Error | null
}

/**
 * Error Boundary component
 *
 * Catches JavaScript errors in child component tree and displays fallback UI.
 * Logs errors and provides reset functionality.
 */
export class ErrorBoundary extends Component<
  ErrorBoundaryProps,
  ErrorBoundaryState
> {
  constructor(props: ErrorBoundaryProps) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    logger.error('Uncaught error in component tree', {
      error: error.message,
      stack: error.stack,
      componentStack: errorInfo.componentStack
    })

    this.props.onError?.(error, errorInfo)
  }

  resetError = (): void => {
    this.setState({ hasError: false, error: null })
  }

  render(): ReactNode {
    if (this.state.hasError && this.state.error) {
      const { fallback, fullPage } = this.props
      const fallbackProps: FallbackProps = {
        error: this.state.error,
        resetError: this.resetError,
        fullPage
      }

      if (typeof fallback === 'function') {
        return fallback(fallbackProps)
      }

      if (fallback) {
        return fallback
      }

      return <DefaultFallback {...fallbackProps} />
    }

    return this.props.children
  }
}

/**
 * Higher-order component to wrap a component with error boundary
 */
export function withErrorBoundary<P extends object>(
  WrappedComponent: React.ComponentType<P>,
  errorBoundaryProps?: Omit<ErrorBoundaryProps, 'children'>
) {
  const displayName =
    WrappedComponent.displayName || WrappedComponent.name || 'Component'

  const WithErrorBoundary = (props: P) => (
    <ErrorBoundary {...errorBoundaryProps}>
      <WrappedComponent {...props} />
    </ErrorBoundary>
  )

  WithErrorBoundary.displayName = `withErrorBoundary(${displayName})`

  return WithErrorBoundary
}
