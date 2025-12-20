import type { ProjectVisibility } from './database.types'

export interface ProjectFile {
  id: string
  projectId: string
  name: string
  content: string
  isMain: boolean
  order: number
  createdAt: string
  updatedAt: string
}

export interface ProjectShare {
  projectId: string
  userId: string
  createdAt: string
}

export interface Tag {
  id: string
  name: string
  createdAt: string
}

export interface ProjectDependency {
  id: string
  name: string
  isLibrary: boolean
}

export interface Project {
  id: string
  userId: string
  name: string
  description: string | null
  visibility: ProjectVisibility
  isLibrary: boolean
  files: ProjectFile[]
  shares?: ProjectShare[]
  tags?: Tag[]
  dependencies?: ProjectDependency[]
  createdAt: string
  updatedAt: string
}

export interface CreateProjectInput {
  name: string
  description?: string
  visibility?: ProjectVisibility
  isLibrary?: boolean
}

export interface UpdateProjectInput {
  id: string
  name?: string
  description?: string
  visibility?: ProjectVisibility
}

export interface CreateFileInput {
  projectId: string
  name: string
  content?: string
  isMain?: boolean
}

export interface UpdateFileInput {
  id: string
  name?: string
  content?: string
  isMain?: boolean
}

// Extended dependency with files for display
export interface DependencyWithFiles {
  id: string
  name: string
  isLibrary: boolean
  files: ProjectFile[]
}
