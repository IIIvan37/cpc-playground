import { Link } from 'react-router-dom'
import { Badge } from '@/components/ui/badge'
import Button from '@/components/ui/button/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { TagsList } from '@/components/ui/tag'
import styles from './explore.module.css'

export interface ProjectItemProps {
  readonly id: string
  readonly name: string
  readonly authorName: string
  readonly description?: string | null
  readonly tags: string[]
  readonly isOwner: boolean
  readonly isShared: boolean
  readonly visibility: string
  readonly isLibrary: boolean
  readonly filesCount: number
  readonly sharesCount: number
  readonly updatedAt: Date
  readonly createdAt: Date
  readonly thumbnailUrl?: string | null
  readonly onClick: () => void
  readonly onFork?: () => void
  readonly canFork?: boolean
}

export interface ExploreListViewProps {
  readonly libraryProjects: ReadonlyArray<ProjectItemProps>
  readonly regularProjects: ReadonlyArray<ProjectItemProps>
  readonly loading?: boolean
  readonly error?: string | null
  readonly searchQuery?: string
  readonly onSearchChange?: (query: string) => void
  readonly showLibrariesOnly?: boolean
  readonly onShowLibrariesOnlyChange?: (value: boolean) => void
}

export function ExploreListView({
  libraryProjects,
  regularProjects,
  loading,
  error,
  searchQuery = '',
  onSearchChange,
  showLibrariesOnly = false,
  onShowLibrariesOnlyChange
}: ExploreListViewProps) {
  if (loading) {
    return (
      <div className={styles.loading}>
        <div className={styles.spinner} />
        <p>Loading projects...</p>
      </div>
    )
  }
  if (error) {
    return <div className={styles.error}>{error}</div>
  }

  const hasProjects = libraryProjects.length > 0 || regularProjects.length > 0

  return (
    <div className={styles.exploreContent}>
      <div className={styles.searchContainer}>
        {onSearchChange && (
          <Input
            type='text'
            placeholder='Search by name, author, or tag...'
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            data-testid='search-input'
          />
        )}
        {onShowLibrariesOnlyChange && (
          <Checkbox
            label='Show libraries only'
            checked={showLibrariesOnly}
            onChange={(e) => onShowLibrariesOnlyChange(e.target.checked)}
          />
        )}
      </div>
      {hasProjects ? (
        <div className={styles.sectionsContainer}>
          {libraryProjects.length > 0 && (
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>Libraries</h2>
              <div className={styles.list}>
                {libraryProjects.map((project) => (
                  <ProjectListItem key={project.id} {...project} />
                ))}
              </div>
            </div>
          )}
          {!showLibrariesOnly && regularProjects.length > 0 && (
            <div className={styles.section}>
              {libraryProjects.length > 0 && (
                <h2 className={styles.sectionTitle}>Projects</h2>
              )}
              <div className={styles.list}>
                {regularProjects.map((project) => (
                  <ProjectListItem key={project.id} {...project} />
                ))}
              </div>
            </div>
          )}
        </div>
      ) : (
        <div className={styles.empty}>
          <p>No projects found</p>
          {searchQuery || showLibrariesOnly ? (
            <p>Try a different search term or filter</p>
          ) : (
            <>
              <p>Be the first to share a project!</p>
              <Link to='/' style={{ marginTop: '1rem' }}>
                <Button>Try the Playground</Button>
              </Link>
            </>
          )}
        </div>
      )}
    </div>
  )
}

function ProjectListItem({
  id: _id,
  name,
  authorName,
  description,
  tags,
  isOwner,
  isShared,
  visibility,
  isLibrary,
  filesCount,
  sharesCount,
  updatedAt,
  createdAt: _createdAt,
  thumbnailUrl,
  onClick,
  onFork,
  canFork
}: ProjectItemProps) {
  const handleFork = (e: React.MouseEvent) => {
    e.stopPropagation()
    onFork?.()
  }

  return (
    <button
      type='button'
      className={styles.listItem}
      data-testid='project-item'
      onClick={onClick}
      onKeyDown={(e) => (e.key === 'Enter' || e.key === ' ') && onClick()}
    >
      {thumbnailUrl && (
        <div className={styles.thumbnailContainer}>
          <img
            src={thumbnailUrl}
            alt={`${name} thumbnail`}
            className={styles.thumbnail}
          />
        </div>
      )}
      <div className={styles.projectContent}>
        <div className={styles.rowTop}>
          <span className={styles.projectName}>{name}</span>
          <span className={styles.typeBadges}>
            {isShared && !isOwner && <Badge variant='shared'>Shared</Badge>}
            {visibility === 'public' && <Badge variant='public'>Public</Badge>}
            {isLibrary && <Badge variant='library'>Library</Badge>}
          </span>
        </div>
        {isOwner ? (
          <div className={styles.authorName}>
            <Badge variant='owner'>Owner</Badge>
          </div>
        ) : (
          <div className={styles.authorName}>by {authorName}</div>
        )}
        {description && <div className={styles.description}>{description}</div>}
        {tags.length > 0 && (
          <div className={styles.tagsContainer}>
            <TagsList tags={tags} />
          </div>
        )}
        <div className={styles.metaLine}>
          <span>{pluralize(filesCount, 'file')}</span>
          <span>{pluralize(sharesCount, 'share')}</span>
          <span>Updated {formatDate(updatedAt)}</span>
          {canFork && (
            <Button className={styles.forkButton} onClick={handleFork}>
              Fork
            </Button>
          )}
        </div>
      </div>
    </button>
  )
}

function pluralize(count: number, singular: string): string {
  return `${count} ${singular}${count === 1 ? '' : 's'}`
}

function formatDate(date: Date): string {
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  if (days === 0) return 'today'
  if (days === 1) return 'yesterday'
  if (days < 7) return `${days} days ago`
  if (days < 30) return `${Math.floor(days / 7)} weeks ago`
  if (days < 365) return `${Math.floor(days / 30)} months ago`
  return `${Math.floor(days / 365)} years ago`
}
