import { useState } from 'react'
import { AuthModal } from '@/components/auth'
import Button from '@/components/ui/button/button'
import { UserProfile } from '@/components/user'
import { useAuth } from '@/hooks'
import { AppHeaderView } from './app-header.view'

/**
 * Container component for the application header
 * Handles authentication state and modal visibility
 */
export function AppHeader() {
  const { user } = useAuth()
  const [showAuthModal, setShowAuthModal] = useState(false)

  const authSection = user ? (
    <UserProfile />
  ) : (
    <Button
      variant='outline'
      size='sm'
      onClick={() => setShowAuthModal(true)}
      title='Sign in'
    >
      Sign In
    </Button>
  )

  return (
    <AppHeaderView
      authSection={authSection}
      authModal={
        showAuthModal ? (
          <AuthModal onClose={() => setShowAuthModal(false)} />
        ) : undefined
      }
    />
  )
}
