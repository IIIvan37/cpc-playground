// TODO: Remove @ts-nocheck once ProjectDependency entity and proper types are implemented
// @ts-nocheck
import type {
  Project,
  ProjectShare,
  UserShare
} from '@/domain/entities/project.entity'
import type {
  IProjectsRepository,
  Tag
} from '@/domain/repositories/projects.repository.interface'

/**
 * In-memory implementation of IProjectsRepository for testing purposes.
 * Provides a realistic repository implementation without external dependencies.
 */
export function createInMemoryProjectsRepository(): IProjectsRepository {
  const projects = new Map<string, Project>()
  const shares = new Map<string, ProjectShare[]>()
  const shareCodeIndex = new Map<string, string>() // shareCode -> projectId
  const tags = new Map<string, Tag>() // tagId -> Tag
  const projectTags = new Map<string, string[]>() // projectId -> tagIds
  const dependencies = new Map<string, string[]>() // projectId -> dependencyIds
  const users = new Map<string, { id: string; username: string }>() // userId -> user
  const userShares = new Map<string, UserShare[]>() // projectId -> UserShares

  return {
    async findAll(userId: string): Promise<Project[]> {
      return Array.from(projects.values()).filter(
        (project) => project.userId === userId
      )
    },

    async findById(id: string): Promise<Project | null> {
      return projects.get(id) ?? null
    },

    async findByShareCode(shareCode: string): Promise<Project | null> {
      const projectId = shareCodeIndex.get(shareCode)
      if (!projectId) return null
      return projects.get(projectId) ?? null
    },

    async create(project: Project): Promise<Project> {
      projects.set(project.id, project)
      return project
    },

    async update(
      projectId: string,
      updates: Partial<Project>
    ): Promise<Project> {
      const project = projects.get(projectId)
      if (!project) {
        throw new Error(`Project with id ${projectId} not found`)
      }
      const updatedProject = { ...project, ...updates }
      projects.set(projectId, updatedProject)
      return updatedProject
    },

    async delete(id: string): Promise<void> {
      projects.delete(id)
      shares.delete(id)
      projectTags.delete(id)
      dependencies.delete(id)

      // Clean up share code index
      for (const [shareCode, projectId] of shareCodeIndex.entries()) {
        if (projectId === id) {
          shareCodeIndex.delete(shareCode)
        }
      }
    },

    async getShares(projectId: string): Promise<ProjectShare[]> {
      return shares.get(projectId) ?? []
    },

    async createShare(projectId: string): Promise<ProjectShare> {
      const share: ProjectShare = {
        id: crypto.randomUUID(),
        shareCode: crypto.randomUUID(),
        createdAt: new Date()
      }
      const projectShares = shares.get(projectId) ?? []
      projectShares.push(share)
      shares.set(projectId, projectShares)
      shareCodeIndex.set(share.shareCode, projectId)
      return share
    },

    // ========================================================================
    // Tags
    // ========================================================================

    async getTags(projectId: string): Promise<readonly Tag[]> {
      const tagIds = projectTags.get(projectId) ?? []
      return tagIds
        .map((id) => tags.get(id))
        .filter((t): t is Tag => t !== undefined)
    },

    async addTag(projectId: string, tagName: string): Promise<Tag> {
      const normalizedName = tagName.toLowerCase().trim()

      // Find existing tag by name
      let existingTag: Tag | undefined
      for (const tag of tags.values()) {
        if (tag.name === normalizedName) {
          existingTag = tag
          break
        }
      }

      let tag: Tag
      if (existingTag) {
        tag = existingTag
      } else {
        // Create new tag
        tag = {
          id: crypto.randomUUID(),
          name: normalizedName
        }
        tags.set(tag.id, tag)
      }

      // Link tag to project (avoid duplicates)
      const currentTags = projectTags.get(projectId) ?? []
      if (!currentTags.includes(tag.id)) {
        currentTags.push(tag.id)
        projectTags.set(projectId, currentTags)
      }

      return tag
    },

    async removeTag(projectId: string, tagIdOrName: string): Promise<void> {
      const currentTags = projectTags.get(projectId) ?? []

      // Check if it's a tag id or name
      let tagIdToRemove = tagIdOrName

      // If not a UUID-like string, it might be a name - find the tag
      const isUuid =
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
          tagIdOrName
        )

      if (!isUuid) {
        // Find tag by name
        for (const tag of tags.values()) {
          if (tag.name === tagIdOrName.toLowerCase()) {
            tagIdToRemove = tag.id
            break
          }
        }
      }

      projectTags.set(
        projectId,
        currentTags.filter((id) => id !== tagIdToRemove)
      )
    },

    // ========================================================================
    // Dependencies
    // ========================================================================

    async getDependencies(projectId: string): Promise<readonly string[]> {
      return dependencies.get(projectId) ?? []
    },

    async addDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const currentDeps = dependencies.get(projectId) ?? []
      if (!currentDeps.includes(dependencyId)) {
        currentDeps.push(dependencyId)
        dependencies.set(projectId, currentDeps)
      }
    },

    async removeDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const currentDeps = dependencies.get(projectId) ?? []
      dependencies.set(
        projectId,
        currentDeps.filter((id) => id !== dependencyId)
      )
    },

    // ========================================================================
    // User Shares
    // ========================================================================

    async getUserShares(projectId: string): Promise<readonly UserShare[]> {
      return userShares.get(projectId) ?? []
    },

    async findUserByUsername(
      username: string
    ): Promise<{ id: string; username: string } | null> {
      for (const user of users.values()) {
        if (user.username.toLowerCase() === username.toLowerCase()) {
          return user
        }
      }
      return null
    },

    async addUserShare(projectId: string, userId: string): Promise<UserShare> {
      const user = users.get(userId)
      if (!user) {
        throw new Error(`User with id ${userId} not found`)
      }

      const existingShares = userShares.get(projectId) ?? []

      // Check for duplicate
      const existing = existingShares.find((s) => s.userId === userId)
      if (existing) {
        return existing
      }

      const share: UserShare = {
        projectId,
        userId,
        username: user.username,
        createdAt: new Date()
      }

      existingShares.push(share)
      userShares.set(projectId, existingShares)

      return share
    },

    async removeUserShare(projectId: string, userId: string): Promise<void> {
      const existingShares = userShares.get(projectId) ?? []
      userShares.set(
        projectId,
        existingShares.filter((s) => s.userId !== userId)
      )
    },

    // ========================================================================
    // Test helpers (not part of interface)
    // ========================================================================

    /** Add a user for testing purposes */
    _addUser(id: string, username: string): void {
      users.set(id, { id, username })
    },

    /** Clear all data for testing */
    _clear(): void {
      projects.clear()
      shares.clear()
      shareCodeIndex.clear()
      tags.clear()
      projectTags.clear()
      dependencies.clear()
      users.clear()
      userShares.clear()
    }
  }
}
