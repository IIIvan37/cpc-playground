import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import {
  NotFoundError,
  UnauthorizedError,
  ValidationError
} from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAddUserShareUseCase } from '../add-user-share.use-case'

describe('AddUserShareUseCase', () => {
  let repository: IProjectsRepository & {
    _addUser: (id: string, username: string) => void
    _clear: () => void
  }
  let useCase: ReturnType<typeof createAddUserShareUseCase>
  const ownerId = 'owner-123'
  const targetUserId = 'target-456'
  const targetUsername = 'alice'
  const projectId = 'project-1'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository() as any
    useCase = createAddUserShareUseCase(repository)

    repository._clear()

    // Add users for testing
    repository._addUser(ownerId, 'bob')
    repository._addUser(targetUserId, targetUsername)

    // Create a test project
    const project = createProject({
      id: projectId,
      userId: ownerId,
      name: createProjectName('Test Project'),
      description: null,
      visibility: createVisibility('private'),
      isLibrary: false,
      files: [],
      shares: [],
      userShares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(project)
  })

  it('should add a user share successfully', async () => {
    const result = await useCase.execute({
      projectId,
      userId: ownerId,
      username: targetUsername
    })

    expect(result.share).toBeDefined()
    expect(result.share.projectId).toBe(projectId)
    expect(result.share.userId).toBe(targetUserId)
    expect(result.share.username).toBe(targetUsername)
    expect(result.share.createdAt).toBeInstanceOf(Date)
  })

  it('should throw ValidationError with empty username', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: ownerId,
        username: ''
      })
    ).rejects.toThrow(ValidationError)
  })

  it('should throw ValidationError with whitespace-only username', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: ownerId,
        username: '   '
      })
    ).rejects.toThrow(ValidationError)
  })

  it('should throw NotFoundError when project does not exist', async () => {
    await expect(
      useCase.execute({
        projectId: 'non-existent',
        userId: ownerId,
        username: targetUsername
      })
    ).rejects.toThrow(NotFoundError)
  })

  it('should throw UnauthorizedError when user is not the project owner', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: 'other-user',
        username: targetUsername
      })
    ).rejects.toThrow(UnauthorizedError)
  })

  it('should throw NotFoundError when target user does not exist', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: ownerId,
        username: 'nonexistent_user'
      })
    ).rejects.toThrow(NotFoundError)
  })

  it('should throw ValidationError when trying to share with self', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: ownerId,
        username: 'bob' // owner's username
      })
    ).rejects.toThrow(ValidationError)
  })

  it('should be case insensitive for username lookup', async () => {
    const result = await useCase.execute({
      projectId,
      userId: ownerId,
      username: 'ALICE' // uppercase
    })

    expect(result.share.userId).toBe(targetUserId)
  })

  it('should return existing share if already shared (idempotent)', async () => {
    // Share once
    const firstResult = await useCase.execute({
      projectId,
      userId: ownerId,
      username: targetUsername
    })

    // Share again
    const secondResult = await useCase.execute({
      projectId,
      userId: ownerId,
      username: targetUsername
    })

    // Should return the same share
    expect(secondResult.share.createdAt).toEqual(firstResult.share.createdAt)
  })
})
