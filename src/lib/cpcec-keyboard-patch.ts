/**
 * CPCEC Keyboard Event Patch
 *
 * This module patches addEventListener to intercept CPCEC's keyboard listeners.
 * It must be imported BEFORE CPCEC is loaded.
 *
 * CPCEC (via Emscripten/SDL2) registers keyboard event listeners on window/document.
 * These listeners capture all keyboard events, even when the emulator doesn't have focus.
 * This patch wraps those listeners to check a global flag before processing.
 */

import { createLogger } from './logger'

/** Global flag to control whether CPCEC should receive keyboard events */
let cpcecKeyboardEnabled = false

/**
 * Enable or disable CPCEC keyboard event processing
 */
export function setCpcecKeyboardEnabled(enabled: boolean): void {
  cpcecKeyboardEnabled = enabled
}

/**
 * Check if CPCEC keyboard is currently enabled
 */
export function isCpcecKeyboardEnabled(): boolean {
  return cpcecKeyboardEnabled
}

// Store original addEventListener
const originalWindowAddEventListener =
  globalThis.addEventListener.bind(globalThis)
const originalDocumentAddEventListener =
  document.addEventListener.bind(document)

// Track if we've already patched
let patched = false
const logger = createLogger('CPCECPatch')

/**
 * Wrap a keyboard event listener to check the enabled flag
 */
function wrapKeyboardListener(
  listener: EventListenerOrEventListenerObject
): EventListener {
  return function wrappedListener(this: unknown, event: Event) {
    // Only block if keyboard is disabled AND the event is from keyboard
    if (!cpcecKeyboardEnabled) {
      return // Block the event from reaching CPCEC
    }

    // Call the original listener
    if (typeof listener === 'function') {
      listener.call(this, event)
    } else {
      listener.handleEvent(event)
    }
  }
}

/**
 * Check if this is a keyboard event type
 */
function isKeyboardEventType(type: string): boolean {
  return type === 'keydown' || type === 'keyup' || type === 'keypress'
}

/**
 * Install the keyboard event patch
 * This replaces window.addEventListener and document.addEventListener
 * to intercept keyboard listeners registered by CPCEC
 */
export function installCpcecKeyboardPatch(): void {
  if (patched) return
  patched = true

  // Patch window.addEventListener
  globalThis.addEventListener = function patchedWindowAddEventListener(
    type: string,
    listener: EventListenerOrEventListenerObject | null,
    options?: boolean | AddEventListenerOptions
  ): void {
    if (listener && isKeyboardEventType(type)) {
      // Wrap keyboard listeners
      const wrappedListener = wrapKeyboardListener(listener)
      originalWindowAddEventListener(type, wrappedListener, options)
      return
    }
    if (listener) {
      originalWindowAddEventListener(type, listener, options)
    }
  } as typeof globalThis.addEventListener

  // Patch document.addEventListener
  document.addEventListener = function patchedDocumentAddEventListener(
    type: string,
    listener: EventListenerOrEventListenerObject | null,
    options?: boolean | AddEventListenerOptions
  ): void {
    if (listener && isKeyboardEventType(type)) {
      // Wrap keyboard listeners
      const wrappedListener = wrapKeyboardListener(listener)
      originalDocumentAddEventListener(type, wrappedListener, options)
      return
    }
    if (listener) {
      originalDocumentAddEventListener(type, listener, options)
    }
  } as typeof document.addEventListener

  logger.info('Keyboard event patch installed')
}

// Auto-install on import
installCpcecKeyboardPatch()
