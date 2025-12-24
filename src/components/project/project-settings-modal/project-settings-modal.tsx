import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import {
  useAuth,
  useAvailableDependencies,
  useCurrentProject,
  useHandleAddDependency,
  useHandleAddShare,
  useHandleAddTag,
  useHandleDeleteProject,
  useHandleRemoveDependency,
  useHandleRemoveShare,
  useHandleRemoveTag,
  useHandleSaveProject,
  useSearchUsers
} from '@/hooks'
import { ProjectSettingsModalView } from './project-settings-modal.view'

type ProjectSettingsModalProps = Readonly<{
  onClose: () => void
}>

/**
 * Inner component that uses Suspense query
 */
function ProjectSettingsModalContent({ onClose }: ProjectSettingsModalProps) {
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

  // User search
  const {
    users: foundUsers,
    loading: searchUsersLoading,
    searchUsers
  } = useSearchUsers()

  // Read project directly from React Query (single source of truth)
  const { project: currentProject } = useCurrentProject()

  // Get available dependencies (libraries) from React Query
  const availableDependencies = useAvailableDependencies(
    currentProject?.id ?? null
  )

  // Form state - initialize with empty values
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [visibility, setVisibility] = useState<'private' | 'public'>('private')
  const [isLibrary, setIsLibrary] = useState(false)
  const [newTag, setNewTag] = useState('')
  const [selectedDependency, setSelectedDependency] = useState('')
  const [shareUsername, setShareUsername] = useState('')

  // Sync form state when project data loads or changes
  useEffect(() => {
    if (currentProject) {
      setName(currentProject.name?.value || '')
      setDescription(currentProject.description || '')
      setVisibility(
        currentProject.visibility?.value === 'unlisted'
          ? 'private'
          : (currentProject.visibility?.value as 'private' | 'public') ||
              'private'
      )
      setIsLibrary(currentProject.isLibrary || false)
    }
  }, [currentProject])

  // Debounce user search
  useEffect(() => {
    if (!shareUsername.trim()) return

    const timer = setTimeout(() => {
      searchUsers(shareUsername, 10)
    }, 300)

    return () => clearTimeout(timer)
  }, [shareUsername, searchUsers])

  // Handle user selection from combobox
  const handleUserSelect = useCallback((username: string) => {
    setShareUsername(username)
  }, [])

  if (!user || !currentProject) return null

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
      visibility,
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
      // Cache automatically invalidated by useMutation
      // Note: visibility is independent of shares - a project can be
      // private/public with or without user shares
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
  const filteredDependencies = availableDependencies
    .filter((p) => !currentDependencyIds.has(p.id))
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
      availableDependencies={filteredDependencies}
      foundUsers={foundUsers}
      searchingUsers={searchUsersLoading}
      onNameChange={setName}
      onDescriptionChange={setDescription}
      onVisibilityChange={setVisibility}
      onIsLibraryChange={setIsLibrary}
      onNewTagChange={setNewTag}
      onSelectedDependencyChange={setSelectedDependency}
      onShareUsernameChange={setShareUsername}
      onUserSelect={handleUserSelect}
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

/**
 * Container component for project settings modal
 * Handles business logic and delegates rendering to ProjectSettingsModalView
 */
export function ProjectSettingsModal({ onClose }: ProjectSettingsModalProps) {
  return <ProjectSettingsModalContent onClose={onClose} />
}
