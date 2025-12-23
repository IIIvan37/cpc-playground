import { describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createGetVisibleProjectsUseCase } from '../get-visible-projects.use-case'

describe('GetVisibleProjectsUseCase', () => {
  describe('anonymous user (no userId)', () => {
    it('should return only public projects for anonymous users', async () => {
      const repository = createInMemoryProjectsRepository()

      const publicProject = createProject({
        id: 'public-1',
        userId: 'owner-1',
        name: createProjectName('Public Project'),
        visibility: Visibility.PUBLIC
      })

      const privateProject = createProject({
        id: 'private-1',
        userId: 'owner-1',
        name: createProjectName('Private Project'),
        visibility: Visibility.PRIVATE
      })

      const unlistedProject = createProject({
        id: 'unlisted-1',
        userId: 'owner-1',
        name: createProjectName('Unlisted Project'),
        visibility: Visibility.UNLISTED
      })

      await repository.create(publicProject)
      await repository.create(privateProject)
      await repository.create(unlistedProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({})

      expect(result.projects).toHaveLength(1)
      expect(result.projects[0].name.value).toBe('Public Project')
    })

    it('should return empty array when no public projects exist', async () => {
      const repository = createInMemoryProjectsRepository()

      const privateProject = createProject({
        id: 'private-1',
        userId: 'owner-1',
        name: createProjectName('Private Project'),
        visibility: Visibility.PRIVATE
      })

      await repository.create(privateProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({})

      expect(result.projects).toHaveLength(0)
    })
  })

  describe('authenticated user', () => {
    it('should return public projects for authenticated users', async () => {
      const repository = createInMemoryProjectsRepository()

      const publicProject = createProject({
        id: 'public-1',
        userId: 'other-user',
        name: createProjectName('Public Project'),
        visibility: Visibility.PUBLIC
      })

      await repository.create(publicProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      expect(result.projects).toHaveLength(1)
      expect(result.projects[0].name.value).toBe('Public Project')
    })

    it("should return user's own projects regardless of visibility", async () => {
      const repository = createInMemoryProjectsRepository()

      const publicProject = createProject({
        id: 'public-1',
        userId: 'user-1',
        name: createProjectName('My Public'),
        visibility: Visibility.PUBLIC
      })

      const privateProject = createProject({
        id: 'private-1',
        userId: 'user-1',
        name: createProjectName('My Private'),
        visibility: Visibility.PRIVATE
      })

      const unlistedProject = createProject({
        id: 'unlisted-1',
        userId: 'user-1',
        name: createProjectName('My Unlisted'),
        visibility: Visibility.UNLISTED
      })

      await repository.create(publicProject)
      await repository.create(privateProject)
      await repository.create(unlistedProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      expect(result.projects).toHaveLength(3)
    })

    it('should return projects shared with the user', async () => {
      const repository = createInMemoryProjectsRepository()

      // Add users
      repository._addUser('owner-1', 'owner')
      repository._addUser('user-1', 'viewer')

      const sharedProject = createProject({
        id: 'shared-1',
        userId: 'owner-1',
        name: createProjectName('Shared With Me'),
        visibility: Visibility.PRIVATE
      })

      await repository.create(sharedProject)
      await repository.addUserShare('shared-1', 'user-1')

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      expect(result.projects).toHaveLength(1)
      expect(result.projects[0].name.value).toBe('Shared With Me')
    })

    it('should not return private projects from others not shared', async () => {
      const repository = createInMemoryProjectsRepository()

      const otherPrivateProject = createProject({
        id: 'private-1',
        userId: 'other-user',
        name: createProjectName('Other Private'),
        visibility: Visibility.PRIVATE
      })

      await repository.create(otherPrivateProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      expect(result.projects).toHaveLength(0)
    })

    it('should deduplicate projects that appear in multiple categories', async () => {
      const repository = createInMemoryProjectsRepository()

      // Add users
      repository._addUser('user-1', 'user')

      // Project that is both public AND owned by user
      const publicOwnProject = createProject({
        id: 'public-own-1',
        userId: 'user-1',
        name: createProjectName('My Public Project'),
        visibility: Visibility.PUBLIC
      })

      await repository.create(publicOwnProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      // Should only appear once
      expect(result.projects).toHaveLength(1)
      expect(result.projects[0].id).toBe('public-own-1')
    })

    it('should combine public, own, and shared projects', async () => {
      const repository = createInMemoryProjectsRepository()

      // Add users
      repository._addUser('user-1', 'viewer')
      repository._addUser('owner-1', 'owner')
      repository._addUser('sharer-1', 'sharer')

      // Public project from another user
      const publicProject = createProject({
        id: 'public-1',
        userId: 'owner-1',
        name: createProjectName('Public Project'),
        visibility: Visibility.PUBLIC
      })

      // Own private project
      const ownProject = createProject({
        id: 'own-1',
        userId: 'user-1',
        name: createProjectName('My Project'),
        visibility: Visibility.PRIVATE
      })

      // Shared project
      const sharedProject = createProject({
        id: 'shared-1',
        userId: 'sharer-1',
        name: createProjectName('Shared Project'),
        visibility: Visibility.PRIVATE
      })

      await repository.create(publicProject)
      await repository.create(ownProject)
      await repository.create(sharedProject)
      await repository.addUserShare('shared-1', 'user-1')

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({ userId: 'user-1' })

      expect(result.projects).toHaveLength(3)
      const names = result.projects.map((p) => p.name.value)
      expect(names).toContain('Public Project')
      expect(names).toContain('My Project')
      expect(names).toContain('Shared Project')
    })
  })

  describe('sorting', () => {
    it('should return projects sorted by updatedAt descending', async () => {
      const repository = createInMemoryProjectsRepository()

      const oldProject = createProject({
        id: 'old-1',
        userId: 'owner-1',
        name: createProjectName('Old Project'),
        visibility: Visibility.PUBLIC,
        updatedAt: new Date('2023-01-01')
      })

      const newProject = createProject({
        id: 'new-1',
        userId: 'owner-1',
        name: createProjectName('New Project'),
        visibility: Visibility.PUBLIC,
        updatedAt: new Date('2024-01-01')
      })

      const middleProject = createProject({
        id: 'middle-1',
        userId: 'owner-1',
        name: createProjectName('Middle Project'),
        visibility: Visibility.PUBLIC,
        updatedAt: new Date('2023-06-01')
      })

      // Create in random order
      await repository.create(oldProject)
      await repository.create(newProject)
      await repository.create(middleProject)

      const useCase = createGetVisibleProjectsUseCase(repository)
      const result = await useCase.execute({})

      expect(result.projects[0].name.value).toBe('New Project')
      expect(result.projects[1].name.value).toBe('Middle Project')
      expect(result.projects[2].name.value).toBe('Old Project')
    })
  })
})
