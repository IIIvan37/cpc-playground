import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import { AUTH_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAuthorizationService } from '../authorization.service'

describe('AuthorizationService', () => {
  let repository: IProjectsRepository & {
    _addUser: (id: string, username: string) => void
  }
  let service: ReturnType<typeof createAuthorizationService>

  const ownerId = 'owner-123'
  const otherUserId = 'other-user'
  const sharedUserId = 'shared-user'
  const projectId = 'project-123'

  beforeEach(() => {
    repository = createInMemoryProjectsRepository()
    service = createAuthorizationService(repository)
  })

  async function createTestProject(overrides?: {
    id?: string
    userId?: string
    visibility?: 'private' | 'unlisted' | 'public'
    isLibrary?: boolean
  }) {
    const id = overrides?.id ?? projectId
    const project = createProject({
      id,
      userId: overrides?.userId ?? ownerId,
      name: createProjectName('Test Project'),
      description: null,
      visibility: createVisibility(overrides?.visibility ?? 'private'),
      isLibrary: overrides?.isLibrary ?? false,
      files: [
        createProjectFile({
          id: `${id}-file-1`,
          projectId: id,
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true,
          order: 0
        })
      ],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(project)
    return project
  }

  describe('canReadProject', () => {
    it('should return false if project not found', async () => {
      const result = await service.canReadProject('non-existent', otherUserId)

      expect(result).toBe(false)
    })

    it('should return true for owner', async () => {
      await createTestProject()

      const result = await service.canReadProject(projectId, ownerId)

      expect(result).toBe(true)
    })

    it('should return true for public project', async () => {
      await createTestProject({ visibility: 'public' })

      const result = await service.canReadProject(projectId, otherUserId)

      expect(result).toBe(true)
    })

    it('should return true for library project', async () => {
      await createTestProject({ visibility: 'private', isLibrary: true })

      const result = await service.canReadProject(projectId, otherUserId)

      expect(result).toBe(true)
    })

    it('should return true for shared project', async () => {
      await createTestProject({ visibility: 'private' })
      // Add the shared user to the in-memory repository
      repository._addUser(sharedUserId, 'shareduser')
      await repository.addUserShare(projectId, sharedUserId)

      const result = await service.canReadProject(projectId, sharedUserId)

      expect(result).toBe(true)
    })

    it('should return false for private project without share', async () => {
      await createTestProject({ visibility: 'private' })

      const result = await service.canReadProject(projectId, otherUserId)

      expect(result).toBe(false)
    })

    it('should return false for unlisted project without share', async () => {
      await createTestProject({ visibility: 'unlisted' })

      const result = await service.canReadProject(projectId, otherUserId)

      expect(result).toBe(false)
    })
  })

  describe('mustOwnProject', () => {
    it('should throw NotFoundError if project not found', async () => {
      await expect(
        service.mustOwnProject('non-existent', ownerId)
      ).rejects.toThrow(NotFoundError)

      await expect(
        service.mustOwnProject('non-existent', ownerId)
      ).rejects.toThrow(AUTH_ERRORS.PROJECT_NOT_FOUND)
    })

    it('should throw UnauthorizedError if user is not owner', async () => {
      await createTestProject()

      await expect(
        service.mustOwnProject(projectId, otherUserId)
      ).rejects.toThrow(UnauthorizedError)

      await expect(
        service.mustOwnProject(projectId, otherUserId)
      ).rejects.toThrow(AUTH_ERRORS.UNAUTHORIZED_MODIFY)
    })

    it('should return project if user is owner', async () => {
      const project = await createTestProject()

      const result = await service.mustOwnProject(projectId, ownerId)

      expect(result.id).toBe(project.id)
      expect(result.userId).toBe(ownerId)
    })
  })

  describe('canAccessAsDependency', () => {
    it('should return false if project not found', async () => {
      const result = await service.canAccessAsDependency(
        'non-existent',
        otherUserId
      )

      expect(result).toBe(false)
    })

    it('should return true for owner', async () => {
      await createTestProject()

      const result = await service.canAccessAsDependency(projectId, ownerId)

      expect(result).toBe(true)
    })

    it('should return true for public project', async () => {
      await createTestProject({ visibility: 'public' })

      const result = await service.canAccessAsDependency(projectId, otherUserId)

      expect(result).toBe(true)
    })

    it('should return true for library project', async () => {
      await createTestProject({ visibility: 'private', isLibrary: true })

      const result = await service.canAccessAsDependency(projectId, otherUserId)

      expect(result).toBe(true)
    })

    it('should return false for private non-library project', async () => {
      await createTestProject({ visibility: 'private', isLibrary: false })

      const result = await service.canAccessAsDependency(projectId, otherUserId)

      expect(result).toBe(false)
    })

    it('should return false for unlisted non-library project', async () => {
      await createTestProject({ visibility: 'unlisted', isLibrary: false })

      const result = await service.canAccessAsDependency(projectId, otherUserId)

      expect(result).toBe(false)
    })
  })
})
