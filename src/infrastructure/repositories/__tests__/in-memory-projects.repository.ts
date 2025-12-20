import type { Project } from '@/domain/entities/project.entity'
import type { ProjectDependency } from '@/domain/entities/project-dependency.entity'
import type { ProjectShare } from '@/domain/entities/project-share.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { ShareCode } from '@/domain/value-objects/share-code.vo'

/**
 * In-memory implementation of IProjectsRepository for testing purposes.
 * Provides a realistic repository implementation without external dependencies.
 */
export function createInMemoryProjectsRepository(): IProjectsRepository {
  const projects = new Map<string, Project>()
  const shares = new Map<string, ProjectShare[]>()
  const dependencies = new Map<string, ProjectDependency[]>()
  const shareCodeIndex = new Map<string, string>() // shareCode -> projectId

  return {
    async findAll(userId: string): Promise<Project[]> {
      return Array.from(projects.values()).filter(
        (project) => project.userId === userId
      )
    },

    async findById(id: string): Promise<Project | null> {
      return projects.get(id) ?? null
    },

    async findByShareCode(shareCode: ShareCode): Promise<Project | null> {
      const projectId = shareCodeIndex.get(shareCode.value)
      if (!projectId) return null
      return projects.get(projectId) ?? null
    },

    async create(project: Project): Promise<Project> {
      projects.set(project.id, project)
      return project
    },

    async update(project: Project): Promise<Project> {
      if (!projects.has(project.id)) {
        throw new Error(`Project with id ${project.id} not found`)
      }
      projects.set(project.id, project)
      return project
    },

    async delete(id: string): Promise<void> {
      projects.delete(id)
      shares.delete(id)
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

    async createShare(share: ProjectShare): Promise<ProjectShare> {
      const projectShares = shares.get(share.projectId) ?? []
      projectShares.push(share)
      shares.set(share.projectId, projectShares)
      shareCodeIndex.set(share.shareCode.value, share.projectId)
      return share
    },

    async getDependencies(projectId: string): Promise<ProjectDependency[]> {
      return dependencies.get(projectId) ?? []
    },

    async addDependency(
      dependency: ProjectDependency
    ): Promise<ProjectDependency> {
      const projectDependencies = dependencies.get(dependency.projectId) ?? []
      projectDependencies.push(dependency)
      dependencies.set(dependency.projectId, projectDependencies)
      return dependency
    },

    async removeDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const projectDependencies = dependencies.get(projectId) ?? []
      const filtered = projectDependencies.filter(
        (dep) => dep.id !== dependencyId
      )
      dependencies.set(projectId, filtered)
    }
  }
}
