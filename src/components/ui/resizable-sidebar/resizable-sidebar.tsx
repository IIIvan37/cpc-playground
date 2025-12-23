import { type ReactNode, useCallback, useEffect, useRef, useState } from 'react'
import { ResizableSidebarView } from './resizable-sidebar.view'

type ResizableSidebarProps = Readonly<{
  children: ReactNode
  defaultWidth?: number
  minWidth?: number
  maxWidth?: number
  storageKey?: string
}>

/**
 * Container component for resizable sidebar
 * Handles resize logic, collapse state, and localStorage persistence
 */
export function ResizableSidebar({
  children,
  defaultWidth = 220,
  minWidth = 180,
  maxWidth = 320,
  storageKey = 'sidebar-width'
}: ResizableSidebarProps) {
  // Load persisted state
  const getInitialWidth = () => {
    if (globalThis.window === undefined) return defaultWidth
    const stored = localStorage.getItem(storageKey)
    if (stored) {
      const parsed = Number.parseInt(stored, 10)
      if (!Number.isNaN(parsed) && parsed >= minWidth && parsed <= maxWidth) {
        return parsed
      }
    }
    return defaultWidth
  }

  const getInitialCollapsed = () => {
    if (globalThis.window === undefined) return false
    const stored = localStorage.getItem(`${storageKey}-collapsed`)
    return stored === 'true'
  }

  const [width, setWidth] = useState(getInitialWidth)
  const [isCollapsed, setIsCollapsed] = useState(getInitialCollapsed)
  const [isResizing, setIsResizing] = useState(false)
  const sidebarRef = useRef<HTMLDivElement>(null)

  // Persist width
  useEffect(() => {
    localStorage.setItem(storageKey, width.toString())
  }, [width, storageKey])

  // Persist collapsed state
  useEffect(() => {
    localStorage.setItem(`${storageKey}-collapsed`, isCollapsed.toString())
  }, [isCollapsed, storageKey])

  const startResizing = useCallback((e: React.MouseEvent) => {
    e.preventDefault()
    setIsResizing(true)
  }, [])

  const stopResizing = useCallback(() => {
    setIsResizing(false)
  }, [])

  const resize = useCallback(
    (e: MouseEvent) => {
      if (!isResizing || !sidebarRef.current) return

      const sidebarRect = sidebarRef.current.getBoundingClientRect()
      const newWidth = e.clientX - sidebarRect.left

      if (newWidth >= minWidth && newWidth <= maxWidth) {
        setWidth(newWidth)
      }
    },
    [isResizing, minWidth, maxWidth]
  )

  useEffect(() => {
    if (isResizing) {
      globalThis.addEventListener('mousemove', resize)
      globalThis.addEventListener('mouseup', stopResizing)
      document.body.style.cursor = 'col-resize'
      document.body.style.userSelect = 'none'
    }

    return () => {
      globalThis.removeEventListener('mousemove', resize)
      globalThis.removeEventListener('mouseup', stopResizing)
      document.body.style.cursor = ''
      document.body.style.userSelect = ''
    }
  }, [isResizing, resize, stopResizing])

  const toggleCollapse = useCallback(() => {
    setIsCollapsed((prev) => !prev)
  }, [])

  return (
    <ResizableSidebarView
      width={width}
      isCollapsed={isCollapsed}
      isResizing={isResizing}
      sidebarRef={sidebarRef}
      onToggleCollapse={toggleCollapse}
      onStartResizing={startResizing}
    >
      {children}
    </ResizableSidebarView>
  )
}

export default ResizableSidebar
