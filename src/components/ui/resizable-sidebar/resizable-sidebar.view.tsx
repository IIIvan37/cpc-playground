import { ChevronLeftIcon } from '@radix-ui/react-icons'
import type { ReactNode, RefObject } from 'react'
import styles from './resizable-sidebar.module.css'

export type ResizableSidebarViewProps = Readonly<{
  children: ReactNode
  width: number
  isCollapsed: boolean
  isResizing: boolean
  sidebarRef: RefObject<HTMLDivElement | null>
  onToggleCollapse: () => void
  onStartResizing: (e: React.MouseEvent) => void
}>

export function ResizableSidebarView({
  children,
  width,
  isCollapsed,
  isResizing,
  sidebarRef,
  onToggleCollapse,
  onStartResizing
}: ResizableSidebarViewProps) {
  return (
    <div
      ref={sidebarRef}
      className={`${styles.wrapper} ${isCollapsed ? styles.collapsed : ''}`}
      style={{ width: isCollapsed ? undefined : width }}
    >
      <div className={styles.content}>{children}</div>

      <button
        type='button'
        className={styles.collapseButton}
        onClick={onToggleCollapse}
        title={isCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
        aria-label={isCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
      >
        <ChevronLeftIcon className={styles.collapseIcon} />
      </button>

      {!isCollapsed && (
        <div
          className={`${styles.resizeHandle} ${
            isResizing ? styles.resizing : ''
          }`}
          onMouseDown={onStartResizing}
        />
      )}
    </div>
  )
}
