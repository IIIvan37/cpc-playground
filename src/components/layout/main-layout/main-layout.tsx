import { useAtomValue } from 'jotai'
import { ConsolePanel } from '@/components/console'
import { CodeEditor } from '@/components/editor'
import { EmulatorCanvas } from '@/components/emulator'
import { FileBrowser } from '@/components/project/file-browser'
import { ReadOnlyProjectBanner } from '@/components/project/read-only-project-banner'
import { useProjectFromUrl } from '@/hooks'
import { useAutoSaveFile } from '@/hooks/use-auto-save-file'
import { useSharedCode } from '@/hooks/use-shared-code'
import { activeProjectAtom, isReadOnlyModeAtom, viewModeAtom } from '@/store'
import { Toolbar } from '../toolbar/toolbar'
import styles from './main-layout.module.css'

export function MainLayout() {
  const viewMode = useAtomValue(viewModeAtom)
  const isReadOnlyMode = useAtomValue(isReadOnlyModeAtom)
  const activeProject = useAtomValue(activeProjectAtom)

  // Load shared code from URL if present
  useSharedCode()

  // Load project from URL if present (handles public projects)
  useProjectFromUrl()

  // Auto-save file content (only for authenticated users with cloud projects)
  useAutoSaveFile()

  return (
    <div className={styles.layout}>
      {isReadOnlyMode && <ReadOnlyProjectBanner />}
      <Toolbar />

      <main className={styles.main}>
        {activeProject && (
          <div className={styles.sidebar}>
            <FileBrowser />
          </div>
        )}
        <div
          className={`${styles.panel} ${styles.editorPanel}`}
          data-hidden={viewMode === 'emulator'}
        >
          <CodeEditor />
        </div>
        <div
          className={`${styles.panel} ${styles.emulatorPanel}`}
          data-hidden={viewMode === 'editor'}
        >
          <EmulatorCanvas />
        </div>
      </main>

      <footer className={styles.footer}>
        <ConsolePanel />
      </footer>
    </div>
  )
}
