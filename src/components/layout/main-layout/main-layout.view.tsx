import type { ReactNode } from 'react'
import styles from './main-layout.module.css'

type MainLayoutViewProps = Readonly<{
  viewMode: 'editor' | 'emulator' | 'split' | 'markdown'
  showSidebar: boolean
  readOnlyBanner?: ReactNode
  toolbar: ReactNode
  sidebar?: ReactNode
  editor: ReactNode
  emulator: ReactNode
  markdown: ReactNode
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
  markdown,
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
          data-hidden={viewMode === 'emulator' || viewMode === 'markdown'}
        >
          {editor}
        </div>
        <div
          className={`${styles.panel} ${styles.emulatorPanel}`}
          data-hidden={viewMode === 'editor' || viewMode === 'markdown'}
        >
          {emulator}
        </div>
        <div
          className={`${styles.panel} ${styles.markdownPanel}`}
          data-hidden={viewMode !== 'markdown'}
        >
          {markdown}
        </div>
      </main>

      <footer className={styles.footer}>{console}</footer>
    </div>
  )
}
