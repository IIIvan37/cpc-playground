import type { FileContent } from '../value-objects/file-content.vo'
import type { FileName } from '../value-objects/file-name.vo'

/**
 * ProjectFile Entity
 * Represents a file within a project
 */

export type ProjectFile = Readonly<{
  id: string
  projectId: string
  name: FileName
  content: FileContent
  isMain: boolean
  order: number
  createdAt: Date
  updatedAt: Date
}>

export type CreateProjectFileParams = {
  id?: string
  projectId: string
  name: FileName
  content: FileContent
  isMain?: boolean
  order?: number
  createdAt?: Date
  updatedAt?: Date
}

export function createProjectFile(
  params: CreateProjectFileParams
): ProjectFile {
  const now = new Date()

  return Object.freeze({
    id: params.id ?? crypto.randomUUID(),
    projectId: params.projectId,
    name: params.name,
    content: params.content,
    isMain: params.isMain ?? false,
    order: params.order ?? 0,
    createdAt: params.createdAt ?? now,
    updatedAt: params.updatedAt ?? now
  })
}

export function updateProjectFile(
  file: ProjectFile,
  updates: {
    name?: FileName
    content?: FileContent
    isMain?: boolean
    order?: number
  }
): ProjectFile {
  return Object.freeze({
    ...file,
    ...updates,
    updatedAt: new Date()
  })
}

export function isMainFile(file: ProjectFile): boolean {
  return file.isMain
}
