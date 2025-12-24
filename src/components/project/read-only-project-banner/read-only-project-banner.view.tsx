import { Cross2Icon, EyeOpenIcon } from '@radix-ui/react-icons'
import styles from './read-only-project-banner.module.css'

type ReadOnlyProjectBannerViewProps = Readonly<{
  projectName: string
  onClose: () => void
}>

/**
 * View component for read-only project banner
 * Displays project name and close button
 */
export function ReadOnlyProjectBannerView({
  projectName,
  onClose
}: ReadOnlyProjectBannerViewProps) {
  return (
    <div className={styles.banner}>
      <div className={styles.info}>
        <EyeOpenIcon />
        <span>
          Viewing <span className={styles.projectName}>{projectName}</span> in
          read-only mode
        </span>
      </div>
      <button
        type='button'
        className={styles.closeButton}
        onClick={onClose}
        title='Close project'
      >
        <Cross2Icon />
      </button>
    </div>
  )
}
