import { useCallback, useState } from 'react'

type ConfirmOptions = {
  title: string
  message: string
  confirmLabel?: string
  cancelLabel?: string
  variant?: 'danger' | 'warning' | 'default'
}

type ConfirmState = ConfirmOptions & {
  isOpen: boolean
  resolve: ((value: boolean) => void) | null
}

/**
 * Hook to show confirmation dialogs
 * Returns a promise that resolves to true (confirmed) or false (cancelled)
 *
 * Usage:
 * ```tsx
 * const { confirm, dialogProps } = useConfirmDialog()
 *
 * const handleDelete = async () => {
 *   const confirmed = await confirm({
 *     title: 'Delete file',
 *     message: 'Are you sure?',
 *     variant: 'danger'
 *   })
 *   if (confirmed) {
 *     // perform delete
 *   }
 * }
 *
 * return (
 *   <>
 *     <button onClick={handleDelete}>Delete</button>
 *     <ConfirmDialog {...dialogProps} />
 *   </>
 * )
 * ```
 */
export function useConfirmDialog() {
  const [state, setState] = useState<ConfirmState>({
    isOpen: false,
    title: '',
    message: '',
    resolve: null
  })

  const confirm = useCallback((options: ConfirmOptions): Promise<boolean> => {
    return new Promise((resolve) => {
      setState({
        ...options,
        isOpen: true,
        resolve
      })
    })
  }, [])

  const handleConfirm = useCallback(() => {
    state.resolve?.(true)
    setState((prev) => ({ ...prev, isOpen: false, resolve: null }))
  }, [state.resolve])

  const handleCancel = useCallback(() => {
    state.resolve?.(false)
    setState((prev) => ({ ...prev, isOpen: false, resolve: null }))
  }, [state.resolve])

  return {
    confirm,
    dialogProps: {
      open: state.isOpen,
      title: state.title,
      message: state.message,
      confirmLabel: state.confirmLabel,
      cancelLabel: state.cancelLabel,
      variant: state.variant,
      onConfirm: handleConfirm,
      onCancel: handleCancel
    }
  }
}
