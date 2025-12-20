import { useAtomValue } from 'jotai'
import { useState } from 'react'
import { Input } from '@/components/ui/input'
import { userAtom } from '../../hooks/use-auth'
import { useUserProfile } from '../../hooks/use-user-profile'
import { supabase } from '../../lib/supabase'
import styles from './user-profile.module.css'

export function UserProfile() {
  const user = useAtomValue(userAtom)
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
      await supabase.auth.signOut()
    }
  }

  return (
    <>
      <button
        type='button'
        className={styles.profileButton}
        onClick={handleOpenModal}
      >
        <span>👤</span>
        <span className={styles.username}>
          {loading ? '...' : profile?.username || 'User'}
        </span>
      </button>

      {showModal && (
        <div className={styles.modal} onClick={() => setShowModal(false)}>
          <div
            className={styles.modalContent}
            onClick={(e) => e.stopPropagation()}
          >
            <div className={styles.modalHeader}>
              <h2 className={styles.modalTitle}>User Profile</h2>
              <button
                type='button'
                className={styles.closeButton}
                onClick={() => setShowModal(false)}
                aria-label='Close'
              >
                ×
              </button>
            </div>

            <div className={styles.info}>
              <div className={styles.infoRow}>
                <span className={styles.infoLabel}>Email</span>
                <span className={styles.infoValue}>{user.email}</span>
              </div>
              <div className={styles.infoRow}>
                <span className={styles.infoLabel}>User ID</span>
                <span className={styles.infoValue}>
                  {user.id.substring(0, 8)}...
                </span>
              </div>
            </div>

            <div className={styles.section}>
              <Input
                label='Username'
                type='text'
                value={newUsername}
                onChange={(e) => setNewUsername(e.target.value)}
                placeholder='Enter username'
              />
              <div className={styles.helpText}>
                Username must be 3-30 characters and can only contain letters,
                numbers, hyphens and underscores
              </div>
            </div>

            <div className={styles.actions}>
              <button
                type='button'
                onClick={handleSaveUsername}
                disabled={saving}
              >
                {saving ? 'Saving...' : 'Save Username'}
              </button>
              <button
                type='button'
                className={styles.signOutButton}
                onClick={handleSignOut}
                disabled={saving}
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
