import type { ProjectName } from '../value-objects/project-name.vo'
import type { Visibility } from '../value-objects/visibility.vo'
import type { ProjectFile } from './project-file.entity'

/**
 * Project Entity
 * Aggregate root for project-related operations
 */

export type Project = Readonly<{
  id: string
  userId: string
  authorUsername: string | null
  name: ProjectName
  description: string | null
  visibility: Visibility
  isLibrary: boolean
  files: readonly ProjectFile[]
  tags: readonly string[]
  dependencies: readonly DependencyInfo[]
  shares: readonly ProjectShare[]
  userShares: readonly UserShare[]
  createdAt: Date
  updatedAt: Date
}>

export type ProjectShare = Readonly<{
  id: string
  shareCode: string
  createdAt: Date
}>

/**
 * User share - sharing a project with a specific user
 */
export type UserShare = Readonly<{
  projectId: string
  userId: string
  username: string
  createdAt: Date
}>

/**
 * Dependency info - information about a project dependency
 */
export type DependencyInfo = Readonly<{
  id: string
  name: string
}>

export type CreateProjectParams = {
  id?: string
  userId: string
  authorUsername?: string | null
  name: ProjectName
  description?: string | null
  visibility: Visibility
  isLibrary?: boolean
  files?: readonly ProjectFile[]
  tags?: readonly string[]
  dependencies?: readonly DependencyInfo[]
  shares?: readonly ProjectShare[]
  userShares?: readonly UserShare[]
  createdAt?: Date
  updatedAt?: Date
}

export function createProject(params: CreateProjectParams): Project {
  const now = new Date()

  return Object.freeze({
    id: params.id ?? crypto.randomUUID(),
    userId: params.userId,
    authorUsername: params.authorUsername ?? null,
    name: params.name,
    description: params.description ?? null,
    visibility: params.visibility,
    isLibrary: params.isLibrary ?? false,
    files: Object.freeze(params.files ?? []),
    tags: Object.freeze(params.tags ?? []),
    dependencies: Object.freeze(params.dependencies ?? []),
    shares: Object.freeze(params.shares ?? []),
    userShares: Object.freeze(params.userShares ?? []),
    createdAt: params.createdAt ?? now,
    updatedAt: params.updatedAt ?? now
  })
}

export function updateProject(
  project: Project,
  updates: {
    name?: ProjectName
    description?: string | null
    visibility?: Visibility
    isLibrary?: boolean
    files?: readonly ProjectFile[]
    tags?: readonly string[]
    dependencies?: readonly DependencyInfo[]
  }
): Project {
  return Object.freeze({
    ...project,
    ...updates,
    updatedAt: new Date()
  })
}

export function addFile(project: Project, file: ProjectFile): Project {
  return Object.freeze({
    ...project,
    files: Object.freeze([...project.files, file]),
    updatedAt: new Date()
  })
}

export function removeFile(project: Project, fileId: string): Project {
  return Object.freeze({
    ...project,
    files: Object.freeze(project.files.filter((f) => f.id !== fileId)),
    updatedAt: new Date()
  })
}

export function updateFile(
  project: Project,
  fileId: string,
  updates: {
    name?: ProjectFile['name']
    content?: ProjectFile['content']
    isMain?: boolean
    order?: number
  }
): Project {
  return Object.freeze({
    ...project,
    files: Object.freeze(
      project.files.map((f) =>
        f.id === fileId
          ? Object.freeze({ ...f, ...updates, updatedAt: new Date() })
          : f
      )
    ),
    updatedAt: new Date()
  })
}

export function getMainFile(project: Project): ProjectFile | undefined {
  return project.files.find((f) => f.isMain)
}

export function addTag(project: Project, tag: string): Project {
  if (project.tags.includes(tag)) {
    return project
  }
  return Object.freeze({
    ...project,
    tags: Object.freeze([...project.tags, tag]),
    updatedAt: new Date()
  })
}

export function removeTag(project: Project, tag: string): Project {
  return Object.freeze({
    ...project,
    tags: Object.freeze(project.tags.filter((t) => t !== tag)),
    updatedAt: new Date()
  })
}
