import type { ReactNode } from 'react'
import styles from './main-layout.module.css'

type MainLayoutViewProps = Readonly<{
  viewMode: 'editor' | 'emulator' | 'split'
  showSidebar: boolean
  readOnlyBanner?: ReactNode
  toolbar: ReactNode
  sidebar?: ReactNode
  editor: ReactNode
  emulator: ReactNode
  console: ReactNode
}>

export function MainLayoutView({
  viewMode,
  showSidebar,
  readOnlyBanner,
  toolbar,
  sidebar,
  editor,
  emulator,
  console
}: MainLayoutViewProps) {
  return (
    <div className={styles.layout}>
      {readOnlyBanner}
      {toolbar}

      <main className={styles.main}>
        {showSidebar && <div className={styles.sidebar}>{sidebar}</div>}
        <div
          className={`${styles.panel} ${styles.editorPanel}`}
          data-hidden={viewMode === 'emulator'}
        >
          {editor}
        </div>
        <div
          className={`${styles.panel} ${styles.emulatorPanel}`}
          data-hidden={viewMode === 'editor'}
        >
          {emulator}
        </div>
      </main>

      <footer className={styles.footer}>{console}</footer>
    </div>
  )
}
