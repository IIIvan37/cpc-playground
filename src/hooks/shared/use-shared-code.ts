import { useAtom, useSetAtom } from 'jotai'
import { useEffect, useState } from 'react'
import { useConsoleMessages } from '@/hooks/emulator/use-console-messages'
import { container } from '@/infrastructure/container'
import { codeAtom } from '@/store/editor'
import { currentProgramIdAtom } from '@/store/programs'
import { currentFileIdAtom } from '@/store/projects'

export function useSharedCode() {
  const [, setCode] = useAtom(codeAtom)
  const { addMessage } = useConsoleMessages()
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const setCurrentProgramId = useSetAtom(currentProgramIdAtom)
  const [isLoading, setIsLoading] = useState(false)

  const { getSharedCode } = container

  useEffect(() => {
    // Check sessionStorage first (captured early in main.tsx before Supabase cleans URL)
    // Then fallback to URL params
    const shareId =
      sessionStorage.getItem('pendingShareId') ||
      new URLSearchParams(globalThis.location.search).get('share')

    if (!shareId) return

    // Clear from sessionStorage to avoid reloading on refresh
    sessionStorage.removeItem('pendingShareId')

    async function loadSharedCode(id: string) {
      setIsLoading(true)
      try {
        const { code } = await getSharedCode.execute({ shareId: id })

        console.log(
          '[useSharedCode] Received code length:',
          code?.length,
          'First 100 chars:',
          code?.substring(0, 100)
        )

        if (code) {
          // IMPORTANT: Set code FIRST, then reset IDs
          // This ensures the editor sees the new code when it reacts to currentFile becoming null
          setCode(code)
          // Reset to "new program" mode - neither a project file nor an existing program
          setCurrentFileId(null)
          setCurrentProgramId(null)
          addMessage({
            type: 'info',
            text: `Loaded shared code (ID: ${id})`
          })
        } else {
          addMessage({
            type: 'error',
            text: `Shared code is empty (ID: ${id})`
          })
        }

        // Clean URL without reloading
        const newUrl = globalThis.location.pathname
        globalThis.history.replaceState({}, '', newUrl)
      } catch (error) {
        addMessage({
          type: 'error',
          text: `Failed to load shared code: ${error instanceof Error ? error.message : 'Unknown error'}`
        })
      } finally {
        setIsLoading(false)
      }
    }

    loadSharedCode(shareId)
  }, [
    setCode,
    addMessage,
    getSharedCode,
    setCurrentFileId,
    setCurrentProgramId
  ])

  return { isLoading }
}
