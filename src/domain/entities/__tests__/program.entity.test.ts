import { describe, expect, it } from 'vitest'
import { createProgramName } from '../../value-objects/program-name.vo'
import { createProgram, updateProgram } from '../program.entity'

describe('Program Entity', () => {
  const validName = createProgramName('Test Program')

  describe('createProgram', () => {
    it('should create a program with required fields', () => {
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'ORG #4000\nRET'
      })

      expect(program.id).toBe('prog-123')
      expect(program.name).toBe(validName)
      expect(program.code).toBe('ORG #4000\nRET')
    })

    it('should set createdAt to current date when not provided', () => {
      const before = new Date()
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET'
      })
      const after = new Date()

      expect(program.createdAt.getTime()).toBeGreaterThanOrEqual(
        before.getTime()
      )
      expect(program.createdAt.getTime()).toBeLessThanOrEqual(after.getTime())
    })

    it('should set updatedAt to current date when not provided', () => {
      const before = new Date()
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET'
      })
      const after = new Date()

      expect(program.updatedAt.getTime()).toBeGreaterThanOrEqual(
        before.getTime()
      )
      expect(program.updatedAt.getTime()).toBeLessThanOrEqual(after.getTime())
    })

    it('should use provided createdAt', () => {
      const customDate = new Date('2024-01-15T10:00:00Z')
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET',
        createdAt: customDate
      })

      expect(program.createdAt).toBe(customDate)
    })

    it('should use provided updatedAt', () => {
      const customDate = new Date('2024-01-15T10:00:00Z')
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET',
        updatedAt: customDate
      })

      expect(program.updatedAt).toBe(customDate)
    })

    it('should preserve empty code', () => {
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: ''
      })

      expect(program.code).toBe('')
    })

    it('should preserve code with special characters', () => {
      const specialCode = `; Comment with émojis 🎮
ORG #4000
  LD A, "Hello"
  RET`
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: specialCode
      })

      expect(program.code).toBe(specialCode)
    })
  })

  describe('updateProgram', () => {
    const originalDate = new Date('2024-01-01T00:00:00Z')
    const baseProgram = createProgram({
      id: 'prog-123',
      name: validName,
      code: 'Original code',
      createdAt: originalDate,
      updatedAt: originalDate
    })

    it('should update name while preserving other fields', () => {
      const newName = createProgramName('New Name')
      const updated = updateProgram(baseProgram, { name: newName })

      expect(updated.name).toBe(newName)
      expect(updated.id).toBe(baseProgram.id)
      expect(updated.code).toBe(baseProgram.code)
      expect(updated.createdAt).toBe(baseProgram.createdAt)
    })

    it('should update code while preserving other fields', () => {
      const newCode = 'New code'
      const updated = updateProgram(baseProgram, { code: newCode })

      expect(updated.code).toBe(newCode)
      expect(updated.id).toBe(baseProgram.id)
      expect(updated.name).toBe(baseProgram.name)
      expect(updated.createdAt).toBe(baseProgram.createdAt)
    })

    it('should update both name and code', () => {
      const newName = createProgramName('Updated Name')
      const newCode = 'Updated code'
      const updated = updateProgram(baseProgram, {
        name: newName,
        code: newCode
      })

      expect(updated.name).toBe(newName)
      expect(updated.code).toBe(newCode)
    })

    it('should always update updatedAt to current date', () => {
      const before = new Date()
      const updated = updateProgram(baseProgram, { code: 'New code' })
      const after = new Date()

      expect(updated.updatedAt.getTime()).toBeGreaterThanOrEqual(
        before.getTime()
      )
      expect(updated.updatedAt.getTime()).toBeLessThanOrEqual(after.getTime())
      expect(updated.updatedAt.getTime()).toBeGreaterThan(
        baseProgram.updatedAt.getTime()
      )
    })

    it('should preserve createdAt when updating', () => {
      const updated = updateProgram(baseProgram, { code: 'New code' })

      expect(updated.createdAt).toBe(baseProgram.createdAt)
    })

    it('should return unchanged program when no updates provided', () => {
      const updated = updateProgram(baseProgram, {})

      expect(updated.id).toBe(baseProgram.id)
      expect(updated.name).toBe(baseProgram.name)
      expect(updated.code).toBe(baseProgram.code)
      expect(updated.createdAt).toBe(baseProgram.createdAt)
      // Only updatedAt changes
      expect(updated.updatedAt.getTime()).toBeGreaterThan(
        baseProgram.updatedAt.getTime()
      )
    })

    it('should not mutate original program', () => {
      const originalId = baseProgram.id
      const originalName = baseProgram.name
      const originalCode = baseProgram.code
      const originalCreatedAt = baseProgram.createdAt
      const originalUpdatedAt = baseProgram.updatedAt

      updateProgram(baseProgram, {
        name: createProgramName('Changed'),
        code: 'Changed'
      })

      expect(baseProgram.id).toBe(originalId)
      expect(baseProgram.name).toBe(originalName)
      expect(baseProgram.code).toBe(originalCode)
      expect(baseProgram.createdAt).toBe(originalCreatedAt)
      expect(baseProgram.updatedAt).toBe(originalUpdatedAt)
    })
  })

  describe('immutability (Object.freeze)', () => {
    it('should freeze created program objects', () => {
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET'
      })

      expect(Object.isFrozen(program)).toBe(true)
    })

    it('should freeze updated program objects', () => {
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET'
      })

      const updated = updateProgram(program, { code: 'New code' })

      expect(Object.isFrozen(updated)).toBe(true)
    })

    it('should throw when attempting to modify frozen program', () => {
      const program = createProgram({
        id: 'prog-123',
        name: validName,
        code: 'RET'
      })

      expect(() => {
        // @ts-expect-error - Testing runtime immutability
        program.id = 'changed'
      }).toThrow()
    })
  })
})
