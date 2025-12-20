import { atom } from 'jotai'
import { supabase } from '@/lib/supabase'
import type { ProjectVisibility } from '@/types/database'

// Types
export interface Tag {
  id: string
  name: string
  createdAt: string
}

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
  id: string
  projectId: string
  userId: string
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

// Extended dependency with files for display
export interface DependencyWithFiles {
  id: string
  name: string
  isLibrary: boolean
  files: ProjectFile[]
}

// Local state atoms
export const projectsAtom = atom<Project[]>([])
export const currentProjectIdAtom = atom<string | null>(null)
export const currentFileIdAtom = atom<string | null>(null)
export const dependencyFilesAtom = atom<DependencyWithFiles[]>([])

// Derived atoms
export const currentProjectAtom = atom((get) => {
  const projects = get(projectsAtom)
  const currentId = get(currentProjectIdAtom)
  return projects.find((p) => p.id === currentId) ?? null
})

export const currentFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  const currentFileId = get(currentFileIdAtom)
  return project?.files.find((f) => f.id === currentFileId) ?? null
})

export const mainFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  return project?.files.find((f) => f.isMain) ?? null
})

// Fetch dependency files for the current project
export const fetchDependencyFilesAtom = atom(
  null,
  async (get, set, projectId: string) => {
    try {
      const currentProject = get(projectsAtom).find((p) => p.id === projectId)
      if (!currentProject?.dependencies?.length) {
        set(dependencyFilesAtom, [])
        return
      }

      const dependencyIds = currentProject.dependencies.map((d) => d.id)

      const { data, error } = await supabase
        .from('projects')
        .select(
          `
          id,
          name,
          is_library,
          project_files (*)
        `
        )
        .in('id', dependencyIds)

      if (error) throw error

      const deps: DependencyWithFiles[] =
        data?.map((p: any) => ({
          id: p.id,
          name: p.name,
          isLibrary: p.is_library,
          files:
            p.project_files?.map((f: any) => ({
              id: f.id,
              projectId: f.project_id,
              name: f.name,
              content: f.content,
              isMain: f.is_main,
              order: f.order,
              createdAt: f.created_at,
              updatedAt: f.updated_at
            })) ?? []
        })) ?? []

      set(dependencyFilesAtom, deps)
    } catch (error) {
      console.error('Error fetching dependency files:', error)
      set(dependencyFilesAtom, [])
    }
  }
)

// Actions

// Fetch all projects for the current user
export const fetchProjectsAtom = atom(null, async (_get, set) => {
  try {
    const { data, error } = await supabase
      .from('projects')
      .select(
        `
        *,
        project_files (*),
        project_shares (*),
        project_tags (
          tag_id,
          tags (*)
        ),
        project_dependencies!project_dependencies_project_id_fkey (
          dependency_id,
          dependency:projects!project_dependencies_dependency_id_fkey (
            id,
            name,
            is_library
          )
        )
      `
      )
      .order('updated_at', { ascending: false })

    if (error) throw error

    const projects: Project[] =
      data?.map((p) => ({
        id: p.id,
        userId: p.user_id,
        name: p.name,
        description: p.description,
        visibility: p.visibility as ProjectVisibility,
        isLibrary: p.is_library,
        files:
          p.project_files?.map((f: any) => ({
            id: f.id,
            projectId: f.project_id,
            name: f.name,
            content: f.content,
            isMain: f.is_main,
            order: f.order,
            createdAt: f.created_at,
            updatedAt: f.updated_at
          })) ?? [],
        shares:
          p.project_shares?.map((s: any) => ({
            id: s.id,
            projectId: s.project_id,
            userId: s.user_id,
            createdAt: s.created_at
          })) ?? [],
        tags:
          p.project_tags?.map((pt: any) => ({
            id: pt.tags.id,
            name: pt.tags.name,
            createdAt: pt.tags.created_at
          })) ?? [],
        dependencies:
          p.project_dependencies?.map((pd: any) => ({
            id: pd.dependency.id,
            name: pd.dependency.name,
            isLibrary: pd.dependency.is_library
          })) ?? [],
        createdAt: p.created_at,
        updatedAt: p.updated_at
      })) ?? []

    set(projectsAtom, projects)
    return projects
  } catch (error) {
    console.error('Error fetching projects:', error)
    throw error
  }
})

// Create a new project
export const createProjectAtom = atom(
  null,
  async (
    get,
    set,
    {
      name,
      description,
      isLibrary
    }: { name: string; description?: string; isLibrary?: boolean }
  ) => {
    try {
      // Create project
      const { data: project, error: projectError } = await supabase
        .from('projects')
        .insert({
          name,
          description: description ?? null,
          is_library: isLibrary ?? false
        })
        .select()
        .single()

      if (projectError) throw projectError

      // Create default main file
      const { data: file, error: fileError } = await supabase
        .from('project_files')
        .insert({
          project_id: project.id,
          name: 'main.asm',
          content: `; ${name}
org #4000

start:
    ld a, 1
    call #bc0e      ; SCR SET MODE
    
    ld hl, message
    call print_string
    
    ret

print_string:
    ld a, (hl)
    or a
    ret z
    call #bb5a      ; TXT OUTPUT
    inc hl
    jr print_string

message:
    db "Hello from ${name}!", 0
`,
          is_main: true,
          order: 0
        })
        .select()
        .single()

      if (fileError) throw fileError

      // Add to local state
      const newProject: Project = {
        id: project.id,
        userId: project.user_id,
        name: project.name,
        description: project.description,
        visibility: project.visibility,
        isLibrary: project.is_library,
        files: [
          {
            id: file.id,
            projectId: file.project_id,
            name: file.name,
            content: file.content,
            isMain: file.is_main,
            order: file.order,
            createdAt: file.created_at,
            updatedAt: file.updated_at
          }
        ],
        createdAt: project.created_at,
        updatedAt: project.updated_at
      }

      set(projectsAtom, [newProject, ...get(projectsAtom)])
      set(currentProjectIdAtom, newProject.id)
      set(currentFileIdAtom, file.id)

      return newProject
    } catch (error) {
      console.error('Error creating project:', error)
      throw error
    }
  }
)

// Update project metadata
export const updateProjectAtom = atom(
  null,
  async (
    get,
    set,
    {
      projectId,
      name,
      description,
      visibility,
      isLibrary
    }: {
      projectId: string
      name?: string
      description?: string
      visibility?: ProjectVisibility
      isLibrary?: boolean
    }
  ) => {
    try {
      const updates: any = {}
      if (name !== undefined) updates.name = name
      if (description !== undefined) updates.description = description
      if (visibility !== undefined) updates.visibility = visibility
      if (isLibrary !== undefined) updates.is_library = isLibrary

      const { data, error } = await supabase
        .from('projects')
        .update(updates)
        .eq('id', projectId)
        .select()
        .single()

      if (error) throw error

      // Update local state
      const projects = get(projectsAtom)
      set(
        projectsAtom,
        projects.map((p) =>
          p.id === projectId
            ? {
                ...p,
                name: data.name,
                description: data.description,
                visibility: data.visibility as ProjectVisibility,
                isLibrary: data.is_library,
                updatedAt: data.updated_at
              }
            : p
        )
      )
    } catch (error) {
      console.error('Error updating project:', error)
      throw error
    }
  }
)

// Delete project
export const deleteProjectAtom = atom(
  null,
  async (get, set, projectId: string) => {
    try {
      const { error } = await supabase
        .from('projects')
        .delete()
        .eq('id', projectId)

      if (error) throw error

      // Update local state
      const projects = get(projectsAtom)
      set(
        projectsAtom,
        projects.filter((p) => p.id !== projectId)
      )

      if (get(currentProjectIdAtom) === projectId) {
        set(currentProjectIdAtom, null)
        set(currentFileIdAtom, null)
      }
    } catch (error) {
      console.error('Error deleting project:', error)
      throw error
    }
  }
)

// Create a new file in a project
export const createFileAtom = atom(
  null,
  async (
    get,
    set,
    {
      projectId,
      name,
      content = ''
    }: { projectId: string; name: string; content?: string }
  ) => {
    try {
      const project = get(projectsAtom).find((p) => p.id === projectId)
      if (!project) throw new Error('Project not found')

      const { data, error } = await supabase
        .from('project_files')
        .insert({
          project_id: projectId,
          name,
          content,
          is_main: false,
          order: project.files.length
        })
        .select()
        .single()

      if (error) throw error

      // Update local state
      const newFile: ProjectFile = {
        id: data.id,
        projectId: data.project_id,
        name: data.name,
        content: data.content,
        isMain: data.is_main,
        order: data.order,
        createdAt: data.created_at,
        updatedAt: data.updated_at
      }

      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId ? { ...p, files: [...p.files, newFile] } : p
        )
      )

      set(currentFileIdAtom, newFile.id)
      return newFile
    } catch (error) {
      console.error('Error creating file:', error)
      throw error
    }
  }
)

// Update file content
export const updateFileAtom = atom(
  null,
  async (
    get,
    set,
    {
      fileId,
      content,
      name
    }: { fileId: string; content?: string; name?: string }
  ) => {
    try {
      const { data, error } = await supabase
        .from('project_files')
        .update({
          content,
          name
        })
        .eq('id', fileId)
        .select()
        .single()

      if (error) throw error

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) => ({
          ...p,
          files: p.files.map((f) =>
            f.id === fileId
              ? {
                  ...f,
                  content: data.content,
                  name: data.name,
                  updatedAt: data.updated_at
                }
              : f
          )
        }))
      )
    } catch (error) {
      console.error('Error updating file:', error)
      throw error
    }
  }
)

// Delete file
export const deleteFileAtom = atom(null, async (get, set, fileId: string) => {
  try {
    const { error } = await supabase
      .from('project_files')
      .delete()
      .eq('id', fileId)

    if (error) throw error

    // Update local state
    set(
      projectsAtom,
      get(projectsAtom).map((p) => ({
        ...p,
        files: p.files.filter((f) => f.id !== fileId)
      }))
    )

    if (get(currentFileIdAtom) === fileId) {
      set(currentFileIdAtom, null)
    }
  } catch (error) {
    console.error('Error deleting file:', error)
    throw error
  }
})

// Set main file
export const setMainFileAtom = atom(null, async (get, set, fileId: string) => {
  try {
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.files.some((f) => f.id === fileId))
    if (!project) throw new Error('Project not found')

    // Unset current main file
    const currentMain = project.files.find((f) => f.isMain)
    if (currentMain) {
      await supabase
        .from('project_files')
        .update({ is_main: false })
        .eq('id', currentMain.id)
    }

    // Set new main file
    const { error } = await supabase
      .from('project_files')
      .update({ is_main: true })
      .eq('id', fileId)

    if (error) throw error

    // Update local state
    set(
      projectsAtom,
      projects.map((p) =>
        p.id === project.id
          ? {
              ...p,
              files: p.files.map((f) => ({
                ...f,
                isMain: f.id === fileId
              }))
            }
          : p
      )
    )
  } catch (error) {
    console.error('Error setting main file:', error)
    throw error
  }
})

// Update project visibility
export const updateProjectVisibilityAtom = atom(
  null,
  async (
    get,
    set,
    {
      projectId,
      visibility
    }: { projectId: string; visibility: ProjectVisibility }
  ) => {
    try {
      const { error } = await supabase
        .from('projects')
        .update({ visibility })
        .eq('id', projectId)

      if (error) throw error

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId ? { ...p, visibility } : p
        )
      )
    } catch (error) {
      console.error('Error updating project visibility:', error)
      throw error
    }
  }
)

// Share project with a user
export const shareProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, userEmail }: { projectId: string; userEmail: string }
  ) => {
    try {
      // First, get the user ID from email
      const { data: userData, error: userError } = await supabase
        .from('auth.users')
        .select('id')
        .eq('email', userEmail)
        .single()

      if (userError) throw new Error('User not found')

      const { data, error } = await supabase
        .from('project_shares')
        .insert({
          project_id: projectId,
          user_id: userData.id
        })
        .select()
        .single()

      if (error) throw error

      const newShare: ProjectShare = {
        id: data.id,
        projectId: data.project_id,
        userId: data.user_id,
        createdAt: data.created_at
      }

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId
            ? { ...p, shares: [...(p.shares ?? []), newShare] }
            : p
        )
      )
    } catch (error) {
      console.error('Error sharing project:', error)
      throw error
    }
  }
)

// Unshare project (remove user access)
export const unshareProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, shareId }: { projectId: string; shareId: string }
  ) => {
    try {
      const { error } = await supabase
        .from('project_shares')
        .delete()
        .eq('id', shareId)

      if (error) throw error

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId
            ? { ...p, shares: p.shares?.filter((s) => s.id !== shareId) ?? [] }
            : p
        )
      )
    } catch (error) {
      console.error('Error unsharing project:', error)
      throw error
    }
  }
)

// Fetch all tags
export const tagsAtom = atom<Tag[]>([])

export const fetchTagsAtom = atom(null, async (_get, set) => {
  try {
    const { data, error } = await supabase
      .from('tags')
      .select('*')
      .order('name', { ascending: true })

    if (error) throw error

    const tags: Tag[] =
      data?.map((t) => ({
        id: t.id,
        name: t.name,
        createdAt: t.created_at
      })) ?? []

    set(tagsAtom, tags)
    return tags
  } catch (error) {
    console.error('Error fetching tags:', error)
    throw error
  }
})

// Create or get existing tag
export const getOrCreateTagAtom = atom(
  null,
  async (get, set, tagName: string) => {
    try {
      // Normalize tag name
      const normalizedName = tagName.toLowerCase().replace(/[^a-z0-9-]/g, '-')

      // Check if tag exists
      const { data: existingTag } = await supabase
        .from('tags')
        .select('*')
        .eq('name', normalizedName)
        .single()

      if (existingTag) {
        return {
          id: existingTag.id,
          name: existingTag.name,
          createdAt: existingTag.created_at
        }
      }

      // Create new tag
      const { data, error } = await supabase
        .from('tags')
        .insert({ name: normalizedName })
        .select()
        .single()

      if (error) throw error

      const newTag: Tag = {
        id: data.id,
        name: data.name,
        createdAt: data.created_at
      }

      // Update tags atom
      set(tagsAtom, [...get(tagsAtom), newTag])

      return newTag
    } catch (error) {
      console.error('Error creating tag:', error)
      throw error
    }
  }
)

// Add tag to project
export const addTagToProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, tagName }: { projectId: string; tagName: string }
  ) => {
    try {
      // Get or create the tag
      const tag = await set(getOrCreateTagAtom, tagName)

      // Add tag to project
      const { error } = await supabase.from('project_tags').insert({
        project_id: projectId,
        tag_id: tag.id
      })

      if (error) {
        // If error is duplicate, ignore it
        if (!error.message.includes('duplicate')) {
          throw error
        }
        return
      }

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId ? { ...p, tags: [...(p.tags ?? []), tag] } : p
        )
      )
    } catch (error) {
      console.error('Error adding tag to project:', error)
      throw error
    }
  }
)

// Remove tag from project
export const removeTagFromProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, tagId }: { projectId: string; tagId: string }
  ) => {
    try {
      const { error } = await supabase
        .from('project_tags')
        .delete()
        .eq('project_id', projectId)
        .eq('tag_id', tagId)

      if (error) throw error

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId
            ? { ...p, tags: p.tags?.filter((t) => t.id !== tagId) ?? [] }
            : p
        )
      )
    } catch (error) {
      console.error('Error removing tag from project:', error)
      throw error
    }
  }
)

// Add dependency to project
export const addDependencyToProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, dependencyId }: { projectId: string; dependencyId: string }
  ) => {
    try {
      // Prevent self-dependency
      if (projectId === dependencyId) {
        throw new Error('A project cannot depend on itself')
      }

      // Check if dependency exists
      const { data: dependencyProject, error: fetchError } = await supabase
        .from('projects')
        .select('id, name, is_library')
        .eq('id', dependencyId)
        .single()

      if (fetchError || !dependencyProject) {
        throw new Error('Dependency project not found or not accessible')
      }

      // Add dependency
      const { error } = await supabase.from('project_dependencies').insert({
        project_id: projectId,
        dependency_id: dependencyId
      })

      if (error) {
        // If error is duplicate, ignore it
        if (!error.message.includes('duplicate')) {
          throw error
        }
        return
      }

      const newDependency: ProjectDependency = {
        id: dependencyProject.id,
        name: dependencyProject.name,
        isLibrary: dependencyProject.is_library
      }

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId
            ? { ...p, dependencies: [...(p.dependencies ?? []), newDependency] }
            : p
        )
      )
    } catch (error) {
      console.error('Error adding dependency to project:', error)
      throw error
    }
  }
)

// Remove dependency from project
export const removeDependencyFromProjectAtom = atom(
  null,
  async (
    get,
    set,
    { projectId, dependencyId }: { projectId: string; dependencyId: string }
  ) => {
    try {
      const { error } = await supabase
        .from('project_dependencies')
        .delete()
        .eq('project_id', projectId)
        .eq('dependency_id', dependencyId)

      if (error) throw error

      // Update local state
      set(
        projectsAtom,
        get(projectsAtom).map((p) =>
          p.id === projectId
            ? {
                ...p,
                dependencies:
                  p.dependencies?.filter((d) => d.id !== dependencyId) ?? []
              }
            : p
        )
      )
    } catch (error) {
      console.error('Error removing dependency from project:', error)
      throw error
    }
  }
)

// Fetch all files from project and its dependencies (recursive)
export const fetchProjectWithDependenciesAtom = atom(
  null,
  async (_get, _set, projectId: string) => {
    try {
      const allFiles: (ProjectFile & { projectName: string })[] = []
      const visitedProjects = new Set<string>()

      async function fetchProjectFiles(id: string): Promise<void> {
        if (visitedProjects.has(id)) return
        visitedProjects.add(id)

        // Fetch project with dependencies
        const { data, error } = await supabase
          .from('projects')
          .select(
            `
            id,
            name,
            project_files (*),
            project_dependencies!project_dependencies_project_id_fkey (
              dependency_id
            )
          `
          )
          .eq('id', id)
          .single()

        if (error) throw error

        // Add files from this project
        const files =
          data.project_files?.map((f: any) => ({
            id: f.id,
            projectId: f.project_id,
            projectName: data.name, // Include project name
            name: f.name,
            content: f.content,
            isMain: f.is_main,
            order: f.order,
            createdAt: f.created_at,
            updatedAt: f.updated_at
          })) ?? []

        allFiles.push(...files)

        // Recursively fetch dependencies
        if (data.project_dependencies) {
          for (const dep of data.project_dependencies) {
            await fetchProjectFiles(dep.dependency_id)
          }
        }
      }

      await fetchProjectFiles(projectId)
      return allFiles
    } catch (error) {
      console.error('Error fetching project with dependencies:', error)
      throw error
    }
  }
)
