import { useAtom } from 'jotai'
import { useEffect, useState } from 'react'
import { addConsoleMessageAtom, codeAtom } from '@/store/editor'

export function useSharedCode() {
  const [, setCode] = useAtom(codeAtom)
  const [, addMessage] = useAtom(addConsoleMessageAtom)
  const [isLoading, setIsLoading] = useState(false)

  useEffect(() => {
    const params = new URLSearchParams(window.location.search)
    const shareId = params.get('share')

    if (!shareId) return

    async function loadSharedCode(id: string) {
      setIsLoading(true)
      try {
        const response = await fetch(`/api/share?id=${encodeURIComponent(id)}`)
        const data = await response.json()

        if (!response.ok) {
          throw new Error(data.error || 'Failed to load shared code')
        }

        setCode(data.code)
        addMessage({
          type: 'info',
          text: `Loaded shared code (ID: ${id})`
        })

        // Clean URL without reloading
        const newUrl = window.location.pathname
        window.history.replaceState({}, '', newUrl)
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
  }, [setCode, addMessage])

  return { isLoading }
}
