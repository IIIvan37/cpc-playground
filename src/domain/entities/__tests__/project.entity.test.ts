import { describe, expect, it } from 'vitest'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import {
  addFile,
  addTag,
  createProject,
  getMainFile,
  removeFile,
  removeTag,
  updateFile,
  updateProject
} from '../project.entity'
import { createProjectFile } from '../project-file.entity'

describe('Project Entity', () => {
  const createTestProject = () =>
    createProject({
      userId: 'user-123',
      name: createProjectName('Test Project'),
      visibility: createVisibility('private')
    })

  const createTestFile = (overrides?: { isMain?: boolean; id?: string }) =>
    createProjectFile({
      id: overrides?.id ?? 'file-1',
      projectId: 'project-1',
      name: createFileName('test.asm'),
      content: createFileContent('; test'),
      isMain: overrides?.isMain ?? false
    })

  describe('createProject', () => {
    it('should create a project with required fields', () => {
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('My Project'),
        visibility: createVisibility('private')
      })

      expect(project.userId).toBe('user-123')
      expect(project.name.value).toBe('My Project')
      expect(project.visibility.value).toBe('private')
      expect(project.description).toBeNull()
      expect(project.isLibrary).toBe(false)
      expect(project.files).toEqual([])
      expect(project.tags).toEqual([])
      expect(project.dependencies).toEqual([])
      expect(project.shares).toEqual([])
      expect(project.userShares).toEqual([])
      expect(project.id).toBeDefined()
      expect(project.createdAt).toBeInstanceOf(Date)
      expect(project.updatedAt).toBeInstanceOf(Date)
    })

    it('should create a project with optional fields', () => {
      const customDate = new Date('2024-01-01')
      const project = createProject({
        id: 'custom-id',
        userId: 'user-123',
        name: createProjectName('My Project'),
        description: 'A description',
        visibility: createVisibility('public'),
        isLibrary: true,
        files: [],
        tags: ['tag1', 'tag2'],
        dependencies: [{ id: 'dep-1', name: 'Library 1' }],
        shares: [],
        userShares: [],
        createdAt: customDate,
        updatedAt: customDate
      })

      expect(project.id).toBe('custom-id')
      expect(project.description).toBe('A description')
      expect(project.isLibrary).toBe(true)
      expect(project.tags).toEqual(['tag1', 'tag2'])
      expect(project.dependencies).toEqual([{ id: 'dep-1', name: 'Library 1' }])
      expect(project.createdAt).toBe(customDate)
      expect(project.updatedAt).toBe(customDate)
    })

    it('should freeze the project object', () => {
      const project = createTestProject()
      expect(Object.isFrozen(project)).toBe(true)
    })
  })

  describe('updateProject', () => {
    it('should update name', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        name: createProjectName('New Name')
      })

      expect(updated.name.value).toBe('New Name')
      expect(updated.updatedAt.getTime()).toBeGreaterThanOrEqual(
        project.updatedAt.getTime()
      )
    })

    it('should update description', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        description: 'New description'
      })

      expect(updated.description).toBe('New description')
    })

    it('should update visibility', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        visibility: createVisibility('public')
      })

      expect(updated.visibility.value).toBe('public')
    })

    it('should update isLibrary', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        isLibrary: true
      })

      expect(updated.isLibrary).toBe(true)
    })

    it('should update files', () => {
      const project = createTestProject()
      const file = createTestFile()
      const updated = updateProject(project, {
        files: [file]
      })

      expect(updated.files).toHaveLength(1)
      expect(updated.files[0]).toBe(file)
    })

    it('should update tags', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        tags: ['new-tag']
      })

      expect(updated.tags).toEqual(['new-tag'])
    })

    it('should update dependencies', () => {
      const project = createTestProject()
      const updated = updateProject(project, {
        dependencies: [
          { id: 'dep-1', name: 'Library 1' },
          { id: 'dep-2', name: 'Library 2' }
        ]
      })

      expect(updated.dependencies).toEqual([
        { id: 'dep-1', name: 'Library 1' },
        { id: 'dep-2', name: 'Library 2' }
      ])
    })

    it('should freeze the updated project', () => {
      const project = createTestProject()
      const updated = updateProject(project, { isLibrary: true })
      expect(Object.isFrozen(updated)).toBe(true)
    })
  })

  describe('addFile', () => {
    it('should add a file to project', () => {
      const project = createTestProject()
      const file = createTestFile()
      const updated = addFile(project, file)

      expect(updated.files).toHaveLength(1)
      expect(updated.files[0]).toBe(file)
    })

    it('should preserve existing files', () => {
      const file1 = createTestFile({ id: 'file-1' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file1]
      })
      const file2 = createTestFile({ id: 'file-2' })
      const updated = addFile(project, file2)

      expect(updated.files).toHaveLength(2)
    })

    it('should update updatedAt', () => {
      const project = createTestProject()
      const file = createTestFile()
      const updated = addFile(project, file)

      expect(updated.updatedAt.getTime()).toBeGreaterThanOrEqual(
        project.updatedAt.getTime()
      )
    })
  })

  describe('removeFile', () => {
    it('should remove a file from project', () => {
      const file = createTestFile({ id: 'file-to-remove' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })
      const updated = removeFile(project, 'file-to-remove')

      expect(updated.files).toHaveLength(0)
    })

    it('should preserve other files', () => {
      const file1 = createTestFile({ id: 'file-1' })
      const file2 = createTestFile({ id: 'file-2' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file1, file2]
      })
      const updated = removeFile(project, 'file-1')

      expect(updated.files).toHaveLength(1)
      expect(updated.files[0].id).toBe('file-2')
    })

    it('should handle non-existent file gracefully', () => {
      const project = createTestProject()
      const updated = removeFile(project, 'non-existent')

      expect(updated.files).toHaveLength(0)
    })
  })

  describe('updateFile', () => {
    it('should update file name', () => {
      const file = createTestFile({ id: 'file-1' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })
      const updated = updateFile(project, 'file-1', {
        name: createFileName('renamed.asm')
      })

      expect(updated.files[0].name.value).toBe('renamed.asm')
    })

    it('should update file content', () => {
      const file = createTestFile({ id: 'file-1' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })
      const updated = updateFile(project, 'file-1', {
        content: createFileContent('; new content')
      })

      expect(updated.files[0].content.value).toBe('; new content')
    })

    it('should update file isMain', () => {
      const file = createTestFile({ id: 'file-1', isMain: false })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })
      const updated = updateFile(project, 'file-1', { isMain: true })

      expect(updated.files[0].isMain).toBe(true)
    })

    it('should update file order', () => {
      const file = createTestFile({ id: 'file-1' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })
      const updated = updateFile(project, 'file-1', { order: 5 })

      expect(updated.files[0].order).toBe(5)
    })

    it('should not modify other files', () => {
      const file1 = createTestFile({ id: 'file-1' })
      const file2 = createTestFile({ id: 'file-2' })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file1, file2]
      })
      const updated = updateFile(project, 'file-1', { isMain: true })

      expect(updated.files[1].id).toBe('file-2')
      expect(updated.files[1].isMain).toBe(false)
    })
  })

  describe('getMainFile', () => {
    it('should return main file when exists', () => {
      const mainFile = createTestFile({ id: 'main', isMain: true })
      const otherFile = createTestFile({ id: 'other', isMain: false })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [otherFile, mainFile]
      })

      expect(getMainFile(project)).toBe(mainFile)
    })

    it('should return undefined when no main file', () => {
      const file = createTestFile({ isMain: false })
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        files: [file]
      })

      expect(getMainFile(project)).toBeUndefined()
    })

    it('should return undefined for empty files', () => {
      const project = createTestProject()
      expect(getMainFile(project)).toBeUndefined()
    })
  })

  describe('addTag', () => {
    it('should add a new tag', () => {
      const project = createTestProject()
      const updated = addTag(project, 'new-tag')

      expect(updated.tags).toContain('new-tag')
    })

    it('should not add duplicate tag', () => {
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        tags: ['existing-tag']
      })
      const updated = addTag(project, 'existing-tag')

      expect(updated.tags).toEqual(['existing-tag'])
      expect(updated).toBe(project) // Same reference, no change
    })

    it('should preserve existing tags', () => {
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        tags: ['tag1']
      })
      const updated = addTag(project, 'tag2')

      expect(updated.tags).toEqual(['tag1', 'tag2'])
    })
  })

  describe('removeTag', () => {
    it('should remove existing tag', () => {
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        tags: ['tag1', 'tag2']
      })
      const updated = removeTag(project, 'tag1')

      expect(updated.tags).toEqual(['tag2'])
    })

    it('should handle non-existent tag gracefully', () => {
      const project = createProject({
        userId: 'user-123',
        name: createProjectName('Test'),
        visibility: createVisibility('private'),
        tags: ['tag1']
      })
      const updated = removeTag(project, 'non-existent')

      expect(updated.tags).toEqual(['tag1'])
    })
  })
})
