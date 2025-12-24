import { useAtomValue } from 'jotai'
import { useState } from 'react'
import { useAuth, userAtom, useUserProfile } from '@/hooks'
import { UserProfileView } from './user-profile.view'

/**
 * Container component for user profile management
 * Handles business logic and delegates rendering to UserProfileView
 */
export function UserProfile() {
  const user = useAtomValue(userAtom)
  const { signOut } = useAuth()
  const { profile, loading, updateUsername } = useUserProfile()
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
    } catch (error) {
      console.error('Error updating username:', error)
      alert('Error updating username')
    } finally {
      setSaving(false)
    }
  }

  const handleSignOut = async () => {
    if (confirm('Are you sure you want to sign out?')) {
      await signOut()
    }
  }

  return (
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
  )
}
