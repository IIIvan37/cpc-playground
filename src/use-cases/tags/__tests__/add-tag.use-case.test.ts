import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { TAG_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createMockAuthorizationService } from '@/domain/services/__tests__/mock-authorization.service'
import { AUTH_ERROR_MESSAGES } from '@/domain/services/authorization.service'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAddTagUseCase } from '../add-tag.use-case'

describe('AddTagUseCase', () => {
  let repository: IProjectsRepository
  let authorizationService: AuthorizationService
  let useCase: ReturnType<typeof createAddTagUseCase>
  const userId = 'user-123'
  const projectId = 'project-456'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository()
    authorizationService = createMockAuthorizationService(repository)
    useCase = createAddTagUseCase(repository, authorizationService)

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

  it('should add a tag to a project', async () => {
    const result = await useCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    expect(result.tag).toBeDefined()
    expect(result.tag.name).toBe('assembly')
    expect(result.tag.id).toBeDefined()
  })

  it('should normalize tag names to lowercase', async () => {
    const result = await useCase.execute({
      projectId,
      userId,
      tagName: 'ASSEMBLY'
    })

    expect(result.tag.name).toBe('assembly')
  })

  it('should trim whitespace from tag names', async () => {
    const result = await useCase.execute({
      projectId,
      userId,
      tagName: '  cpc-464  '
    })

    expect(result.tag.name).toBe('cpc-464')
  })

  it('should allow alphanumeric tags with hyphens', async () => {
    const result = await useCase.execute({
      projectId,
      userId,
      tagName: 'cpc-6128-plus'
    })

    expect(result.tag.name).toBe('cpc-6128-plus')
  })

  it('should throw ValidationError for empty tag', async () => {
    const emptyTag = ''
    await expect(
      useCase.execute({
        projectId,
        userId,
        tagName: emptyTag
      })
    ).rejects.toThrow(TAG_ERRORS.INVALID(emptyTag))
  })

  it('should throw ValidationError for tag with spaces', async () => {
    const tagWithSpaces = 'my tag'
    await expect(
      useCase.execute({
        projectId,
        userId,
        tagName: tagWithSpaces
      })
    ).rejects.toThrow(TAG_ERRORS.INVALID(tagWithSpaces))
  })

  it('should throw ValidationError for tag too short', async () => {
    const shortTag = 'a'
    await expect(
      useCase.execute({
        projectId,
        userId,
        tagName: shortTag
      })
    ).rejects.toThrow(TAG_ERRORS.INVALID(shortTag))
  })

  it('should throw ValidationError for tag too long', async () => {
    const longTag = 'a'.repeat(31)
    await expect(
      useCase.execute({
        projectId,
        userId,
        tagName: longTag
      })
    ).rejects.toThrow(TAG_ERRORS.INVALID(longTag))
  })

  it('should throw ValidationError for tag with special characters', async () => {
    const tagWithSpecialChars = 'my_tag!'
    await expect(
      useCase.execute({
        projectId,
        userId,
        tagName: tagWithSpecialChars
      })
    ).rejects.toThrow(TAG_ERRORS.INVALID(tagWithSpecialChars))
  })

  it('should throw ProjectNotFoundError for non-existent project', async () => {
    await expect(
      useCase.execute({
        projectId: 'non-existent-id',
        userId,
        tagName: 'assembly'
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.PROJECT_NOT_FOUND)
  })

  it('should throw UnauthorizedError when user does not own the project', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: 'other-user',
        tagName: 'assembly'
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.UNAUTHORIZED_MODIFY)
  })

  it('should reuse existing tag when adding same tag name', async () => {
    // Add first tag
    const result1 = await useCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    // Create another project
    const project2 = createProject({
      id: 'project-789',
      userId,
      name: createProjectName('Second Project'),
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
    await repository.create(project2)

    // Add same tag to second project
    const result2 = await useCase.execute({
      projectId: 'project-789',
      userId,
      tagName: 'assembly'
    })

    // Should be the same tag (same id)
    expect(result1.tag.id).toBe(result2.tag.id)
    expect(result1.tag.name).toBe(result2.tag.name)
  })

  it('should not add duplicate tag to same project', async () => {
    // Add tag first time
    await useCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    // Add same tag again
    await useCase.execute({
      projectId,
      userId,
      tagName: 'assembly'
    })

    // Should still have only one tag
    const tags = await repository.getTags(projectId)
    expect(tags.length).toBe(1)
  })
})
