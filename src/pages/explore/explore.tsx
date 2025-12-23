import { PlusIcon } from '@radix-ui/react-icons'
import { useSetAtom } from 'jotai'
import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Button from '@/components/ui/button/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import type { Project } from '@/domain/entities/project.entity'
import { useAuth } from '@/hooks/use-auth'
import { container } from '@/infrastructure/container'
import { createProjectAtom } from '@/store/projects'
import styles from './explore.module.css'
import { ExploreListView } from './explore.view'

/**
 * Explore Page
 * Displays projects visible to the current user:
 * - Authenticated users: public projects + their own + shared with them
 * - Anonymous users: only public projects
 */
export function ExplorePage() {
  const [projects, setProjects] = useState<readonly Project[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)
  const [creating, setCreating] = useState(false)

  const { user } = useAuth()
  const navigate = useNavigate()
  const createProject = useSetAtom(createProjectAtom)

  const fetchProjects = useCallback(async () => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.getVisibleProjects.execute({
        userId: user?.id
      })
      setProjects(result.projects)
    } catch {
      setError('Failed to load projects')
    } finally {
      setLoading(false)
    }
  }, [user?.id])

  useEffect(() => {
    fetchProjects()
  }, [fetchProjects])

  const handleCreateProject = async () => {
    if (!newProjectName.trim() || !user) return
    setCreating(true)
    try {
      const initialFile = {
        name: newProjectIsLibrary ? 'lib.asm' : 'main.asm',
        content: '',
        isMain: !newProjectIsLibrary
      }

      const project = await createProject({
        userId: user.id,
        name: newProjectName.trim(),
        visibility: 'private',
        isLibrary: newProjectIsLibrary,
        files: [initialFile]
      })

      setShowNewProjectDialog(false)
      setNewProjectName('')
      setNewProjectIsLibrary(false)

      // Navigate to the new project
      if (project) {
        navigate(`/?project=${project.id}`)
      }
    } catch (err) {
      console.error('Failed to create project:', err)
    } finally {
      setCreating(false)
    }
  }

  const handleProjectClick = (project: Project) => {
    // Navigate to project (using a query param or similar approach)
    // For now, we'll use the project ID in the URL
    navigate(`/?project=${project.id}`)
  }

  // Prepare data for dumb view
  const listProjects = projects.map((project) => ({
    id: project.id,
    name: project.name.value,
    description: project.description,
    tags: [...project.tags],
    isOwner: user?.id === project.userId,
    isShared: project.userShares.some((share) => share.userId === user?.id),
    visibility: project.visibility.value,
    isLibrary: project.isLibrary,
    filesCount: project.files.length,
    sharesCount: project.userShares.length,
    updatedAt: project.updatedAt,
    onClick: () => handleProjectClick(project)
  }))

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>Explore Projects</h1>
        {user && (
          <Button onClick={() => setShowNewProjectDialog(true)}>
            <PlusIcon /> New Project
          </Button>
        )}
      </div>

      <ExploreListView
        projects={listProjects}
        loading={loading}
        error={error}
      />

      {showNewProjectDialog && (
        <Modal
          open={showNewProjectDialog}
          title='Create New Project'
          onClose={() => {
            setShowNewProjectDialog(false)
            setNewProjectName('')
            setNewProjectIsLibrary(false)
          }}
        >
          <div className={styles.modalContent}>
            <Input
              label='Project Name'
              value={newProjectName}
              onChange={(e) => setNewProjectName(e.target.value)}
              placeholder='My Awesome Project'
              autoFocus
            />
            <Checkbox
              label='Library Project'
              checked={newProjectIsLibrary}
              onChange={(e) => setNewProjectIsLibrary(e.target.checked)}
            />
            <div className={styles.modalActions}>
              <Button
                variant='ghost'
                onClick={() => {
                  setShowNewProjectDialog(false)
                  setNewProjectName('')
                  setNewProjectIsLibrary(false)
                }}
              >
                Cancel
              </Button>
              <Button
                onClick={handleCreateProject}
                disabled={!newProjectName.trim() || creating}
              >
                {creating ? 'Creating...' : 'Create'}
              </Button>
            </div>
          </div>
        </Modal>
      )}
    </div>
  )
}
