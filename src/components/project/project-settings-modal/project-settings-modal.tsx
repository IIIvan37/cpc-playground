import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { ConfirmDialog } from '@/components/ui/confirm-dialog'
import {
  useAllTags,
  useAuth,
  useAvailableDependencies,
  useConfirmDialog,
  useCurrentProject,
  useHandleAddDependency,
  useHandleAddShare,
  useHandleAddTag,
  useHandleDeleteProject,
  useHandleRemoveDependency,
  useHandleRemoveShare,
  useHandleRemoveTag,
  useHandleSaveProject,
  useSearchUsers,
  useToastActions
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
  const toast = useToastActions()
  const { confirm, dialogProps } = useConfirmDialog()

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

  // Available tags for autocompletion
  const { tags: availableTags = [] } = useAllTags()

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
      const visibilityValue = currentProject.visibility?.value
      const resolvedVisibility =
        visibilityValue === 'public' ? 'public' : 'private'
      setVisibility(resolvedVisibility)
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
      toast.success('Settings saved')
      onClose()
    } else if (result.error) {
      toast.error('Failed to save settings', result.error)
    }
  }

  const onDelete = async () => {
    const confirmed = await confirm({
      title: 'Delete project',
      message: `Are you sure you want to delete "${currentProject.name.value}"? This action cannot be undone.`,
      confirmLabel: 'Delete',
      variant: 'danger'
    })
    if (!confirmed) return

    const result = await handleDelete(currentProject.id, user.id)
    if (result.success) {
      toast.success('Project deleted')
      onClose()
      navigate('/explore')
    } else if (result.error) {
      toast.error('Failed to delete project', result.error)
    }
  }

  const onAddTag = async () => {
    const result = await handleAddTag(currentProject.id, user.id, newTag)
    if (result.success) {
      setNewTag('')
    } else if (result.error) {
      toast.error('Failed to add tag', result.error)
    }
  }

  const onRemoveTag = async (tagName: string) => {
    const result = await handleRemoveTag(currentProject.id, user.id, tagName)
    if (result.error) {
      toast.error('Failed to remove tag', result.error)
    }
  }

  const onAddDependency = async () => {
    // Find the dependency name from available dependencies
    const dep = availableDependencies.find((d) => d.id === selectedDependency)
    const dependencyName = dep?.name.value || selectedDependency

    const result = await handleAddDependency(
      currentProject.id,
      user.id,
      selectedDependency,
      dependencyName
    )
    if (result.success) {
      setSelectedDependency('')
    } else if (result.error) {
      toast.error('Failed to add dependency', result.error)
    }
  }

  const onRemoveDependency = async (dependencyId: string) => {
    const result = await handleRemoveDependency(
      currentProject.id,
      user.id,
      dependencyId
    )
    if (result.error) {
      toast.error('Failed to remove dependency', result.error)
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
      toast.success(
        'User added',
        `${shareUsername} can now access this project`
      )
    } else if (result.error) {
      toast.error('Failed to share project', result.error)
    }
  }

  const onRemoveShare = async (targetUserId: string) => {
    const result = await handleRemoveShare(
      currentProject.id,
      user.id,
      targetUserId
    )
    if (result.error) {
      toast.error('Failed to remove share', result.error)
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
    <>
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
        availableTags={availableTags}
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
      <ConfirmDialog {...dialogProps} />
    </>
  )
}

/**
 * Container component for project settings modal
 * Handles business logic and delegates rendering to ProjectSettingsModalView
 */
export function ProjectSettingsModal({ onClose }: ProjectSettingsModalProps) {
  return <ProjectSettingsModalContent onClose={onClose} />
}
