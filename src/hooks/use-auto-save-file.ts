import { useAtomValue, useSetAtom } from 'jotai'
import { useEffect, useRef } from 'react'
import { codeAtom } from '@/store/editor'
import {
  currentFileAtom,
  currentFileIdAtom,
  updateFileAtom
} from '@/store/projects-v2'
import { useAuth } from './use-auth'

const DEBOUNCE_MS = 1000 // 1 second debounce

export function useAutoSaveFile() {
  const { user } = useAuth()
  const code = useAtomValue(codeAtom)
  const currentFileId = useAtomValue(currentFileIdAtom)
  const currentFile = useAtomValue(currentFileAtom)
  const updateFile = useSetAtom(updateFileAtom)

  const timeoutRef = useRef<NodeJS.Timeout | undefined>(undefined)

  useEffect(() => {
    // Clear any pending timeout
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current)
    }

    // Don't save if user is not authenticated (uses localStorage instead)
    if (!user) {
      return
    }

    // Don't save if no file is selected or code hasn't changed
    if (!currentFileId || !currentFile || code === currentFile.content) {
      return
    }

    // Debounce the save
    timeoutRef.current = setTimeout(() => {
      updateFile({ fileId: currentFileId, content: code })
    }, DEBOUNCE_MS)

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current)
      }
    }
  }, [code, currentFileId, currentFile, updateFile, user])
}
