/**
 * Tests for file use-cases
 */

import { describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import { createMockAuthorizationService } from '@/domain/services/__tests__/mock-authorization.service'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createCreateFileUseCase } from '../create-file.use-case'
import { createDeleteFileUseCase } from '../delete-file.use-case'
import { createUpdateFileUseCase } from '../update-file.use-case'

function createTestDependencies() {
  const repository = createInMemoryProjectsRepository()
  const authorizationService = createMockAuthorizationService(repository)
  return { repository, authorizationService }
}

describe('File Use Cases', () => {
  describe('CreateFileUseCase', () => {
    it('should create a new file in a project', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const mainFile = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [mainFile]
      })

      await repository.create(project)

      const useCase = createCreateFileUseCase(repository, authorizationService)

      const result = await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        name: 'utils.asm',
        content: '; Utilities'
      })

      expect(result.file.name.value).toBe('utils.asm')
      expect(result.file.content.value).toBe('; Utilities')
      expect(result.file.isMain).toBe(false)

      // Verify file was added to project
      const updatedProject = await repository.findById('proj-1')
      expect(updatedProject?.files).toHaveLength(2)
    })

    it('should unset other main files when creating a main file', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const mainFile = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [mainFile]
      })

      await repository.create(project)

      const useCase = createCreateFileUseCase(repository, authorizationService)

      await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        name: 'new-main.asm',
        isMain: true
      })

      const updatedProject = await repository.findById('proj-1')
      const mainFiles = updatedProject?.files.filter((f) => f.isMain)
      expect(mainFiles).toHaveLength(1)
      expect(mainFiles?.[0].name.value).toBe('new-main.asm')
    })

    it('should throw NotFoundError when project does not exist', async () => {
      const { repository, authorizationService } = createTestDependencies()
      const useCase = createCreateFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'invalid',
          userId: 'user-1',
          name: 'file.asm'
        })
      ).rejects.toThrow(NotFoundError)
    })

    it('should throw UnauthorizedError when user is not owner', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: []
      })

      await repository.create(project)

      const useCase = createCreateFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-2', // Different user
          name: 'file.asm'
        })
      ).rejects.toThrow(UnauthorizedError)
    })
  })

  describe('UpdateFileUseCase', () => {
    it('should update file content', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent('old content'),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      await repository.create(project)

      const useCase = createUpdateFileUseCase(repository, authorizationService)

      const result = await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        fileId: 'file-1',
        content: 'new content'
      })

      expect(result.file.content.value).toBe('new content')

      const updatedProject = await repository.findById('proj-1')
      expect(updatedProject?.files[0].content.value).toBe('new content')
    })

    it('should throw UnauthorizedError when user is not owner', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      await repository.create(project)

      const useCase = createUpdateFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-2',
          fileId: 'file-1',
          content: 'hacked'
        })
      ).rejects.toThrow(UnauthorizedError)
    })

    it('should throw NotFoundError when file does not exist', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      await repository.create(project)

      const useCase = createUpdateFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'nonexistent',
          content: 'new content'
        })
      ).rejects.toThrow(NotFoundError)
    })

    it('should update file name', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('old-name.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      await repository.create(project)

      const useCase = createUpdateFileUseCase(repository, authorizationService)

      const result = await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        fileId: 'file-1',
        name: 'new-name.asm'
      })

      expect(result.file.name.value).toBe('new-name.asm')
    })

    it('should throw error when setting isMain on library project', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('lib.asm'),
        content: createFileContent(''),
        isMain: false,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('My Library'),
        visibility: Visibility.PRIVATE,
        isLibrary: true,
        files: [file]
      })

      await repository.create(project)

      const useCase = createUpdateFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-1',
          isMain: true
        })
      ).rejects.toThrow('Library projects cannot have a main file')
    })
  })

  describe('DeleteFileUseCase', () => {
    it('should delete a file', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file1 = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const file2 = createProjectFile({
        id: 'file-2',
        projectId: 'proj-1',
        name: createFileName('utils.asm'),
        content: createFileContent(''),
        isMain: false,
        order: 1
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file1, file2]
      })

      await repository.create(project)

      const useCase = createDeleteFileUseCase(repository, authorizationService)

      const result = await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        fileId: 'file-2'
      })

      expect(result.success).toBe(true)

      const updatedProject = await repository.findById('proj-1')
      expect(updatedProject?.files).toHaveLength(1)
      expect(updatedProject?.files[0].id).toBe('file-1')
    })

    it('should make first file main when deleting main file', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file1 = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const file2 = createProjectFile({
        id: 'file-2',
        projectId: 'proj-1',
        name: createFileName('utils.asm'),
        content: createFileContent(''),
        isMain: false,
        order: 1
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file1, file2]
      })

      await repository.create(project)

      const useCase = createDeleteFileUseCase(repository, authorizationService)

      await useCase.execute({
        projectId: 'proj-1',
        userId: 'user-1',
        fileId: 'file-1'
      })

      const updatedProject = await repository.findById('proj-1')
      expect(updatedProject?.files[0].isMain).toBe(true)
    })

    it('should throw error when deleting last file', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      await repository.create(project)

      const useCase = createDeleteFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-1'
        })
      ).rejects.toThrow('Cannot delete the last file')
    })

    it('should throw NotFoundError when file does not exist', async () => {
      const { repository, authorizationService } = createTestDependencies()

      const file = createProjectFile({
        id: 'file-1',
        projectId: 'proj-1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true,
        order: 0
      })

      const file2 = createProjectFile({
        id: 'file-2',
        projectId: 'proj-1',
        name: createFileName('utils.asm'),
        content: createFileContent(''),
        isMain: false,
        order: 1
      })

      const project = createProject({
        id: 'proj-1',
        userId: 'user-1',
        name: createProjectName('Test Project'),
        visibility: Visibility.PRIVATE,
        files: [file, file2]
      })

      await repository.create(project)

      const useCase = createDeleteFileUseCase(repository, authorizationService)

      await expect(
        useCase.execute({
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'nonexistent'
        })
      ).rejects.toThrow(NotFoundError)
    })
  })
})
