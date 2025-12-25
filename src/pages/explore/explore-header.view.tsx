import { PlusIcon } from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import styles from './explore.module.css'

export interface ExploreHeaderViewProps {
  readonly title: string
  readonly subtitle: string
  readonly showNewProjectButton: boolean
  readonly onNewProject: () => void
}

export function ExploreHeaderView({
  title,
  subtitle,
  showNewProjectButton,
  onNewProject
}: ExploreHeaderViewProps) {
  return (
    <div className={styles.pageHeader}>
      <div className={styles.headerRow}>
        <div className={styles.headerContent}>
          <h1 className={styles.title}>{title}</h1>
          <p className={styles.subtitle}>{subtitle}</p>
        </div>
        {showNewProjectButton && (
          <Button onClick={onNewProject}>
            <PlusIcon /> New Project
          </Button>
        )}
      </div>
    </div>
  )
}
