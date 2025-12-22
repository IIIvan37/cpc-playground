import { useAtomValue } from 'jotai'
import { ConsolePanel } from '@/components/console'
import { CodeEditor } from '@/components/editor'
import { EmulatorCanvas } from '@/components/emulator'
import { ProjectBrowser } from '@/components/project/project-browser'
import { useAuth } from '@/hooks'
import { useAutoSaveFile } from '@/hooks/use-auto-save-file'
import { useSharedCode } from '@/hooks/use-shared-code'
import { viewModeAtom } from '@/store'
import { AppHeader } from '../app-header/app-header'
import { Toolbar } from '../toolbar/toolbar'
import styles from './main-layout.module.css'

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
