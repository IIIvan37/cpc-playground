import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createAuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createRemoveUserShareUseCase } from '../remove-user-share.use-case'

describe('RemoveUserShareUseCase', () => {
  let repository: IProjectsRepository & {
    _addUser: (id: string, username: string) => void
    _clear: () => void
  }
  let authorizationService: AuthorizationService
  let useCase: ReturnType<typeof createRemoveUserShareUseCase>
  const ownerId = 'owner-123'
  const sharedUserId = 'shared-456'
  const projectId = 'project-1'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository() as any
    authorizationService = createAuthorizationService(repository)
    useCase = createRemoveUserShareUseCase(repository, authorizationService)

    repository._clear()

    // Add users for testing
    repository._addUser(ownerId, 'bob')
    repository._addUser(sharedUserId, 'alice')

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

    // Add a share
    await repository.addUserShare(projectId, sharedUserId)
  })

  it('should remove a user share successfully', async () => {
    // Verify share exists
    const sharesBefore = await repository.getUserShares(projectId)
    expect(sharesBefore).toHaveLength(1)

    const result = await useCase.execute({
      projectId,
      userId: ownerId,
      targetUserId: sharedUserId
    })

    expect(result.success).toBe(true)

    // Verify share is removed
    const sharesAfter = await repository.getUserShares(projectId)
    expect(sharesAfter).toHaveLength(0)
  })

  it('should throw NotFoundError when project does not exist', async () => {
    await expect(
      useCase.execute({
        projectId: 'non-existent',
        userId: ownerId,
        targetUserId: sharedUserId
      })
    ).rejects.toThrow(NotFoundError)
  })

  it('should throw UnauthorizedError when user is not the project owner', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: 'other-user',
        targetUserId: sharedUserId
      })
    ).rejects.toThrow(UnauthorizedError)
  })

  it('should succeed even if share does not exist (idempotent)', async () => {
    const result = await useCase.execute({
      projectId,
      userId: ownerId,
      targetUserId: 'non-existent-user'
    })

    expect(result.success).toBe(true)
  })
})
