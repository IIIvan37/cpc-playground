/**
 * useExport Hook
 * Handles exporting projects as ZIP archives, DSK and SNA files
 */

import { useAtomValue } from 'jotai'
import JSZip from 'jszip'
import { useCallback, useState } from 'react'
import type { Project } from '@/domain/entities/project.entity'
import { container } from '@/infrastructure/container'
import { createLogger } from '@/lib/logger'
import { compilationOutputAtom, outputFormatAtom } from '@/store'

const logger = createLogger('useExport')

/**
 * Convert Uint8Array to a Blob-compatible format
 */
function uint8ArrayToBlob(data: Uint8Array, mimeType: string): Blob {
  // Create a new ArrayBuffer copy to avoid SharedArrayBuffer issues
  const buffer = new ArrayBuffer(data.length)
  const view = new Uint8Array(buffer)
  view.set(data)
  return new Blob([buffer], { type: mimeType })
}

/**
 * Download a file by creating a temporary anchor element
 */
function downloadFile(content: Blob, fileName: string): void {
  const url = URL.createObjectURL(content)
  const link = document.createElement('a')
  link.href = url
  link.download = fileName
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}

/**
 * Sanitize filename by replacing invalid characters
 */
function sanitizeFileName(name: string): string {
  return name.replaceAll(/[^a-zA-Z0-9-_]/g, '_').toLowerCase()
}

/**
 * File with project context for ZIP export
 */
type FileWithProject = {
  projectId: string
  projectName: string
  name: string
  content: string
}

/**
 * Group files by their project ID
 */
function groupFilesByProject(
  files: FileWithProject[]
): Map<string, { projectName: string; files: FileWithProject[] }> {
  const filesByProject = new Map<
    string,
    { projectName: string; files: FileWithProject[] }
  >()

  for (const file of files) {
    const existing = filesByProject.get(file.projectId)
    if (existing) {
      existing.files.push(file)
    } else {
      filesByProject.set(file.projectId, {
        projectName: file.projectName,
        files: [file]
      })
    }
  }

  return filesByProject
}

/**
 * Add files to a ZIP folder
 */
function addFilesToFolder(folder: JSZip, files: FileWithProject[]): number {
  for (const file of files) {
    folder.file(file.name, file.content)
  }
  return files.length
}

/**
 * Hook to handle all export functionalities
 */
export function useExport() {
  const [exportingProject, setExportingProject] = useState(false)
  const compilationOutput = useAtomValue(compilationOutputAtom)
  const outputFormat = useAtomValue(outputFormatAtom)

  /**
   * Export project as a ZIP archive with individual files and dependencies
   */
  const exportProject = useCallback(
    async (project: Project, userId?: string): Promise<boolean> => {
      setExportingProject(true)

      try {
        // Get project with all its dependencies
        const result = await container.getProjectWithDependencies.execute({
          projectId: project.id,
          userId
        })

        // Create ZIP archive
        const zip = new JSZip()
        const mainFolderName = sanitizeFileName(project.name.value)
        const mainFolder = zip.folder(mainFolderName)

        if (!mainFolder) {
          throw new Error('Failed to create ZIP folder')
        }

        // Group files by project and add to ZIP
        const filesByProject = groupFilesByProject(result.files)
        const mainProjectFiles = filesByProject.get(project.id)
        const totalMainFiles = mainProjectFiles
          ? addFilesToFolder(mainFolder, mainProjectFiles.files)
          : 0

        // Add dependency files to libs subfolder
        let dependencyCount = 0
        let totalDependencyFiles = 0
        const libFolder = mainFolder.folder('libs')

        for (const [projectId, { projectName, files }] of filesByProject) {
          if (projectId !== project.id && libFolder) {
            const depFolder = libFolder.folder(sanitizeFileName(projectName))
            if (depFolder) {
              totalDependencyFiles += addFilesToFolder(depFolder, files)
              dependencyCount++
            }
          }
        }

        const totalFiles = totalMainFiles + totalDependencyFiles

        // Generate the ZIP blob
        const zipBlob = await zip.generateAsync({ type: 'blob' })
        const zipFileName = `${mainFolderName}.zip`

        downloadFile(zipBlob, zipFileName)

        logger.info(
          `Project exported as ZIP: ${zipFileName} (${totalFiles} files, ${dependencyCount} dependencies)`
        )
        return true
      } catch (error) {
        logger.error('Failed to export project:', error)
        return false
      } finally {
        setExportingProject(false)
      }
    },
    []
  )

  /**
   * Export the last compiled binary (DSK or SNA)
   */
  const exportBinary = useCallback(
    (projectName?: string): boolean => {
      if (!compilationOutput) {
        logger.warn('No compilation output available to export')
        return false
      }

      const extension = outputFormat
      const safeName = projectName ? sanitizeFileName(projectName) : 'program'
      const fileName = `${safeName}.${extension}`

      const blob = uint8ArrayToBlob(
        compilationOutput,
        'application/octet-stream'
      )
      downloadFile(blob, fileName)

      logger.info(
        `Binary exported: ${fileName} (${compilationOutput.length} bytes)`
      )
      return true
    },
    [compilationOutput, outputFormat]
  )

  /**
   * Export DSK file specifically
   */
  const exportDsk = useCallback(
    (data: Uint8Array, projectName?: string): void => {
      const safeName = projectName ? sanitizeFileName(projectName) : 'program'
      const fileName = `${safeName}.dsk`

      const blob = uint8ArrayToBlob(data, 'application/octet-stream')
      downloadFile(blob, fileName)

      logger.info(`DSK exported: ${fileName} (${data.length} bytes)`)
    },
    []
  )

  /**
   * Export SNA file specifically
   */
  const exportSna = useCallback(
    (data: Uint8Array, projectName?: string): void => {
      const safeName = projectName ? sanitizeFileName(projectName) : 'program'
      const fileName = `${safeName}.sna`

      const blob = uint8ArrayToBlob(data, 'application/octet-stream')
      downloadFile(blob, fileName)

      logger.info(`SNA exported: ${fileName} (${data.length} bytes)`)
    },
    []
  )

  return {
    exportProject,
    exportBinary,
    exportDsk,
    exportSna,
    exportingProject,
    hasCompiledOutput: !!compilationOutput,
    currentOutputFormat: outputFormat
  }
}
