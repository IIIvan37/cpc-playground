import { describe, expect, it } from 'vitest'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import {
  createProjectFile,
  isMainFile,
  updateProjectFile
} from '../project-file.entity'

describe('ProjectFile Entity', () => {
  describe('createProjectFile', () => {
    it('should create a file with required fields', () => {
      const file = createProjectFile({
        projectId: 'project-123',
        name: createFileName('test.asm'),
        content: createFileContent('; test content')
      })

      expect(file.projectId).toBe('project-123')
      expect(file.name.value).toBe('test.asm')
      expect(file.content.value).toBe('; test content')
      expect(file.isMain).toBe(false)
      expect(file.order).toBe(0)
      expect(file.id).toBeDefined()
      expect(file.createdAt).toBeInstanceOf(Date)
      expect(file.updatedAt).toBeInstanceOf(Date)
    })

    it('should create a file with optional fields', () => {
      const customDate = new Date('2024-01-01')
      const file = createProjectFile({
        id: 'custom-id',
        projectId: 'project-123',
        name: createFileName('main.asm'),
        content: createFileContent('; main'),
        isMain: true,
        order: 5,
        createdAt: customDate,
        updatedAt: customDate
      })

      expect(file.id).toBe('custom-id')
      expect(file.isMain).toBe(true)
      expect(file.order).toBe(5)
      expect(file.createdAt).toBe(customDate)
      expect(file.updatedAt).toBe(customDate)
    })

    it('should freeze the file object', () => {
      const file = createProjectFile({
        projectId: 'project-123',
        name: createFileName('test.asm'),
        content: createFileContent('; test')
      })
      expect(Object.isFrozen(file)).toBe(true)
    })
  })

  describe('updateProjectFile', () => {
    const createTestFile = () =>
      createProjectFile({
        id: 'file-1',
        projectId: 'project-123',
        name: createFileName('test.asm'),
        content: createFileContent('; original'),
        isMain: false,
        order: 0
      })

    it('should update name', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, {
        name: createFileName('renamed.asm')
      })

      expect(updated.name.value).toBe('renamed.asm')
      expect(updated.content.value).toBe('; original')
    })

    it('should update content', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, {
        content: createFileContent('; new content')
      })

      expect(updated.content.value).toBe('; new content')
      expect(updated.name.value).toBe('test.asm')
    })

    it('should update isMain', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, { isMain: true })

      expect(updated.isMain).toBe(true)
    })

    it('should update order', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, { order: 10 })

      expect(updated.order).toBe(10)
    })

    it('should update multiple fields at once', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, {
        name: createFileName('new.asm'),
        content: createFileContent('; new'),
        isMain: true,
        order: 3
      })

      expect(updated.name.value).toBe('new.asm')
      expect(updated.content.value).toBe('; new')
      expect(updated.isMain).toBe(true)
      expect(updated.order).toBe(3)
    })

    it('should update updatedAt timestamp', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, { order: 1 })

      expect(updated.updatedAt.getTime()).toBeGreaterThanOrEqual(
        file.updatedAt.getTime()
      )
    })

    it('should preserve unchanged fields', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, { isMain: true })

      expect(updated.id).toBe(file.id)
      expect(updated.projectId).toBe(file.projectId)
      expect(updated.name).toBe(file.name)
      expect(updated.content).toBe(file.content)
      expect(updated.createdAt).toBe(file.createdAt)
    })

    it('should freeze the updated file', () => {
      const file = createTestFile()
      const updated = updateProjectFile(file, { isMain: true })
      expect(Object.isFrozen(updated)).toBe(true)
    })
  })

  describe('isMainFile', () => {
    it('should return true for main file', () => {
      const file = createProjectFile({
        projectId: 'project-123',
        name: createFileName('main.asm'),
        content: createFileContent('; main'),
        isMain: true
      })

      expect(isMainFile(file)).toBe(true)
    })

    it('should return false for non-main file', () => {
      const file = createProjectFile({
        projectId: 'project-123',
        name: createFileName('helper.asm'),
        content: createFileContent('; helper'),
        isMain: false
      })

      expect(isMainFile(file)).toBe(false)
    })
  })
})
