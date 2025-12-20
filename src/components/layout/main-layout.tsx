import { useAtomValue } from 'jotai'
import { ConsolePanel } from '@/components/console/console-panel'
import { CodeEditor } from '@/components/editor/code-editor'
import { EmulatorCanvas } from '@/components/emulator/emulator-canvas'
import { useAuth } from '@/hooks'
import { useAutoSaveFile } from '@/hooks/use-auto-save-file'
import { useSharedCode } from '@/hooks/use-shared-code'
import { viewModeAtom } from '@/store'
import { AppHeader } from './app-header'
import styles from './main-layout.module.css'
import { ProgramManager } from './program-manager'
import { ProjectBrowser } from './project-browser'
import { Toolbar } from './toolbar'

export function MainLayout() {
  const viewMode = useAtomValue(viewModeAtom)
  const { user } = useAuth()

  // Load shared code from URL if present
  useSharedCode()

  // Auto-save file content (only for authenticated users with cloud projects)
  useAutoSaveFile()

  return (
    <div className={styles.layout}>
      <AppHeader />

      <Toolbar />

      <main className={styles.main}>
        {user && (
          <div className={styles.sidebar}>
            <ProjectBrowser />
          </div>
        )}
        <div
          className={`${styles.panel} ${styles.editorPanel}`}
          data-hidden={viewMode === 'emulator'}
        >
          <ProgramManager />
          <CodeEditor />
        </div>
        <div
          className={`${styles.panel} ${styles.emulatorPanel}`}
          data-hidden={viewMode === 'emulator'}
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
