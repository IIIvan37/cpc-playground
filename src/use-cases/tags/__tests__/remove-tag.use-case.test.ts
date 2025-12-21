import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { AUTH_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createAuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAddTagUseCase } from '../add-tag.use-case'
import { createRemoveTagUseCase } from '../remove-tag.use-case'

describe('RemoveTagUseCase', () => {
  let repository: IProjectsRepository
  let authorizationService: AuthorizationService
  let addTagUseCase: ReturnType<typeof createAddTagUseCase>
  let removeTagUseCase: ReturnType<typeof createRemoveTagUseCase>
  const userId = 'user-123'
  const projectId = 'project-456'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository()
    authorizationService = createAuthorizationService(repository)
    addTagUseCase = createAddTagUseCase(repository, authorizationService)
    removeTagUseCase = createRemoveTagUseCase(repository, authorizationService)

    // Create a test project
    const project = createProject({
      id: projectId,
      userId,
      name: createProjectName('Test Project'),
      description: null,
      visibility: createVisibility('private'),
      isLibrary: false,
      files: [],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(project)
  })

  it('should remove a tag from a project by tag id', async () => {
    // Add a tag first
    const { tag } = await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    // Verify tag exists
    let tags = await repository.getTags(projectId)
    expect(tags.length).toBe(1)

    // Remove the tag by ID
    const result = await removeTagUseCase.execute({
      projectId,
      userId,
      tagIdOrName: tag.id
    })

    expect(result.success).toBe(true)

    // Verify tag is removed
    tags = await repository.getTags(projectId)
    expect(tags.length).toBe(0)
  })

  it('should remove a tag from a project by tag name', async () => {
    // Add a tag first
    await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    // Verify tag exists
    let tags = await repository.getTags(projectId)
    expect(tags.length).toBe(1)

    // Remove the tag by name
    const result = await removeTagUseCase.execute({
      projectId,
      userId,
      tagIdOrName: 'assembly'
    })

    expect(result.success).toBe(true)

    // Verify tag is removed
    tags = await repository.getTags(projectId)
    expect(tags.length).toBe(0)
  })

  it('should only remove the specified tag', async () => {
    // Add multiple tags
    const { tag: tag1 } = await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })
    await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'cpc'
    })
    await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'game'
    })

    // Verify 3 tags exist
    let tags = await repository.getTags(projectId)
    expect(tags.length).toBe(3)

    // Remove one tag by id
    await removeTagUseCase.execute({
      projectId,
      userId,
      tagIdOrName: tag1.id
    })

    // Verify only 2 tags remain
    tags = await repository.getTags(projectId)
    expect(tags.length).toBe(2)
    expect(tags.map((t) => t.name)).not.toContain('assembly')
    expect(tags.map((t) => t.name)).toContain('cpc')
    expect(tags.map((t) => t.name)).toContain('game')
  })

  it('should throw ProjectNotFoundError for non-existent project', async () => {
    await expect(
      removeTagUseCase.execute({
        projectId: 'non-existent-id',
        userId,
        tagIdOrName: 'some-tag'
      })
    ).rejects.toThrow(AUTH_ERRORS.PROJECT_NOT_FOUND)
  })

  it('should throw UnauthorizedError when user does not own the project', async () => {
    // Add a tag first
    const { tag } = await addTagUseCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    await expect(
      removeTagUseCase.execute({
        projectId,
        userId: 'other-user',
        tagIdOrName: tag.id
      })
    ).rejects.toThrow(AUTH_ERRORS.UNAUTHORIZED_MODIFY)
  })

  it('should succeed even if tag does not exist on project', async () => {
    // This should not throw - removing a non-existent tag is a no-op
    const result = await removeTagUseCase.execute({
      projectId,
      userId,
      tagIdOrName: 'non-existent-tag'
    })

    expect(result.success).toBe(true)
  })
})
