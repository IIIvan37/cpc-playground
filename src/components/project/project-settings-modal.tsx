import { useAtomValue, useSetAtom } from 'jotai'
import { useState } from 'react'
import { Select, SelectItem } from '@/components/ui/select/select'
import { supabase } from '../../lib/supabase'
import {
  addDependencyToProjectAtom,
  addTagToProjectAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  projectsAtom,
  removeDependencyFromProjectAtom,
  removeTagFromProjectAtom,
  updateProjectAtom
} from '../../store/projects-v2'
import styles from './project-settings-modal.module.css'

interface ProjectSettingsModalProps {
  onClose: () => void
}

export function ProjectSettingsModal({ onClose }: ProjectSettingsModalProps) {
  const currentProject = useAtomValue(currentProjectAtom)
  const projects = useAtomValue(projectsAtom)
  const updateProject = useSetAtom(updateProjectAtom)
  const addTag = useSetAtom(addTagToProjectAtom)
  const removeTag = useSetAtom(removeTagFromProjectAtom)
  const addDependency = useSetAtom(addDependencyToProjectAtom)
  const removeDependency = useSetAtom(removeDependencyFromProjectAtom)
  const fetchProjects = useSetAtom(fetchProjectsAtom)

  const [name, setName] = useState(currentProject?.name || '')
  const [description, setDescription] = useState(
    currentProject?.description || ''
  )
  const [visibility, setVisibility] = useState<'private' | 'public' | 'shared'>(
    currentProject?.visibility || 'private'
  )
  const [isLibrary, setIsLibrary] = useState(currentProject?.isLibrary || false)

  const [newTag, setNewTag] = useState('')
  const [selectedDependency, setSelectedDependency] = useState('')
  const [shareUsername, setShareUsername] = useState('')
  const [loading, setLoading] = useState(false)

  if (!currentProject) return null

  const handleSave = async () => {
    setLoading(true)
    try {
      await updateProject({
        projectId: currentProject.id,
        name,
        description,
        visibility,
        isLibrary: isLibrary
      })
      await fetchProjects()
    } catch (error) {
      console.error('Error updating project:', error)
      alert('Error updating project')
    } finally {
      setLoading(false)
    }
  }

  const handleAddTag = async () => {
    if (!newTag.trim()) return
    setLoading(true)
    try {
      await addTag({ projectId: currentProject.id, tagName: newTag.trim() })
      setNewTag('')
      await fetchProjects()
    } catch (error) {
      console.error('Error adding tag:', error)
      alert('Error adding tag')
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveTag = async (tagId: string) => {
    setLoading(true)
    try {
      await removeTag({ projectId: currentProject.id, tagId })
      await fetchProjects()
    } catch (error) {
      console.error('Error removing tag:', error)
      alert('Error removing tag')
    } finally {
      setLoading(false)
    }
  }

  const handleAddDependency = async () => {
    if (!selectedDependency) return
    setLoading(true)
    try {
      await addDependency({
        projectId: currentProject.id,
        dependencyId: selectedDependency
      })
      setSelectedDependency('')
      await fetchProjects()
    } catch (error) {
      console.error('Error adding dependency:', error)
      alert('Error adding dependency')
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveDependency = async (dependencyId: string) => {
    setLoading(true)
    try {
      await removeDependency({
        projectId: currentProject.id,
        dependencyId
      })
      await fetchProjects()
    } catch (error) {
      console.error('Error removing dependency:', error)
      alert('Error removing dependency')
    } finally {
      setLoading(false)
    }
  }

  const handleAddShare = async () => {
    if (!shareUsername.trim()) return
    setLoading(true)
    try {
      // Find user by username
      const { data: profile, error: profileError } = await supabase
        .from('user_profiles')
        .select('id')
        .eq('username', shareUsername.trim())
        .single()

      if (profileError || !profile) {
        alert('User not found')
        return
      }

      // Add share
      const { error: shareError } = await supabase
        .from('project_shares')
        .insert({
          project_id: currentProject.id,
          user_id: profile.id
        })

      if (shareError) {
        if (shareError.code === '23505') {
          alert('User already has access')
        } else {
          throw shareError
        }
        return
      }

      setShareUsername('')
      await fetchProjects()
    } catch (error) {
      console.error('Error adding share:', error)
      alert('Error adding share')
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveShare = async (userId: string) => {
    setLoading(true)
    try {
      const { error } = await supabase
        .from('project_shares')
        .delete()
        .eq('project_id', currentProject.id)
        .eq('user_id', userId)

      if (error) throw error

      await fetchProjects()
    } catch (error) {
      console.error('Error removing share:', error)
      alert('Error removing share')
    } finally {
      setLoading(false)
    }
  }

  // Filter available dependencies (libraries not already added)
  const availableDependencies = projects.filter(
    (p) =>
      p.isLibrary &&
      p.id !== currentProject.id &&
      !currentProject.dependencies?.some((d) => d.id === p.id)
  )

  return (
    <div className={styles.modal} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Project Settings</h2>
          <button
            type='button'
            className={styles.closeButton}
            onClick={onClose}
            aria-label='Close'
          >
            ×
          </button>
        </div>

        {/* Basic Info */}
        <div className={styles.section}>
          <h3 className={styles.sectionTitle}>Basic Information</h3>
          <div className={styles.formGroup}>
            <label className={styles.label}>Name</label>
            <input
              type='text'
              className={styles.input}
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </div>
          <div className={styles.formGroup}>
            <label className={styles.label}>Description</label>
            <textarea
              className={styles.textarea}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </div>
          <div className={styles.formGroup}>
            <label className={styles.checkbox}>
              <input
                type='checkbox'
                checked={isLibrary}
                onChange={(e) => setIsLibrary(e.target.checked)}
              />
              <span>This is a library project</span>
            </label>
            <div className={styles.helpText}>
              Library projects can be used as dependencies by other projects
            </div>
          </div>
        </div>

        {/* Visibility & Sharing */}
        <div className={styles.section}>
          <h3 className={styles.sectionTitle}>Visibility & Sharing</h3>
          <div className={styles.formGroup}>
            <label className={styles.label}>Visibility</label>
            <Select
              value={visibility}
              onValueChange={(value) =>
                setVisibility(value as 'private' | 'public' | 'shared')
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
              <label className={styles.label}>Shared with</label>
              {currentProject.shares && currentProject.shares.length > 0 ? (
                <div className={styles.sharesList}>
                  {currentProject.shares.map((share) => (
                    <div key={share.userId} className={styles.shareItem}>
                      <span className={styles.shareUsername}>
                        {share.userId}
                      </span>
                      <button
                        type='button'
                        className={styles.shareRemove}
                        onClick={() => handleRemoveShare(share.userId)}
                        disabled={loading}
                        aria-label='Remove user'
                      >
                        ×
                      </button>
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
                  onChange={(e) => setShareUsername(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') handleAddShare()
                  }}
                />
                <button
                  type='button'
                  onClick={handleAddShare}
                  disabled={loading || !shareUsername.trim()}
                >
                  Add
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Tags */}
        <div className={styles.section}>
          <h3 className={styles.sectionTitle}>Tags</h3>
          {currentProject.tags && currentProject.tags.length > 0 ? (
            <div className={styles.tagsList}>
              {currentProject.tags.map((tag) => (
                <span key={tag.id} className={styles.tag}>
                  {tag.name}
                  <button
                    type='button'
                    className={styles.tagRemove}
                    onClick={() => handleRemoveTag(tag.id)}
                    disabled={loading}
                    aria-label='Remove tag'
                  >
                    ×
                  </button>
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
              onChange={(e) => setNewTag(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') handleAddTag()
              }}
            />
            <button
              type='button'
              onClick={handleAddTag}
              disabled={loading || !newTag.trim()}
            >
              Add Tag
            </button>
          </div>
        </div>

        {/* Dependencies */}
        <div className={styles.section}>
          <h3 className={styles.sectionTitle}>Dependencies</h3>
          <div className={styles.helpText} style={{ marginBottom: '1rem' }}>
            Use libraries via INCLUDE directives like{' '}
            <code>INCLUDE "/project_name/file.asm"</code>
          </div>
          {currentProject.dependencies &&
          currentProject.dependencies.length > 0 ? (
            <div className={styles.dependenciesList}>
              {currentProject.dependencies.map((dep) => (
                <div key={dep.id} className={styles.dependencyItem}>
                  <div className={styles.dependencyInfo}>
                    <div className={styles.dependencyName}>{dep.name}</div>
                  </div>
                  <button
                    type='button'
                    className={styles.dependencyRemove}
                    onClick={() => handleRemoveDependency(dep.id)}
                    disabled={loading}
                    aria-label='Remove dependency'
                  >
                    ×
                  </button>
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
                onValueChange={(value) => setSelectedDependency(value)}
                placeholder='Select a library...'
              >
                {availableDependencies.map((proj) => (
                  <SelectItem key={proj.id} value={proj.id}>
                    {proj.name}
                  </SelectItem>
                ))}
              </Select>
              <button
                type='button'
                onClick={handleAddDependency}
                disabled={loading || !selectedDependency}
              >
                Add
              </button>
            </div>
          ) : (
            <div className={styles.helpText}>
              No libraries available. Create a project and mark it as a library
              to use it as a dependency.
            </div>
          )}
        </div>

        {/* Action Buttons */}
        <div style={{ display: 'flex', gap: '0.75rem', marginTop: '2rem' }}>
          <button
            type='button'
            onClick={handleSave}
            disabled={loading}
            style={{ flex: 1 }}
          >
            {loading ? 'Saving...' : 'Save Changes'}
          </button>
          <button
            type='button'
            onClick={onClose}
            disabled={loading}
            style={{ flex: 1, background: 'var(--bg-primary)' }}
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  )
}
