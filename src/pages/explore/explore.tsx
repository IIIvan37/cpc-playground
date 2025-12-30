import { useCallback, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import type { Project } from '@/domain/entities/project.entity'
import { filterProjects } from '@/domain/services'
import {
  getThumbnailUrl,
  useAuth,
  useFetchVisibleProjects,
  useHandleCreateProject,
  useHandleForkProject
} from '@/hooks'
import { ExplorePageView } from './explore-page.view'

/**
 * Explore Page
 * Displays projects visible to the current user:
 * - Authenticated users: public projects + their own + shared with them
 * - Anonymous users: only public projects
 *
 * Supports URL query params for sharing searches:
 * - ?q=<search> - Search query
 * - ?libs=true - Show libraries only
 */
export function ExplorePage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)

  // Initialize state from URL params
  const searchQuery = searchParams.get('q') ?? ''
  const showLibrariesOnly = searchParams.get('libs') === 'true'

  // Update URL when search changes
  const setSearchQuery = useCallback(
    (query: string) => {
      setSearchParams(
        (prev) => {
          const newParams = new URLSearchParams(prev)
          if (query) {
            newParams.set('q', query)
          } else {
            newParams.delete('q')
          }
          return newParams
        },
        { replace: true }
      )
    },
    [setSearchParams]
  )

  const setShowLibrariesOnly = useCallback(
    (show: boolean) => {
      setSearchParams(
        (prev) => {
          const newParams = new URLSearchParams(prev)
          if (show) {
            newParams.set('libs', 'true')
          } else {
            newParams.delete('libs')
          }
          return newParams
        },
        { replace: true }
      )
    },
    [setSearchParams]
  )

  const { user, loading: authLoading } = useAuth()
  const navigate = useNavigate()
  const { handleCreate: createProject, loading: creating } =
    useHandleCreateProject()
  const { handleFork: forkProject } = useHandleForkProject()

  const { projects, loading, error } = useFetchVisibleProjects(
    user?.id,
    !authLoading
  )

  const handleCreateProject = async () => {
    if (!newProjectName.trim() || !user) return

    const result = await createProject({
      userId: user.id,
      name: newProjectName.trim(),
      isLibrary: newProjectIsLibrary
    })

    if (result.success) {
      setShowNewProjectDialog(false)
      setNewProjectName('')
      setNewProjectIsLibrary(false)
    }
  }

  const handleProjectClick = (project: Project) => {
    navigate(`/?project=${project.id}`)
  }

  const handleForkProject = async (projectId: string) => {
    if (!user) return
    await forkProject({ projectId, userId: user.id })
  }

  const handleCloseNewProjectDialog = () => {
    setShowNewProjectDialog(false)
    setNewProjectName('')
    setNewProjectIsLibrary(false)
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
    userId: user?.id,
    librariesOnly: showLibrariesOnly
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
      onClick: () => handleProjectClick(project),
      onFork: () => handleForkProject(project.id),
      canFork: !!user
    }
  })

  // Separate libraries from regular projects
  const libraryProjects = listProjects
    .filter((p) => p.isLibrary)
    .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())

  const regularProjects = listProjects
    .filter((p) => !p.isLibrary)
    .sort((a, b) => {
      // Find the oldest project (documentation) to pin at top
      const nonLibraryProjects = listProjects.filter((p) => !p.isLibrary)
      const oldestProject = nonLibraryProjects.reduce<
        (typeof nonLibraryProjects)[number] | undefined
      >(
        (oldest, current) =>
          !oldest || current.createdAt < oldest.createdAt ? current : oldest,
        undefined
      )
      const oldestId = oldestProject?.id

      // Pin documentation at top
      if (a.id === oldestId) return -1
      if (b.id === oldestId) return 1

      return b.createdAt.getTime() - a.createdAt.getTime()
    })

  return (
    <ExplorePageView
      isAuthenticated={!!user}
      onNewProject={() => setShowNewProjectDialog(true)}
      libraryProjects={libraryProjects}
      regularProjects={regularProjects}
      loading={loading}
      error={error}
      searchQuery={searchQuery}
      onSearchChange={setSearchQuery}
      showLibrariesOnly={showLibrariesOnly}
      onShowLibrariesOnlyChange={setShowLibrariesOnly}
      showNewProjectDialog={showNewProjectDialog}
      newProjectName={newProjectName}
      newProjectIsLibrary={newProjectIsLibrary}
      creating={creating}
      onNewProjectNameChange={setNewProjectName}
      onNewProjectIsLibraryChange={setNewProjectIsLibrary}
      onCreateProject={handleCreateProject}
      onCloseNewProjectDialog={handleCloseNewProjectDialog}
    />
  )
}
