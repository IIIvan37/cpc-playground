import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { TagsList } from '@/components/ui/tag'
import styles from './explore.module.css'

export interface ExploreListViewProps {
  readonly projects: ReadonlyArray<{
    id: string
    name: string
    authorName: string
    description?: string | null
    tags: string[]
    isOwner: boolean
    isShared: boolean
    visibility: string
    isLibrary: boolean
    filesCount: number
    sharesCount: number
    updatedAt: Date
    createdAt: Date
    thumbnailUrl?: string | null
    onClick: () => void
  }>
  readonly loading?: boolean
  readonly error?: string | null
  readonly searchQuery?: string
  readonly onSearchChange?: (query: string) => void
}

export function ExploreListView({
  projects,
  loading,
  error,
  searchQuery = '',
  onSearchChange
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

  return (
    <>
      {onSearchChange && (
        <div className={styles.searchContainer}>
          <Input
            type='text'
            placeholder='Search by name, author, or tag...'
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            data-testid='search-input'
          />
        </div>
      )}
      {projects.length === 0 ? (
        <div className={styles.empty}>
          <p>No projects found</p>
          {searchQuery ? (
            <p>Try a different search term</p>
          ) : (
            <p>Be the first to share a project!</p>
          )}
        </div>
      ) : (
        <div className={styles.list}>
          {projects.map((project) => (
            <ProjectListItem key={project.id} {...project} />
          ))}
        </div>
      )}
    </>
  )
}

export type ProjectListItemProps = {
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
}

export function ProjectListItem({
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
  onClick
}: ProjectListItemProps) {
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
