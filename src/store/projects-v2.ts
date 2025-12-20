import { atom } from 'jotai'
import { supabase } from '@/lib/supabase'

// Types
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

export interface Project {
  id: string
  userId: string
  name: string
  description: string | null
  files: ProjectFile[]
  createdAt: string
  updatedAt: string
}

// Local state atoms
export const projectsAtom = atom<Project[]>([])
export const currentProjectIdAtom = atom<string | null>(null)
export const currentFileIdAtom = atom<string | null>(null)

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

// Actions

// Fetch all projects for the current user
export const fetchProjectsAtom = atom(null, async (_get, set) => {
  try {
    const { data, error } = await supabase
      .from('projects')
      .select(
        `
        *,
        project_files (*)
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
    { name, description }: { name: string; description?: string }
  ) => {
    try {
      // Create project
      const { data: project, error: projectError } = await supabase
        .from('projects')
        .insert({
          name,
          description: description ?? null
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
      description
    }: { projectId: string; name?: string; description?: string }
  ) => {
    try {
      const { data, error } = await supabase
        .from('projects')
        .update({
          name,
          description
        })
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
