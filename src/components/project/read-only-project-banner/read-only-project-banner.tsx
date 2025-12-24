import { useAtomValue, useSetAtom } from 'jotai'
import { codeAtom, isReadOnlyModeAtom, viewOnlyProjectAtom } from '@/store'
import { ReadOnlyProjectBannerView } from './read-only-project-banner.view'

/**
 * Container component for read-only project banner
 * Handles state management and delegates rendering to View
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
    <ReadOnlyProjectBannerView
      projectName={viewOnlyProject.name.value}
      onClose={handleClose}
    />
  )
}
