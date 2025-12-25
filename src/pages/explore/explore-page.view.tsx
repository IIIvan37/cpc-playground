import styles from './explore.module.css'
import { ExploreHeaderView } from './explore-header.view'
import { ExploreListView, type ProjectItemProps } from './explore-list.view'
import { NewProjectModalView } from './new-project-modal.view'

export interface ExplorePageViewProps {
  // Header
  readonly isAuthenticated: boolean
  readonly onNewProject: () => void

  // List
  readonly libraryProjects: ReadonlyArray<ProjectItemProps>
  readonly regularProjects: ReadonlyArray<ProjectItemProps>
  readonly loading: boolean
  readonly error?: string | null
  readonly searchQuery: string
  readonly onSearchChange: (query: string) => void
  readonly showLibrariesOnly: boolean
  readonly onShowLibrariesOnlyChange: (value: boolean) => void

  // Modal
  readonly showNewProjectDialog: boolean
  readonly newProjectName: string
  readonly newProjectIsLibrary: boolean
  readonly creating: boolean
  readonly onNewProjectNameChange: (name: string) => void
  readonly onNewProjectIsLibraryChange: (isLibrary: boolean) => void
  readonly onCreateProject: () => void
  readonly onCloseNewProjectDialog: () => void
}

export function ExplorePageView({
  isAuthenticated,
  onNewProject,
  libraryProjects,
  regularProjects,
  loading,
  error,
  searchQuery,
  onSearchChange,
  showLibrariesOnly,
  onShowLibrariesOnlyChange,
  showNewProjectDialog,
  newProjectName,
  newProjectIsLibrary,
  creating,
  onNewProjectNameChange,
  onNewProjectIsLibraryChange,
  onCreateProject,
  onCloseNewProjectDialog
}: ExplorePageViewProps) {
  return (
    <div className={styles.container}>
      <div className={styles.wrapper}>
        <ExploreHeaderView
          title='Explore Projects'
          subtitle='Discover public projects and libraries from the community'
          showNewProjectButton={isAuthenticated}
          onNewProject={onNewProject}
        />

        <ExploreListView
          libraryProjects={libraryProjects}
          regularProjects={regularProjects}
          loading={loading}
          error={error}
          searchQuery={searchQuery}
          onSearchChange={onSearchChange}
          showLibrariesOnly={showLibrariesOnly}
          onShowLibrariesOnlyChange={onShowLibrariesOnlyChange}
        />
      </div>

      <NewProjectModalView
        open={showNewProjectDialog}
        name={newProjectName}
        isLibrary={newProjectIsLibrary}
        creating={creating}
        onNameChange={onNewProjectNameChange}
        onIsLibraryChange={onNewProjectIsLibraryChange}
        onSubmit={onCreateProject}
        onClose={onCloseNewProjectDialog}
      />
    </div>
  )
}
