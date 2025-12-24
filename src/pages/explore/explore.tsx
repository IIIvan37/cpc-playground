import { PlusIcon } from '@radix-ui/react-icons'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Button from '@/components/ui/button/button'
import { MINIMAL_ASM_TEMPLATE } from '@/lib/constants'
import { createLogger } from '@/lib/logger'

const logger = createLogger('ExplorePage')

import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import type { Project } from '@/domain/entities/project.entity'
import { filterProjects } from '@/domain/services'
import {
  getThumbnailUrl,
  useAuth,
  useCreateProject,
  useFetchVisibleProjects
} from '@/hooks'
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

  const { user, loading: authLoading } = useAuth()
  const navigate = useNavigate()
  const { create: createProject } = useCreateProject()

  const { projects, loading, error } = useFetchVisibleProjects(
    user?.id,
    !authLoading
  )

  const handleCreateProject = async () => {
    if (!newProjectName.trim() || !user) return
    setCreating(true)
    try {
      const initialFile = {
        name: newProjectIsLibrary ? 'lib.asm' : 'main.asm',
        content: newProjectIsLibrary ? '' : MINIMAL_ASM_TEMPLATE,
        isMain: !newProjectIsLibrary
      }

      const result = await createProject({
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
      if (result?.project) {
        navigate(`/?project=${result.project.id}`)
      }
    } catch (err) {
      logger.error('Failed to create project:', err)
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
      tags: [...(project.tags ?? [])],
      isOwner,
      isShared: (project.userShares ?? []).some(
        (share) => share.userId === user?.id
      ),
      visibility: project.visibility.value,
      isLibrary: project.isLibrary,
      filesCount: (project.files ?? []).length,
      sharesCount: (project.userShares ?? []).length,
      updatedAt: project.updatedAt,
      createdAt: project.createdAt,
      thumbnailUrl: getThumbnailUrl(project.thumbnailPath),
      onClick: () => handleProjectClick(project)
    }
  })

  // Sort projects: pin the documentation project (oldest) at the top, then sort by createdAt descending
  const sortedProjects =
    listProjects.length > 0
      ? (() => {
          // Find the oldest project (documentation)
          const oldestProject = listProjects.reduce(
            (oldest, current) =>
              current.createdAt < oldest.createdAt ? current : oldest,
            listProjects[0]
          )

          // Separate the documentation project from the rest
          const docProject = listProjects.find((p) => p.id === oldestProject.id)
          const otherProjects = listProjects
            .filter((p) => p.id !== oldestProject.id)
            .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())

          return docProject ? [docProject, ...otherProjects] : otherProjects
        })()
      : listProjects

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
          projects={sortedProjects}
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
