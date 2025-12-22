import Button from '@/components/ui/button/button'
import Checkbox from '@/components/ui/checkbox/checkbox'
import { Modal } from '@/components/ui/modal'
import { Select, SelectItem } from '@/components/ui/select/select'
import styles from './project-settings-modal.module.css'

type DependencyInfo = Readonly<{
  id: string
  name: string
}>

type VisibilityOption = 'private' | 'public' | 'shared'

export type ProjectSettingsModalViewProps = Readonly<{
  // Form state
  name: string
  description: string
  visibility: VisibilityOption
  isLibrary: boolean
  newTag: string
  selectedDependency: string
  shareUsername: string
  loading: boolean

  // Project data
  currentTags: readonly string[]
  currentDependencies: readonly DependencyInfo[]
  currentUserShares: ReadonlyArray<
    Readonly<{
      userId: string
      username: string
    }>
  >
  availableDependencies: ReadonlyArray<
    Readonly<{
      id: string
      name: string
    }>
  >

  // Form handlers
  onNameChange: (value: string) => void
  onDescriptionChange: (value: string) => void
  onVisibilityChange: (value: VisibilityOption) => void
  onIsLibraryChange: (checked: boolean) => void
  onNewTagChange: (value: string) => void
  onSelectedDependencyChange: (value: string) => void
  onShareUsernameChange: (value: string) => void

  // Actions
  onSave: () => void
  onClose: () => void
  onAddTag: () => void
  onRemoveTag: (tagName: string) => void
  onAddDependency: () => void
  onRemoveDependency: (dependencyId: string) => void
  onAddShare: () => void
  onRemoveShare: (userId: string) => void
}>

/**
 * Pure view component for project settings modal
 * All state and handlers come from props
 */
export function ProjectSettingsModalView({
  name,
  description,
  visibility,
  isLibrary,
  newTag,
  selectedDependency,
  shareUsername,
  loading,
  currentTags,
  currentDependencies,
  currentUserShares,
  availableDependencies,
  onNameChange,
  onDescriptionChange,
  onVisibilityChange,
  onIsLibraryChange,
  onNewTagChange,
  onSelectedDependencyChange,
  onShareUsernameChange,
  onSave,
  onClose,
  onAddTag,
  onRemoveTag,
  onAddDependency,
  onRemoveDependency,
  onAddShare,
  onRemoveShare
}: ProjectSettingsModalViewProps) {
  return (
    <Modal
      open={true}
      onClose={onClose}
      title='Project Settings'
      size='lg'
      actions={
        <>
          <Button type='button' onClick={onSave} disabled={loading} fullWidth>
            {loading ? 'Saving...' : 'Save Changes'}
          </Button>
          <Button
            type='button'
            variant='outline'
            onClick={onClose}
            disabled={loading}
            fullWidth
          >
            Cancel
          </Button>
        </>
      }
    >
      {/* Basic Info */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Basic Information</h3>
        <div className={styles.formGroup}>
          <label htmlFor='project-name' className={styles.label}>
            Name
          </label>
          <input
            id='project-name'
            type='text'
            className={styles.input}
            value={name}
            onChange={(e) => onNameChange(e.target.value)}
          />
        </div>
        <div className={styles.formGroup}>
          <label htmlFor='project-description' className={styles.label}>
            Description
          </label>
          <textarea
            id='project-description'
            className={styles.textarea}
            value={description}
            onChange={(e) => onDescriptionChange(e.target.value)}
          />
        </div>
        <div className={styles.formGroup}>
          <Checkbox
            label='This is a library project'
            checked={isLibrary}
            onChange={(e) => onIsLibraryChange(e.target.checked)}
          />
          <div className={styles.helpText}>
            Library projects can be used as dependencies by other projects
          </div>
        </div>
      </div>

      {/* Visibility & Sharing */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Visibility & Sharing</h3>
        <div className={styles.formGroup}>
          <span className={styles.label}>Visibility</span>
          <Select
            value={visibility}
            onValueChange={(value) =>
              onVisibilityChange(value as VisibilityOption)
            }
          >
            <SelectItem value='private'>Private (only you)</SelectItem>
            <SelectItem value='public'>Public (everyone can see)</SelectItem>
            <SelectItem value='shared'>Shared (specific users)</SelectItem>
          </Select>
          <div className={styles.helpText}>
            {visibility === 'private' &&
              'Only you can see and edit this project'}
            {visibility === 'public' &&
              'Everyone can see this project, but only you can edit it'}
            {visibility === 'shared' &&
              'Only you and users you share with can see this project'}
          </div>
        </div>

        {visibility === 'shared' && (
          <div className={styles.formGroup}>
            <span className={styles.label}>Shared with</span>
            {currentUserShares.length > 0 ? (
              <div className={styles.sharesList}>
                {currentUserShares.map((share) => (
                  <div key={share.userId} className={styles.shareItem}>
                    <span className={styles.shareUsername}>
                      {share.username}
                    </span>
                    <Button
                      type='button'
                      variant='icon'
                      className={styles.shareRemove}
                      onClick={() => onRemoveShare(share.userId)}
                      disabled={loading}
                      aria-label='Remove user'
                    >
                      ×
                    </Button>
                  </div>
                ))}
              </div>
            ) : (
              <div className={styles.emptyState}>
                Not shared with anyone yet
              </div>
            )}
            <div className={styles.addShare}>
              <input
                type='text'
                className={`${styles.input} ${styles.usernameInput}`}
                placeholder='Enter username...'
                value={shareUsername}
                onChange={(e) => onShareUsernameChange(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') onAddShare()
                }}
              />
              <Button
                type='button'
                onClick={onAddShare}
                disabled={loading || !shareUsername.trim()}
              >
                Add
              </Button>
            </div>
          </div>
        )}
      </div>

      {/* Tags */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Tags</h3>
        {currentTags.length > 0 ? (
          <div className={styles.tagsList}>
            {currentTags.map((tag) => (
              <span key={tag} className={styles.tag}>
                {tag}
                <Button
                  type='button'
                  variant='icon'
                  className={styles.tagRemove}
                  onClick={() => onRemoveTag(tag)}
                  disabled={loading}
                  aria-label='Remove tag'
                >
                  ×
                </Button>
              </span>
            ))}
          </div>
        ) : (
          <div className={styles.emptyState}>No tags yet</div>
        )}
        <div className={styles.tagInput}>
          <input
            type='text'
            className={`${styles.input} ${styles.tagInputField}`}
            placeholder='Add a tag...'
            value={newTag}
            onChange={(e) => onNewTagChange(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') onAddTag()
            }}
          />
          <Button
            type='button'
            onClick={onAddTag}
            disabled={loading || !newTag.trim()}
          >
            Add Tag
          </Button>
        </div>
      </div>

      {/* Dependencies */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Dependencies</h3>
        <div className={styles.helpText} style={{ marginBottom: '1rem' }}>
          Use libraries via INCLUDE directives like{' '}
          <code>INCLUDE "/project_name/file.asm"</code>
        </div>
        {currentDependencies.length > 0 ? (
          <div className={styles.dependenciesList}>
            {currentDependencies.map((dep) => (
              <div key={dep.id} className={styles.dependencyItem}>
                <div className={styles.dependencyInfo}>
                  <div className={styles.dependencyName}>{dep.name}</div>
                </div>
                <Button
                  type='button'
                  variant='icon'
                  className={styles.dependencyRemove}
                  onClick={() => onRemoveDependency(dep.id)}
                  disabled={loading}
                  aria-label='Remove dependency'
                >
                  ×
                </Button>
              </div>
            ))}
          </div>
        ) : (
          <div className={styles.emptyState}>No dependencies yet</div>
        )}
        {availableDependencies.length > 0 ? (
          <div className={styles.addDependency}>
            <Select
              value={selectedDependency}
              onValueChange={(value) => onSelectedDependencyChange(value)}
              placeholder='Select a library...'
            >
              {availableDependencies.map((proj) => (
                <SelectItem key={proj.id} value={proj.id}>
                  {proj.name}
                </SelectItem>
              ))}
            </Select>
            <Button
              type='button'
              onClick={onAddDependency}
              disabled={loading || !selectedDependency}
            >
              Add
            </Button>
          </div>
        ) : (
          <div className={styles.helpText}>
            No libraries available. Create a project and mark it as a library to
            use it as a dependency.
          </div>
        )}
      </div>
    </Modal>
  )
}
