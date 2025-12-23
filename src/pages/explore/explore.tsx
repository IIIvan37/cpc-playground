import { PlusIcon } from '@radix-ui/react-icons'
import { useSetAtom } from 'jotai'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Button from '@/components/ui/button/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import type { Project } from '@/domain/entities/project.entity'
import { filterProjects } from '@/domain/services'
import { useAuth } from '@/hooks/use-auth'
import { useFetchVisibleProjects } from '@/hooks/use-fetch-visible-projects'
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
  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)
  const [creating, setCreating] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')

  const { user } = useAuth()
  const navigate = useNavigate()
  const createProject = useSetAtom(createProjectAtom)

  const { projects, loading, error } = useFetchVisibleProjects(user?.id)

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

  // Prepare searchable projects for domain filter
  const searchableProjects = projects.map((project) => {
    const isOwner = user?.id === project.userId
    return {
      project,
      authorName: isOwner ? 'Owned' : project.authorUsername || 'Unknown'
    }
  })

  // Filter projects using domain service
  const filteredProjects = filterProjects(searchableProjects, {
    query: searchQuery,
    userId: user?.id
  })

  // Map to view props
  const listProjects = filteredProjects.map(({ project, authorName }) => {
    const isOwner = user?.id === project.userId
    return {
      id: project.id,
      name: project.name.value,
      authorName,
      description: project.description,
      tags: [...project.tags],
      isOwner,
      isShared: project.userShares.some((share) => share.userId === user?.id),
      visibility: project.visibility.value,
      isLibrary: project.isLibrary,
      filesCount: project.files.length,
      sharesCount: project.userShares.length,
      updatedAt: project.updatedAt,
      onClick: () => handleProjectClick(project)
    }
  })

  return (
    <div className={styles.container}>
      <div className={styles.wrapper}>
        <div className={styles.pageHeader}>
          <div className={styles.headerRow}>
            <div className={styles.headerContent}>
              <h1 className={styles.title}>Explore Projects</h1>
              <p className={styles.subtitle}>
                Discover public projects and libraries from the community
              </p>
            </div>
            {user && (
              <Button onClick={() => setShowNewProjectDialog(true)}>
                <PlusIcon /> New Project
              </Button>
            )}
          </div>
        </div>

        <ExploreListView
          projects={listProjects}
          loading={loading}
          error={error}
          searchQuery={searchQuery}
          onSearchChange={setSearchQuery}
        />
      </div>

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
