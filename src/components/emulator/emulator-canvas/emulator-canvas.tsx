import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import {
  useAuth,
  useCurrentProject,
  useEmulator,
  useSaveThumbnail
} from '@/hooks'
import { setCpcecKeyboardEnabled } from '@/lib/cpcec-keyboard-patch'
import styles from './emulator-canvas.module.css'
import { EmulatorCanvasView } from './emulator-canvas.view'

/** Flag to control whether CPCEC should receive keyboard events */
let emulatorHasFocus = false

export function getEmulatorFocus() {
  return emulatorHasFocus
}

/** Get CPCEC Module reference */
function getCpcecModule(): unknown {
  return (globalThis as Record<string, unknown>).Module
}

/**
 * Singleton canvas element that persists across component mounts/unmounts.
 * This is necessary because CPCEC binds to the canvas once and cannot rebind
 * to a new canvas element.
 */
let persistentCanvas: HTMLCanvasElement | null = null

function getOrCreatePersistentCanvas(): HTMLCanvasElement {
  if (!persistentCanvas) {
    persistentCanvas = document.createElement('canvas')
    persistentCanvas.width = 768
    persistentCanvas.height = 544
    // Use the CSS module class for proper styling
    persistentCanvas.className = styles.canvas
  }
  return persistentCanvas
}

/**
 * Get the emulator canvas element for screenshot capture
 */
export function getEmulatorCanvas(): HTMLCanvasElement | null {
  return persistentCanvas
}

/**
 * Container component for CPC emulator canvas
 * Handles keyboard blocking, CPC keyboard mappings, and emulator initialization
 */
export function EmulatorCanvas() {
  const wrapperRef = useRef<HTMLButtonElement>(null)
  const containerRef = useRef<HTMLDivElement>(null)
  const { initialize, isReady, setKeyboardLayout } = useEmulator()
  const { user } = useAuth()
  const { project } = useCurrentProject()
  const { saveThumbnail, loading: savingThumbnail } = useSaveThumbnail()
  const [hasFocus, setHasFocus] = useState(false)
  const [currentKeyboardLayout, setCurrentKeyboardLayout] = useState('azerty')

  // Can save thumbnail if user owns the current project
  const canSaveThumbnail = !!(user && project && project.userId === user.id)

  // Get or create the persistent canvas and attach it to the wrapper
  useEffect(() => {
    const canvas = getOrCreatePersistentCanvas()
    const wrapper = wrapperRef.current

    if (wrapper && canvas.parentElement !== wrapper) {
      // Move canvas into this component's wrapper
      wrapper.appendChild(canvas)
    }

    // Initialize emulator if not ready
    if (!isReady) {
      initialize(canvas)
    }

    // Cleanup: don't remove canvas from DOM, just let it stay
    // It will be moved to the new wrapper when component remounts
  }, [initialize, isReady])

  // Handle special CPC keyboard mappings when emulator has focus
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!emulatorHasFocus) return

      const Module = getCpcecModule() as Record<string, unknown> | null
      if (!Module) return

      // Map Option/Alt key to CPC COPY (0x09)
      if (
        e.altKey &&
        !e.shiftKey &&
        !e.ctrlKey &&
        !e.metaKey &&
        (e.code === 'AltLeft' || e.code === 'AltRight')
      ) {
        e.preventDefault()
        const press = Module._em_key_press as
          | ((key: number) => void)
          | undefined
        if (press) press(0x09)
      }

      // Map Shift+0-9 to CPC function keys F0-F9
      if (e.shiftKey && e.code?.startsWith('Digit')) {
        e.preventDefault()
        e.stopPropagation()
        const fnNum = Number.parseInt(e.code.charAt(5), 10)
        const pressFn = Module._em_press_fn as
          | ((fn: number) => void)
          | undefined
        if (pressFn) pressFn(fnNum)
      }
    }

    const handleKeyUp = (e: KeyboardEvent) => {
      if (!emulatorHasFocus) return

      const Module = getCpcecModule() as Record<string, unknown> | null
      if (!Module) return

      // Release CPC COPY when Option/Alt is released
      if (e.code === 'AltLeft' || e.code === 'AltRight') {
        const release = Module._em_key_release as
          | ((key: number) => void)
          | undefined
        if (release) release(0x09)
      }

      // Handle Shift+number key release for CPC function keys
      if (e.code?.startsWith('Digit')) {
        const fnNum = Number.parseInt(e.code.charAt(5), 10)
        const releaseFn = Module._em_release_fn as
          | ((fn: number) => void)
          | undefined
        if (releaseFn) releaseFn(fnNum)
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    document.addEventListener('keyup', handleKeyUp)

    return () => {
      document.removeEventListener('keydown', handleKeyDown)
      document.removeEventListener('keyup', handleKeyUp)
    }
  }, [])

  const handleFocus = useCallback(() => {
    emulatorHasFocus = true
    setHasFocus(true)
    // Enable CPCEC keyboard processing
    setCpcecKeyboardEnabled(true)
  }, [])

  const handleBlur = useCallback(() => {
    emulatorHasFocus = false
    setHasFocus(false)
    // Disable CPCEC keyboard processing
    setCpcecKeyboardEnabled(false)
  }, [])

  const handleSaveThumbnail = useCallback(() => {
    saveThumbnail()
  }, [saveThumbnail])

  const handleKeyboardLayoutChange = useCallback(
    (layout: string) => {
      setCurrentKeyboardLayout(layout)
      setKeyboardLayout(layout)
    },
    [setKeyboardLayout]
  )

  const statusText = useMemo(() => {
    if (!isReady) return '○ Loading...'
    return hasFocus ? '● Active' : '○ Click to type'
  }, [isReady, hasFocus])

  return (
    <EmulatorCanvasView
      wrapperRef={wrapperRef}
      containerRef={containerRef}
      hasFocus={hasFocus}
      statusText={statusText}
      canSaveThumbnail={canSaveThumbnail}
      savingThumbnail={savingThumbnail}
      currentKeyboardLayout={currentKeyboardLayout}
      onFocus={handleFocus}
      onBlur={handleBlur}
      onSaveThumbnail={handleSaveThumbnail}
      onKeyboardLayoutChange={handleKeyboardLayoutChange}
    />
  )
}
