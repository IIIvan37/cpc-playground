import { createStore } from 'jotai'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProgram } from '@/domain/entities/program.entity'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'
import { createProgramName } from '@/domain/value-objects/program-name.vo'
import { createInMemoryProgramsRepository } from '@/infrastructure/repositories/__tests__/in-memory-programs.repository'
import {
  createDeleteProgramUseCase,
  createGetProgramsUseCase,
  createLoadProgramUseCase,
  createSaveProgramUseCase
} from '@/use-cases/programs'

// Test repository instance - initialized before each test
let testRepository: IProgramsRepository & {
  _clear: () => void
  _getAll: () => any[]
}

function createTestContainer() {
  return {
    saveProgram: createSaveProgramUseCase(testRepository),
    loadProgram: createLoadProgramUseCase(testRepository),
    deleteProgram: createDeleteProgramUseCase(testRepository),
    getPrograms: createGetProgramsUseCase(testRepository)
  }
}

// Mock the programsContainer to use our test container
vi.mock('@/infrastructure/programs-container', () => ({
  get programsContainer() {
    return createTestContainer()
  }
}))

// Import after mock setup
import {
  currentProgramAtom,
  currentProgramIdAtom,
  deleteProgramAtom,
  fetchProgramsAtom,
  legacySavedProgramsAtom,
  loadProgramAtom,
  newProgramAtom,
  savedProgramsAtom,
  saveProgramAtom,
  toLegacySavedProgram
} from '../programs'

describe('Programs Store', () => {
  let store: ReturnType<typeof createStore>

  const mockProgram1 = createProgram({
    id: 'prog-1',
    name: createProgramName('Test Program 1'),
    code: '; Program 1\nret',
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-02')
  })

  const mockProgram2 = createProgram({
    id: 'prog-2',
    name: createProgramName('Test Program 2'),
    code: '; Program 2\nret',
    createdAt: new Date('2024-01-03'),
    updatedAt: new Date('2024-01-04')
  })

  beforeEach(() => {
    store = createStore()
    testRepository = createInMemoryProgramsRepository()
  })

  describe('State Atoms', () => {
    describe('savedProgramsAtom', () => {
      it('should default to empty array', () => {
        expect(store.get(savedProgramsAtom)).toEqual([])
      })

      it('should allow setting programs', () => {
        store.set(savedProgramsAtom, [mockProgram1, mockProgram2])
        expect(store.get(savedProgramsAtom)).toEqual([
          mockProgram1,
          mockProgram2
        ])
      })
    })

    describe('currentProgramIdAtom', () => {
      it('should default to null', () => {
        expect(store.get(currentProgramIdAtom)).toBeNull()
      })

      it('should allow setting program ID', () => {
        store.set(currentProgramIdAtom, 'prog-1')
        expect(store.get(currentProgramIdAtom)).toBe('prog-1')
      })
    })
  })

  describe('Derived Atoms', () => {
    describe('currentProgramAtom', () => {
      it('should return null when no programs', () => {
        expect(store.get(currentProgramAtom)).toBeNull()
      })

      it('should return null when no current ID', () => {
        store.set(savedProgramsAtom, [mockProgram1])
        expect(store.get(currentProgramAtom)).toBeNull()
      })

      it('should return the current program', () => {
        store.set(savedProgramsAtom, [mockProgram1, mockProgram2])
        store.set(currentProgramIdAtom, 'prog-2')
        expect(store.get(currentProgramAtom)).toBe(mockProgram2)
      })

      it('should return null for non-existent ID', () => {
        store.set(savedProgramsAtom, [mockProgram1])
        store.set(currentProgramIdAtom, 'non-existent')
        expect(store.get(currentProgramAtom)).toBeNull()
      })
    })

    describe('legacySavedProgramsAtom', () => {
      it('should convert programs to legacy format', () => {
        store.set(savedProgramsAtom, [mockProgram1])
        const legacy = store.get(legacySavedProgramsAtom)

        expect(legacy).toHaveLength(1)
        expect(legacy[0]).toEqual({
          id: 'prog-1',
          name: 'Test Program 1',
          code: '; Program 1\nret',
          createdAt: '2024-01-01T00:00:00.000Z',
          updatedAt: '2024-01-02T00:00:00.000Z'
        })
      })
    })
  })

  describe('Action Atoms', () => {
    describe('fetchProgramsAtom', () => {
      it('should load programs from repository', async () => {
        // Setup: add programs to repository
        await testRepository.save(mockProgram1)
        await testRepository.save(mockProgram2)

        await store.set(fetchProgramsAtom)

        expect(store.get(savedProgramsAtom)).toHaveLength(2)
      })

      it('should handle empty programs list', async () => {
        await store.set(fetchProgramsAtom)

        expect(store.get(savedProgramsAtom)).toEqual([])
      })
    })

    describe('saveProgramAtom', () => {
      it('should create new program when no current ID', async () => {
        const result = await store.set(saveProgramAtom, {
          name: 'New Program',
          code: '; New code'
        })

        expect(result).toBeDefined()
        expect(result.name.value).toBe('New Program')
        expect(result.code).toBe('; New code')
        expect(store.get(savedProgramsAtom)).toHaveLength(1)
        expect(store.get(currentProgramIdAtom)).toBe(result.id)

        // Verify it's in the repository
        const savedInRepo = await testRepository.findById(result.id)
        expect(savedInRepo).not.toBeNull()
      })

      it('should update existing program', async () => {
        // Create initial program
        const created = await store.set(saveProgramAtom, {
          name: 'Initial Name',
          code: '; Initial code'
        })

        // Update it
        const updated = await store.set(saveProgramAtom, {
          name: 'Updated Name',
          code: '; Updated code'
        })

        expect(updated.id).toBe(created.id)
        expect(updated.name.value).toBe('Updated Name')
        expect(updated.code).toBe('; Updated code')
        expect(store.get(savedProgramsAtom)).toHaveLength(1)

        // Verify update in repository
        const savedInRepo = await testRepository.findById(updated.id)
        expect(savedInRepo?.code).toBe('; Updated code')
      })

      it('should throw on invalid name', async () => {
        await expect(
          store.set(saveProgramAtom, { name: '', code: '; code' })
        ).rejects.toThrow()
      })
    })

    describe('loadProgramAtom', () => {
      it('should load program and set current ID', async () => {
        // Setup: save program to repository first
        await testRepository.save(mockProgram1)

        const result = await store.set(loadProgramAtom, 'prog-1')

        expect(result).toEqual(mockProgram1)
        expect(store.get(currentProgramIdAtom)).toBe('prog-1')
      })

      it('should throw on non-existent program', async () => {
        await expect(
          store.set(loadProgramAtom, 'non-existent')
        ).rejects.toThrow()
      })
    })

    describe('deleteProgramAtom', () => {
      it('should delete program and remove from state', async () => {
        // Setup: create programs
        await testRepository.save(mockProgram1)
        await testRepository.save(mockProgram2)
        await store.set(fetchProgramsAtom)
        expect(store.get(savedProgramsAtom)).toHaveLength(2)

        await store.set(deleteProgramAtom, 'prog-1')

        expect(store.get(savedProgramsAtom)).toHaveLength(1)
        expect(store.get(savedProgramsAtom)[0].id).toBe('prog-2')

        // Verify deletion in repository
        const deleted = await testRepository.findById('prog-1')
        expect(deleted).toBeNull()
      })

      it('should clear current ID if deleted program was current', async () => {
        await testRepository.save(mockProgram1)
        await store.set(fetchProgramsAtom)
        store.set(currentProgramIdAtom, 'prog-1')

        await store.set(deleteProgramAtom, 'prog-1')

        expect(store.get(currentProgramIdAtom)).toBeNull()
      })

      it('should keep current ID if deleted program was not current', async () => {
        await testRepository.save(mockProgram1)
        await testRepository.save(mockProgram2)
        await store.set(fetchProgramsAtom)
        store.set(currentProgramIdAtom, 'prog-2')

        await store.set(deleteProgramAtom, 'prog-1')

        expect(store.get(currentProgramIdAtom)).toBe('prog-2')
      })
    })

    describe('newProgramAtom', () => {
      it('should clear current program ID', () => {
        store.set(currentProgramIdAtom, 'prog-1')

        store.set(newProgramAtom)

        expect(store.get(currentProgramIdAtom)).toBeNull()
      })
    })
  })

  describe('toLegacySavedProgram', () => {
    it('should convert program entity to legacy format', () => {
      const legacy = toLegacySavedProgram(mockProgram1)

      expect(legacy).toEqual({
        id: 'prog-1',
        name: 'Test Program 1',
        code: '; Program 1\nret',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-02T00:00:00.000Z'
      })
    })
  })
})
