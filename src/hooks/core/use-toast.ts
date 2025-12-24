/**
 * Toast notification store and hook
 *
 * Provides a simple toast notification system using Jotai for state management.
 * Toasts auto-dismiss after a configurable duration.
 */

import { atom, useAtom, useSetAtom } from 'jotai'
import { useCallback } from 'react'

export type ToastType = 'success' | 'error' | 'warning' | 'info'

export interface Toast {
  id: string
  type: ToastType
  title: string
  message?: string
  duration?: number
}

type AddToastParams = Omit<Toast, 'id'>

// Atom to store all active toasts
export const toastsAtom = atom<Toast[]>([])

// Default duration in milliseconds
const DEFAULT_DURATION = 5000

let toastId = 0

function generateId(): string {
  return `toast-${++toastId}-${Date.now()}`
}

/**
 * Hook to manage toast notifications
 */
export function useToast() {
  const [toasts, setToasts] = useAtom(toastsAtom)

  const removeToast = useCallback(
    (id: string) => {
      setToasts((prev) => prev.filter((t) => t.id !== id))
    },
    [setToasts]
  )

  const addToast = useCallback(
    (params: AddToastParams) => {
      const id = generateId()
      const duration = params.duration ?? DEFAULT_DURATION

      const toast: Toast = {
        ...params,
        id,
        duration
      }

      setToasts((prev) => [...prev, toast])

      // Auto-dismiss after duration
      if (duration > 0) {
        setTimeout(() => {
          removeToast(id)
        }, duration)
      }

      return id
    },
    [setToasts, removeToast]
  )

  const success = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'success', title, message })
    },
    [addToast]
  )

  const error = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'error', title, message, duration: 8000 })
    },
    [addToast]
  )

  const warning = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'warning', title, message })
    },
    [addToast]
  )

  const info = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'info', title, message })
    },
    [addToast]
  )

  const clearAll = useCallback(() => {
    setToasts([])
  }, [setToasts])

  return {
    toasts,
    addToast,
    removeToast,
    success,
    error,
    warning,
    info,
    clearAll
  }
}

/**
 * Hook to only add toasts (lighter, for components that don't need to read)
 */
export function useToastActions() {
  const setToasts = useSetAtom(toastsAtom)

  const removeToast = useCallback(
    (id: string) => {
      setToasts((prev) => prev.filter((t) => t.id !== id))
    },
    [setToasts]
  )

  const addToast = useCallback(
    (params: AddToastParams) => {
      const id = generateId()
      const duration = params.duration ?? DEFAULT_DURATION

      const toast: Toast = {
        ...params,
        id,
        duration
      }

      setToasts((prev) => [...prev, toast])

      if (duration > 0) {
        setTimeout(() => {
          removeToast(id)
        }, duration)
      }

      return id
    },
    [setToasts, removeToast]
  )

  const success = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'success', title, message })
    },
    [addToast]
  )

  const error = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'error', title, message, duration: 8000 })
    },
    [addToast]
  )

  const warning = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'warning', title, message })
    },
    [addToast]
  )

  const info = useCallback(
    (title: string, message?: string) => {
      return addToast({ type: 'info', title, message })
    },
    [addToast]
  )

  return { success, error, warning, info, addToast }
}
