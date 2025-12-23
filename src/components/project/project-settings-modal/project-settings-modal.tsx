import { useAtomValue } from 'jotai'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  useAuth,
  useHandleAddDependency,
  useHandleAddShare,
  useHandleAddTag,
  useHandleDeleteProject,
  useHandleRemoveDependency,
  useHandleRemoveShare,
  useHandleRemoveTag,
  useHandleSaveProject
} from '@/hooks'
import { currentProjectAtom, projectsAtom } from '@/store/projects'
import { ProjectSettingsModalView } from './project-settings-modal.view'

type ProjectSettingsModalProps = Readonly<{
  onClose: () => void
}>

/**
 * Container component for project settings modal
 * Handles business logic and delegates rendering to ProjectSettingsModalView
 */
export function ProjectSettingsModal({ onClose }: ProjectSettingsModalProps) {
  const navigate = useNavigate()
  const { user } = useAuth()

  // Clean Architecture hooks for operations
  const { handleSave, loading: saveLoading } = useHandleSaveProject()
  const { handleDelete, loading: deleteLoading } = useHandleDeleteProject()
  const { handleAddTag, loading: addTagLoading } = useHandleAddTag()
  const { handleRemoveTag, loading: removeTagLoading } = useHandleRemoveTag()
  const { handleAddDependency, loading: addDependencyLoading } =
    useHandleAddDependency()
  const { handleRemoveDependency, loading: removeDependencyLoading } =
    useHandleRemoveDependency()
  const { handleAddShare, loading: addShareLoading } = useHandleAddShare()
  const { handleRemoveShare, loading: removeShareLoading } =
    useHandleRemoveShare()

  // Read from global state
  const currentProject = useAtomValue(currentProjectAtom)
  const projects = useAtomValue(projectsAtom)

  // Form state
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

  if (!currentProject || !user) return null

  // Combined loading state
  const loading =
    saveLoading ||
    deleteLoading ||
    addTagLoading ||
    removeTagLoading ||
    addDependencyLoading ||
    removeDependencyLoading ||
    addShareLoading ||
    removeShareLoading

  // Handlers that delegate to hooks
  const onSave = async () => {
    const result = await handleSave({
      projectId: currentProject.id,
      userId: user.id,
      name,
      description,
      visibility: visibility === 'shared' ? 'private' : visibility,
      isLibrary
    })
    if (result.success) {
      onClose()
    } else if (result.error) {
      alert(result.error)
    }
  }

  const onDelete = async () => {
    const result = await handleDelete(
      currentProject.id,
      user.id,
      currentProject.name.value
    )
    if (result.success) {
      onClose()
      navigate('/')
    } else if (result.error) {
      alert(result.error)
    }
  }

  const onAddTag = async () => {
    const result = await handleAddTag(currentProject.id, user.id, newTag)
    if (result.success) {
      setNewTag('')
    } else if (result.error) {
      alert(result.error)
    }
  }

  const onRemoveTag = async (tagName: string) => {
    const result = await handleRemoveTag(currentProject.id, user.id, tagName)
    if (result.error) {
      alert(result.error)
    }
  }

  const onAddDependency = async () => {
    const result = await handleAddDependency(
      currentProject.id,
      user.id,
      selectedDependency
    )
    if (result.success) {
      setSelectedDependency('')
    } else if (result.error) {
      alert(result.error)
    }
  }

  const onRemoveDependency = async (dependencyId: string) => {
    const result = await handleRemoveDependency(
      currentProject.id,
      user.id,
      dependencyId
    )
    if (result.error) {
      alert(result.error)
    }
  }

  const onAddShare = async () => {
    const result = await handleAddShare(
      currentProject.id,
      user.id,
      shareUsername
    )
    if (result.success) {
      setShareUsername('')
    } else if (result.error) {
      alert(result.error)
    }
  }

  const onRemoveShare = async (targetUserId: string) => {
    const result = await handleRemoveShare(
      currentProject.id,
      user.id,
      targetUserId
    )
    if (result.error) {
      alert(result.error)
    }
  }

  // Get current dependency IDs for filtering
  const currentDependencyIds = new Set(
    (currentProject.dependencies || []).map((d) => d.id)
  )

  // Filter available dependencies (libraries not already added)
  const availableDependencies = projects
    .filter(
      (p) =>
        p.isLibrary &&
        p.id !== currentProject.id &&
        !currentDependencyIds.has(p.id)
    )
    .map((p) => ({ id: p.id, name: p.name.value }))

  // Current dependencies already have name info from the entity
  const currentDependencies = currentProject.dependencies || []

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
      onSave={onSave}
      onClose={onClose}
      onAddTag={onAddTag}
      onRemoveTag={onRemoveTag}
      onAddDependency={onAddDependency}
      onRemoveDependency={onRemoveDependency}
      onAddShare={onAddShare}
      onRemoveShare={onRemoveShare}
      onDelete={onDelete}
    />
  )
}
