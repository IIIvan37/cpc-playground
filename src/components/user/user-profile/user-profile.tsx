import { useAtomValue } from 'jotai'
import { useState } from 'react'
import { ConfirmDialog } from '@/components/ui/confirm-dialog'
import {
  useAuth,
  useConfirmDialog,
  userAtom,
  useToastActions,
  useUserProfile
} from '@/hooks'
import { createLogger } from '@/lib/logger'
import { UserProfileView } from './user-profile.view'

const logger = createLogger('UserProfile')

/**
 * Container component for user profile management
 * Handles business logic and delegates rendering to UserProfileView
 */
export function UserProfile() {
  const user = useAtomValue(userAtom)
  const { signOut } = useAuth()
  const { profile, loading, updateUsername } = useUserProfile()
  const toast = useToastActions()
  const { confirm, dialogProps } = useConfirmDialog()
  const [showModal, setShowModal] = useState(false)
  const [newUsername, setNewUsername] = useState('')
  const [saving, setSaving] = useState(false)

  if (!user) return null

  const handleOpenModal = () => {
    setNewUsername(profile?.username || '')
    setShowModal(true)
  }

  const handleSaveUsername = async () => {
    if (!newUsername.trim()) return
    setSaving(true)
    try {
      await updateUsername(newUsername.trim())
      setShowModal(false)
      toast.success('Username updated')
    } catch (error) {
      logger.error('Error updating username', { error })
      toast.error('Failed to update username', 'Please try again')
    } finally {
      setSaving(false)
    }
  }

  const handleSignOut = async () => {
    const confirmed = await confirm({
      title: 'Sign out',
      message: 'Are you sure you want to sign out?',
      confirmLabel: 'Sign out',
      variant: 'danger'
    })
    if (confirmed) {
      await signOut()
    }
  }

  return (
    <>
      <UserProfileView
        username={profile?.username || ''}
        email={user.email}
        userId={user.id}
        loading={loading}
        saving={saving}
        modalOpen={showModal}
        newUsername={newUsername}
        onOpenModal={handleOpenModal}
        onCloseModal={() => setShowModal(false)}
        onUsernameChange={setNewUsername}
        onSaveUsername={handleSaveUsername}
        onSignOut={handleSignOut}
      />
      <ConfirmDialog {...dialogProps} />
    </>
  )
}
