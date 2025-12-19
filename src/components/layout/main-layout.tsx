import { useAtomValue } from 'jotai'
import { ConsolePanel } from '@/components/console/console-panel'
import { CodeEditor } from '@/components/editor/code-editor'
import { EmulatorCanvas } from '@/components/emulator/emulator-canvas'
import { viewModeAtom } from '@/store'
import styles from './main-layout.module.css'
import { Toolbar } from './toolbar'

export function MainLayout() {
  const viewMode = useAtomValue(viewModeAtom)

  return (
    <div className={styles.layout}>
      <header className={styles.header}>
        <h1 className={styles.title}>CPC Playground</h1>
        <span className={styles.subtitle}>Z80 Assembly IDE</span>
      </header>

      <Toolbar />

      <main className={styles.main}>
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
