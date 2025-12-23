import { FileIcon, PersonIcon } from '@radix-ui/react-icons'
import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import type { Project } from '@/domain/entities/project.entity'
import { useAuth } from '@/hooks/use-auth'
import { container } from '@/infrastructure/container'
import styles from './explore.module.css'

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

  const { user } = useAuth()
  const navigate = useNavigate()

  useEffect(() => {
    async function fetchProjects() {
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
    }

    fetchProjects()
  }, [user?.id])

  const handleProjectClick = (project: Project) => {
    // Navigate to project (using a query param or similar approach)
    // For now, we'll use the project ID in the URL
    navigate(`/?project=${project.id}`)
  }

  const isOwner = (project: Project) => user?.id === project.userId
  const isShared = (project: Project) =>
    project.userShares.some((share) => share.userId === user?.id)

  const renderContent = () => {
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

    if (projects.length === 0) {
      return (
        <div className={styles.empty}>
          <p>No projects found</p>
          <p>Be the first to share a project!</p>
        </div>
      )
    }

    return (
      <div className={styles.grid}>
        {projects.map((project) => (
          <button
            type='button'
            key={project.id}
            className={styles.card}
            onClick={() => handleProjectClick(project)}
          >
            <div className={styles.cardHeader}>
              <h2 className={styles.cardTitle}>{project.name.value}</h2>
              <div className={styles.badges}>
                {isOwner(project) && (
                  <span className={`${styles.badge} ${styles.badgeOwner}`}>
                    Owner
                  </span>
                )}
                {isShared(project) && !isOwner(project) && (
                  <span className={`${styles.badge} ${styles.badgeShared}`}>
                    Shared
                  </span>
                )}
                {project.visibility.value === 'public' && (
                  <span className={`${styles.badge} ${styles.badgePublic}`}>
                    Public
                  </span>
                )}
                {project.isLibrary && (
                  <span className={`${styles.badge} ${styles.badgeLibrary}`}>
                    Library
                  </span>
                )}
              </div>
            </div>

            {project.description && (
              <p className={styles.description}>{project.description}</p>
            )}

            {project.tags.length > 0 && (
              <div className={styles.tags}>
                {project.tags.map((tag) => (
                  <span key={tag} className={styles.tag}>
                    {tag}
                  </span>
                ))}
              </div>
            )}

            <div className={styles.cardMeta}>
              <span className={styles.metaItem}>
                <FileIcon />
                {project.files.length} file
                {project.files.length === 1 ? '' : 's'}
              </span>
              <span className={styles.metaItem}>
                <PersonIcon />
                {project.userShares.length} share
                {project.userShares.length === 1 ? '' : 's'}
              </span>
              <span className={styles.metaItem}>
                Updated {formatDate(project.updatedAt)}
              </span>
            </div>
          </button>
        ))}
      </div>
    )
  }

  return (
    <div className={styles.container}>
      <div className={styles.pageHeader}>
        <h1 className={styles.title}>Explore Projects</h1>
        <p className={styles.subtitle}>
          {user
            ? 'Browse public projects and your shared projects'
            : 'Browse public projects from the community'}
        </p>
      </div>

      <main className={styles.content}>{renderContent()}</main>
    </div>
  )
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
