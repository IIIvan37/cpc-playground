import { beforeEach, describe, expect, it } from 'vitest'
import { NotFoundError } from '@/domain/errors/domain.error'
import {
  PROGRAM_ERRORS,
  PROGRAM_NAME_ERRORS
} from '@/domain/errors/error-messages'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'
import { createInMemoryProgramsRepository } from '@/infrastructure/repositories/__tests__/in-memory-programs.repository'
import { createDeleteProgramUseCase } from '../delete-program.use-case'
import { createGetProgramsUseCase } from '../get-programs.use-case'
import { createLoadProgramUseCase } from '../load-program.use-case'
import { createSaveProgramUseCase } from '../save-program.use-case'

describe('Programs Use Cases', () => {
  let repository: IProgramsRepository & {
    _clear: () => void
    _getAll: () => any[]
  }

  beforeEach(() => {
    repository = createInMemoryProgramsRepository()
    repository._clear()
  })

  describe('SaveProgramUseCase', () => {
    it('should create a new program', async () => {
      const useCase = createSaveProgramUseCase(repository)

      const result = await useCase.execute({
        name: 'My Program',
        code: 'LD A, 10'
      })

      expect(result.program.name.value).toBe('My Program')
      expect(result.program.code).toBe('LD A, 10')
      expect(result.program.id).toBeDefined()
      expect(result.program.createdAt).toBeInstanceOf(Date)
      expect(result.program.updatedAt).toBeInstanceOf(Date)
    })

    it('should update an existing program', async () => {
      const useCase = createSaveProgramUseCase(repository)

      // Create program
      const { program: created } = await useCase.execute({
        name: 'Original',
        code: 'LD A, 1'
      })

      // Wait a bit to ensure different timestamps
      await new Promise((resolve) => setTimeout(resolve, 10))

      // Update program
      const { program: updated } = await useCase.execute({
        id: created.id,
        name: 'Updated',
        code: 'LD A, 2'
      })

      expect(updated.id).toBe(created.id)
      expect(updated.name.value).toBe('Updated')
      expect(updated.code).toBe('LD A, 2')
      expect(updated.createdAt).toEqual(created.createdAt)
      expect(updated.updatedAt.getTime()).toBeGreaterThan(
        created.updatedAt.getTime()
      )
    })

    it('should throw ValidationError for empty name', async () => {
      const useCase = createSaveProgramUseCase(repository)

      await expect(
        useCase.execute({
          name: '',
          code: 'LD A, 10'
        })
      ).rejects.toThrow(PROGRAM_NAME_ERRORS.EMPTY)
    })

    it('should throw ValidationError for name too long', async () => {
      const useCase = createSaveProgramUseCase(repository)
      const longName = 'a'.repeat(101)

      await expect(
        useCase.execute({
          name: longName,
          code: 'LD A, 10'
        })
      ).rejects.toThrow(PROGRAM_NAME_ERRORS.TOO_LONG(100))
    })

    it('should create new program if ID provided but not found', async () => {
      const useCase = createSaveProgramUseCase(repository)

      const result = await useCase.execute({
        id: 'non-existent-id',
        name: 'New Program',
        code: 'LD A, 10'
      })

      expect(result.program.id).toBe('non-existent-id')
      expect(result.program.name.value).toBe('New Program')
    })
  })

  describe('LoadProgramUseCase', () => {
    it('should load an existing program', async () => {
      const saveUseCase = createSaveProgramUseCase(repository)
      const loadUseCase = createLoadProgramUseCase(repository)

      const { program: saved } = await saveUseCase.execute({
        name: 'Test Program',
        code: 'LD A, 42'
      })

      const { program: loaded } = await loadUseCase.execute({ id: saved.id })

      expect(loaded.id).toBe(saved.id)
      expect(loaded.name.value).toBe('Test Program')
      expect(loaded.code).toBe('LD A, 42')
    })

    it('should throw NotFoundError for non-existent program', async () => {
      const useCase = createLoadProgramUseCase(repository)

      await expect(useCase.execute({ id: 'non-existent' })).rejects.toThrow(
        NotFoundError
      )

      await expect(useCase.execute({ id: 'non-existent' })).rejects.toThrow(
        PROGRAM_ERRORS.NOT_FOUND
      )
    })
  })

  describe('DeleteProgramUseCase', () => {
    it('should delete an existing program', async () => {
      const saveUseCase = createSaveProgramUseCase(repository)
      const deleteUseCase = createDeleteProgramUseCase(repository)

      const { program } = await saveUseCase.execute({
        name: 'To Delete',
        code: 'LD A, 0'
      })

      const result = await deleteUseCase.execute({ id: program.id })

      expect(result.success).toBe(true)

      // Verify program is deleted
      const programs = repository._getAll()
      expect(programs).toHaveLength(0)
    })

    it('should succeed even if program does not exist (idempotent)', async () => {
      const useCase = createDeleteProgramUseCase(repository)

      const result = await useCase.execute({ id: 'non-existent' })

      expect(result.success).toBe(true)
    })
  })

  describe('GetProgramsUseCase', () => {
    it('should return empty array when no programs exist', async () => {
      const useCase = createGetProgramsUseCase(repository)

      const { programs } = await useCase.execute()

      expect(programs).toHaveLength(0)
    })

    it('should return all programs', async () => {
      const saveUseCase = createSaveProgramUseCase(repository)
      const getUseCase = createGetProgramsUseCase(repository)

      await saveUseCase.execute({ name: 'Program 1', code: 'LD A, 1' })
      await saveUseCase.execute({ name: 'Program 2', code: 'LD A, 2' })
      await saveUseCase.execute({ name: 'Program 3', code: 'LD A, 3' })

      const { programs } = await getUseCase.execute()

      expect(programs).toHaveLength(3)
      expect(programs.map((p) => p.name.value)).toContain('Program 1')
      expect(programs.map((p) => p.name.value)).toContain('Program 2')
      expect(programs.map((p) => p.name.value)).toContain('Program 3')
    })
  })

  describe('Integration scenarios', () => {
    it('should support full CRUD workflow', async () => {
      const saveUseCase = createSaveProgramUseCase(repository)
      const loadUseCase = createLoadProgramUseCase(repository)
      const deleteUseCase = createDeleteProgramUseCase(repository)
      const getUseCase = createGetProgramsUseCase(repository)

      // Create
      const { program: created } = await saveUseCase.execute({
        name: 'My Program',
        code: 'LD A, 10'
      })
      expect(created.name.value).toBe('My Program')

      // Read
      const { program: loaded } = await loadUseCase.execute({ id: created.id })
      expect(loaded.code).toBe('LD A, 10')

      // Update
      const { program: updated } = await saveUseCase.execute({
        id: created.id,
        name: 'Updated Program',
        code: 'LD B, 20'
      })
      expect(updated.name.value).toBe('Updated Program')
      expect(updated.code).toBe('LD B, 20')

      // List
      const { programs } = await getUseCase.execute()
      expect(programs).toHaveLength(1)

      // Delete
      await deleteUseCase.execute({ id: created.id })
      const { programs: afterDelete } = await getUseCase.execute()
      expect(afterDelete).toHaveLength(0)
    })
  })
})
