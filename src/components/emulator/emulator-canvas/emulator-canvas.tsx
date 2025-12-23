import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { useEmulator } from '@/hooks'
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
 * Container component for CPC emulator canvas
 * Handles keyboard blocking, CPC keyboard mappings, and emulator initialization
 */
export function EmulatorCanvas() {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const containerRef = useRef<HTMLDivElement>(null)
  const { initialize, isReady } = useEmulator()
  const [hasFocus, setHasFocus] = useState(false)

  // Initialize emulator when canvas is ready
  useEffect(() => {
    if (canvasRef.current && !isReady) {
      initialize(canvasRef.current)
    }
  }, [initialize, isReady])

  // Block keyboard events from reaching CPCEC (which listens on window)
  useEffect(() => {
    const blockKeyboardForCPCEC = (e: KeyboardEvent) => {
      if (emulatorHasFocus) return
      e.stopPropagation()
    }

    document.body.addEventListener('keydown', blockKeyboardForCPCEC, false)
    document.body.addEventListener('keyup', blockKeyboardForCPCEC, false)
    document.body.addEventListener('keypress', blockKeyboardForCPCEC, false)

    return () => {
      document.body.removeEventListener('keydown', blockKeyboardForCPCEC, false)
      document.body.removeEventListener('keyup', blockKeyboardForCPCEC, false)
      document.body.removeEventListener(
        'keypress',
        blockKeyboardForCPCEC,
        false
      )
    }
  }, [])

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
  }, [])

  const handleBlur = useCallback(() => {
    emulatorHasFocus = false
    setHasFocus(false)
  }, [])

  const statusText = useMemo(() => {
    if (!isReady) return '○ Loading...'
    return hasFocus ? '● Active' : '○ Click to type'
  }, [isReady, hasFocus])

  return (
    <EmulatorCanvasView
      canvasRef={canvasRef}
      containerRef={containerRef}
      hasFocus={hasFocus}
      statusText={statusText}
      onFocus={handleFocus}
      onBlur={handleBlur}
    />
  )
}
