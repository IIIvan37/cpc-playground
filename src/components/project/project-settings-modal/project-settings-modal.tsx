import { useAtomValue, useSetAtom } from 'jotai'
import { useState } from 'react'
import { useAuth } from '@/hooks'
import {
  addDependencyToProjectAtom,
  addTagToProjectAtom,
  addUserShareToProjectAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  projectsAtom,
  removeDependencyFromProjectAtom,
  removeTagFromProjectAtom,
  removeUserShareFromProjectAtom,
  updateProjectAtom
} from '@/store/projects'
import { ProjectSettingsModalView } from './project-settings-modal.view'

type ProjectSettingsModalProps = Readonly<{
  onClose: () => void
}>

/**
 * Container component for project settings modal
 * Handles business logic and delegates rendering to ProjectSettingsModalView
 */
export function ProjectSettingsModal({ onClose }: ProjectSettingsModalProps) {
  const { user } = useAuth()
  const currentProject = useAtomValue(currentProjectAtom)
  const projects = useAtomValue(projectsAtom)
  const updateProject = useSetAtom(updateProjectAtom)
  const addTag = useSetAtom(addTagToProjectAtom)
  const removeTag = useSetAtom(removeTagFromProjectAtom)
  const addDependency = useSetAtom(addDependencyToProjectAtom)
  const removeDependency = useSetAtom(removeDependencyFromProjectAtom)
  const addUserShare = useSetAtom(addUserShareToProjectAtom)
  const removeUserShare = useSetAtom(removeUserShareFromProjectAtom)
  const fetchProjects = useSetAtom(fetchProjectsAtom)

  const [name, setName] = useState(currentProject?.name.value || '')
  const [description, setDescription] = useState(
    currentProject?.description || ''
  )
  const [visibility, setVisibility] = useState<'private' | 'public' | 'shared'>(
    currentProject?.visibility.value === 'unlisted'
      ? 'private'
      : (currentProject?.visibility.value as 'private' | 'public') || 'private'
  )
  const [isLibrary, setIsLibrary] = useState(currentProject?.isLibrary || false)

  const [newTag, setNewTag] = useState('')
  const [selectedDependency, setSelectedDependency] = useState('')
  const [shareUsername, setShareUsername] = useState('')
  const [loading, setLoading] = useState(false)

  if (!currentProject || !user) return null

  const handleSave = async () => {
    setLoading(true)
    try {
      await updateProject({
        projectId: currentProject.id,
        userId: user.id,
        name,
        description,
        visibility: visibility === 'shared' ? 'private' : visibility,
        isLibrary: isLibrary
      })
      await fetchProjects(user.id)
      onClose()
    } catch (error) {
      console.error('Error updating project:', error)
      alert('Error updating project')
    } finally {
      setLoading(false)
    }
  }

  const handleAddTag = async () => {
    if (!newTag.trim()) return
    setLoading(true)
    try {
      await addTag({ projectId: currentProject.id, tagName: newTag.trim() })
      setNewTag('')
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error adding tag:', error)
      alert('Error adding tag')
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveTag = async (tagName: string) => {
    setLoading(true)
    try {
      await removeTag({ projectId: currentProject.id, tagName })
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error removing tag:', error)
      alert('Error removing tag')
    } finally {
      setLoading(false)
    }
  }

  const handleAddDependency = async () => {
    if (!selectedDependency) return
    setLoading(true)
    try {
      await addDependency({
        projectId: currentProject.id,
        dependencyId: selectedDependency
      })
      setSelectedDependency('')
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error adding dependency:', error)
      alert('Error adding dependency')
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveDependency = async (dependencyId: string) => {
    setLoading(true)
    try {
      await removeDependency({
        projectId: currentProject.id,
        dependencyId
      })
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error removing dependency:', error)
      alert('Error removing dependency')
    } finally {
      setLoading(false)
    }
  }

  const handleAddShare = async () => {
    if (!shareUsername.trim()) return
    setLoading(true)
    try {
      await addUserShare({
        projectId: currentProject.id,
        username: shareUsername.trim()
      })
      setShareUsername('')
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error adding share:', error)
      if (error instanceof Error) {
        alert(error.message)
      } else {
        alert('Error adding share')
      }
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveShare = async (userId: string) => {
    setLoading(true)
    try {
      await removeUserShare({
        projectId: currentProject.id,
        targetUserId: userId
      })
      await fetchProjects(user.id)
    } catch (error) {
      console.error('Error removing share:', error)
      alert('Error removing share')
    } finally {
      setLoading(false)
    }
  }

  // Filter available dependencies (libraries not already added)
  const availableDependencies = projects
    .filter(
      (p) =>
        p.isLibrary &&
        p.id !== currentProject.id &&
        !currentProject.dependencies?.includes(p.id)
    )
    .map((p) => ({ id: p.id, name: p.name.value }))

  // Map current dependencies to display format
  const currentDependencies = (currentProject.dependencies || [])
    .map((depId) => {
      const dep = projects.find((p) => p.id === depId)
      return dep ? { id: dep.id, name: dep.name.value } : null
    })
    .filter((dep): dep is { id: string; name: string } => dep !== null)

  return (
    <ProjectSettingsModalView
      name={name}
      description={description}
      visibility={visibility}
      isLibrary={isLibrary}
      newTag={newTag}
      selectedDependency={selectedDependency}
      shareUsername={shareUsername}
      loading={loading}
      currentTags={currentProject.tags || []}
      currentDependencies={currentDependencies}
      currentUserShares={currentProject.userShares || []}
      availableDependencies={availableDependencies}
      onNameChange={setName}
      onDescriptionChange={setDescription}
      onVisibilityChange={setVisibility}
      onIsLibraryChange={setIsLibrary}
      onNewTagChange={setNewTag}
      onSelectedDependencyChange={setSelectedDependency}
      onShareUsernameChange={setShareUsername}
      onSave={handleSave}
      onClose={onClose}
      onAddTag={handleAddTag}
      onRemoveTag={handleRemoveTag}
      onAddDependency={handleAddDependency}
      onRemoveDependency={handleRemoveDependency}
      onAddShare={handleAddShare}
      onRemoveShare={handleRemoveShare}
    />
  )
}
