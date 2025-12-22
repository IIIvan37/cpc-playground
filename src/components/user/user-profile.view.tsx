import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import styles from './user-profile.module.css'

// ============================================================================
// Types
// ============================================================================

export type UserProfileViewProps = {
  username: string
  email: string
  userId: string
  loading: boolean
  saving: boolean
  modalOpen: boolean
  newUsername: string
  onOpenModal: () => void
  onCloseModal: () => void
  onUsernameChange: (value: string) => void
  onSaveUsername: () => void
  onSignOut: () => void
}

// ============================================================================
// View Component
// ============================================================================

export function UserProfileView({
  username,
  email,
  userId,
  loading,
  saving,
  modalOpen,
  newUsername,
  onOpenModal,
  onCloseModal,
  onUsernameChange,
  onSaveUsername,
  onSignOut
}: UserProfileViewProps) {
  return (
    <>
      <Button
        type='button'
        variant='outline'
        className={styles.profileButton}
        onClick={onOpenModal}
      >
        <span>👤</span>
        <span className={styles.username}>
          {loading ? '...' : username || 'User'}
        </span>
      </Button>

      <Modal
        open={modalOpen}
        onClose={onCloseModal}
        title='User Profile'
        actions={
          <>
            <Button type='button' onClick={onSaveUsername} disabled={saving}>
              {saving ? 'Saving...' : 'Save Username'}
            </Button>
            <Button
              type='button'
              variant='secondary'
              onClick={onSignOut}
              disabled={saving}
            >
              Sign Out
            </Button>
          </>
        }
      >
        <div className={styles.info}>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>Email</span>
            <span className={styles.infoValue}>{email}</span>
          </div>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>User ID</span>
            <span className={styles.infoValue}>
              {userId.substring(0, 8)}...
            </span>
          </div>
        </div>

        <div className={styles.section}>
          <Input
            label='Username'
            type='text'
            value={newUsername}
            onChange={(e) => onUsernameChange(e.target.value)}
            placeholder='Enter username'
          />
          <div className={styles.helpText}>
            Username must be 3-30 characters and can only contain letters,
            numbers, hyphens and underscores
          </div>
        </div>
      </Modal>
    </>
  )
}
