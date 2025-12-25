/**
 * Projects Store
 *
 * State management for projects using Jotai atoms.
 * Contains only state and derived atoms.
 * All mutations are handled by hooks in src/hooks/
 */

import { atom } from 'jotai'
import type { Project } from '@/domain/entities/project.entity'

// ============================================================================
// State Atoms (Simple data holders)
// ============================================================================

/** List of user's projects */
export const projectsAtom = atom<Project[]>([])

/** Currently selected project ID */
export const currentProjectIdAtom = atom<string | null>(null)

/** Currently selected file ID */
export const currentFileIdAtom = atom<string | null>(null)

/**
 * Read-only project atom for viewing public projects without being the owner
 * This is separate from the user's projects list
 */
export const viewOnlyProjectAtom = atom<Project | null>(null)

/**
 * Flag to indicate if we're in read-only mode (viewing someone else's public project)
 */
export const isReadOnlyModeAtom = atom<boolean>(false)

// ============================================================================
// Derived Atoms (Computed values)
// ============================================================================

/** Currently selected project from user's projects list */
export const currentProjectAtom = atom((get) => {
  const projects = get(projectsAtom)
  const currentId = get(currentProjectIdAtom)
  return projects.find((p) => p.id === currentId) ?? null
})

/**
 * Active project atom - returns either the current user's project or the view-only project
 * Used by the FileBrowser to display the current project regardless of ownership
 */
export const activeProjectAtom = atom((get) => {
  const isReadOnly = get(isReadOnlyModeAtom)
  if (isReadOnly) {
    return get(viewOnlyProjectAtom)
  }
  return get(currentProjectAtom)
})

/** Currently selected file from current project */
export const currentFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  const currentFileId = get(currentFileIdAtom)
  return project?.files.find((f) => f.id === currentFileId) ?? null
})

/** Main file from current project */
export const mainFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  return project?.files.find((f) => f.isMain) ?? null
})

// ============================================================================
// Dependencies State
// ============================================================================

/**
 * Type for dependency files grouped by project
 */
export type DependencyProject = {
  id: string
  name: string
  files: Array<{
    id: string
    name: string
    content: string
    projectId: string
  }>
}

/**
 * Atom to store dependency files grouped by project
 */
export const dependencyFilesAtom = atom<DependencyProject[]>([])

/**
 * Derived atom to check if the current file is a dependency file
 * Dependency files are always read-only
 */
export const isDependencyFileAtom = atom((get) => {
  const currentFileId = get(currentFileIdAtom)
  if (!currentFileId) return false

  const dependencyProjects = get(dependencyFilesAtom)
  return dependencyProjects.some((project) =>
    project.files.some((file) => file.id === currentFileId)
  )
})
