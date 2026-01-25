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
  // Track which fileId the current code belongs to
  const codeFileIdRef = useRef<string | null>(null)

  // Update the code's fileId when file changes
  useEffect(() => {
    codeFileIdRef.current = currentFileId
  }, [currentFileId])

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

    // SAFETY: Don't save empty content if the file has content
    // This prevents race conditions during project navigation from explore
    // where code may be cleared temporarily before the file loads
    if (code === '' && currentFile.content.value !== '') {
      return
    }

    // SAFETY: Don't save if the currentFileId doesn't match the file's id
    // This prevents race conditions when switching files
    if (currentFile.id !== currentFileId) {
      return
    }

    // Capture the fileId at the time of scheduling the save
    const fileIdToSave = currentFileId
    const projectIdToSave = currentProject.id

    // Debounce the save
    timeoutRef.current = setTimeout(() => {
      // Double-check we're still on the same file before saving
      if (codeFileIdRef.current !== fileIdToSave) {
        return
      }
      updateFile({
        projectId: projectIdToSave,
        userId: user.id,
        fileId: fileIdToSave,
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
