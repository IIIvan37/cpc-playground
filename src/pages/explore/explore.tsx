import { useCallback, useEffect, useRef, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import type { Project } from '@/domain/entities/project.entity'
import {
  getThumbnailUrl,
  useAuth,
  useHandleCreateProject,
  useHandleForkProject,
  useInfiniteProjects
} from '@/hooks'
import { ExplorePageView } from './explore-page.view'

const SEARCH_DEBOUNCE_MS = 300

/**
 * Explore Page
 * Displays projects visible to the current user:
 * - Authenticated users: public projects + their own + shared with them
 * - Anonymous users: only public projects
 *
 * Supports URL query params for sharing searches:
 * - ?q=<search> - Search query
 * - ?libs=true - Show libraries only
 *
 * Uses server-side pagination and search for scalability.
 */
export function ExplorePage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)

  // Initialize state from URL params
  const urlSearchQuery = searchParams.get('q') ?? ''
  const showLibrariesOnly = searchParams.get('libs') === 'true'

  // Local search input state (updates immediately for UI)
  const [searchInput, setSearchInput] = useState(urlSearchQuery)
  // Debounced search query (used for actual API calls)
  const [debouncedSearch, setDebouncedSearch] = useState(urlSearchQuery)
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  // Sync local input when URL changes externally (e.g., browser back/forward)
  useEffect(() => {
    setSearchInput(urlSearchQuery)
    setDebouncedSearch(urlSearchQuery)
  }, [urlSearchQuery])

  // Debounce search input and update URL
  const setSearchQuery = useCallback(
    (query: string) => {
      setSearchInput(query)

      if (debounceRef.current) {
        clearTimeout(debounceRef.current)
      }

      debounceRef.current = setTimeout(() => {
        setDebouncedSearch(query)
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
      }, SEARCH_DEBOUNCE_MS)
    },
    [setSearchParams]
  )

  // Cleanup debounce timer on unmount
  useEffect(() => {
    return () => {
      if (debounceRef.current) {
        clearTimeout(debounceRef.current)
      }
    }
  }, [])

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

  // Use infinite scroll pagination with server-side search
  const { projects, total, loading, loadingMore, error, hasMore, loadMore } =
    useInfiniteProjects({
      userId: user?.id,
      search: debouncedSearch || undefined,
      librariesOnly: showLibrariesOnly,
      enabled: !authLoading
    })

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

  // Map projects to view props
  const listProjects = projects.map((project) => {
    const isOwner = user?.id === project.userId
    const authorName = isOwner ? 'Owned' : project.authorUsername || 'Unknown'
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
      thumbnailUrl: getThumbnailUrl(project.thumbnailPath, project.updatedAt),
      onClick: () => handleProjectClick(project),
      onFork: () => handleForkProject(project.id),
      canFork: !!user
    }
  })

  // Separate libraries from regular projects
  const libraryProjects = listProjects.filter((p) => p.isLibrary)
  const regularProjects = listProjects.filter((p) => !p.isLibrary)

  return (
    <ExplorePageView
      isAuthenticated={!!user}
      onNewProject={() => setShowNewProjectDialog(true)}
      libraryProjects={libraryProjects}
      regularProjects={regularProjects}
      loading={loading}
      loadingMore={loadingMore}
      error={error}
      total={total}
      hasMore={hasMore}
      onLoadMore={() => loadMore()}
      searchQuery={searchInput}
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
