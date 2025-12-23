import { Cross2Icon, EyeOpenIcon } from '@radix-ui/react-icons'
import { useAtomValue, useSetAtom } from 'jotai'
import { codeAtom, isReadOnlyModeAtom, viewOnlyProjectAtom } from '@/store'
import styles from './read-only-project-banner.module.css'

/**
 * Banner displayed when viewing a public project in read-only mode
 */
export function ReadOnlyProjectBanner() {
  const viewOnlyProject = useAtomValue(viewOnlyProjectAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)
  const setCode = useSetAtom(codeAtom)

  const handleClose = () => {
    setIsReadOnlyMode(false)
    setViewOnlyProject(null)
    setCode('')
  }

  if (!viewOnlyProject) return null

  return (
    <div className={styles.banner}>
      <div className={styles.info}>
        <EyeOpenIcon />
        <span>
          Viewing{' '}
          <span className={styles.projectName}>
            {viewOnlyProject.name.value}
          </span>{' '}
          in read-only mode
        </span>
      </div>
      <button
        type='button'
        className={styles.closeButton}
        onClick={handleClose}
        title='Close project'
      >
        <Cross2Icon />
      </button>
    </div>
  )
}
