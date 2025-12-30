import { useAtomValue } from 'jotai'
import { useEffect, useRef } from 'react'
import { codeAtom } from '@/store/editor'
import { currentFileIdAtom } from '@/store/projects'
import { useAuth } from '../auth'
import { useCurrentFile, useCurrentProject } from '../projects'
import { useUpdateFile } from './use-files'

const DEBOUNCE_MS = 300 // 300ms debounce for responsive auto-save

export function useAutoSaveFile() {
  const { user } = useAuth()
  const code = useAtomValue(codeAtom)
  const currentFileId = useAtomValue(currentFileIdAtom)
  const currentFile = useCurrentFile()
  const { project: currentProject } = useCurrentProject()
  const { updateFile } = useUpdateFile()

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
    if (
      !currentFileId ||
      !currentFile ||
      !currentProject ||
      code === currentFile.content.value
    ) {
      return
    }

    // Debounce the save
    timeoutRef.current = setTimeout(() => {
      updateFile({
        projectId: currentProject.id,
        userId: user.id,
        fileId: currentFileId,
        content: code
      })
    }, DEBOUNCE_MS)

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current)
      }
    }
  }, [code, currentFileId, currentFile, currentProject, updateFile, user])
}
