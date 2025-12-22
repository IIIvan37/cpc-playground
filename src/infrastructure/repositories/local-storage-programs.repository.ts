import { createProgram, type Program } from '@/domain/entities/program.entity'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'
import { createProgramName } from '@/domain/value-objects/program-name.vo'

const STORAGE_KEY = 'cpc-playground-programs'

type StoredProgram = {
  id: string
  name: string
  code: string
  createdAt: string
  updatedAt: string
}

function loadFromStorage(): Program[] {
  try {
    const stored = localStorage.getItem(STORAGE_KEY)
    if (!stored) return []

    const parsed: StoredProgram[] = JSON.parse(stored)
    return parsed.map((p) =>
      createProgram({
        id: p.id,
        name: createProgramName(p.name),
        code: p.code,
        createdAt: new Date(p.createdAt),
        updatedAt: new Date(p.updatedAt)
      })
    )
  } catch {
    return []
  }
}

function saveToStorage(programs: Program[]): void {
  const toStore: StoredProgram[] = programs.map((p) => ({
    id: p.id,
    name: p.name.value,
    code: p.code,
    createdAt: p.createdAt.toISOString(),
    updatedAt: p.updatedAt.toISOString()
  }))
  localStorage.setItem(STORAGE_KEY, JSON.stringify(toStore))
}

/**
 * localStorage implementation of IProgramsRepository
 */
export function createLocalStorageProgramsRepository(): IProgramsRepository {
  return {
    async findAll(): Promise<readonly Program[]> {
      return loadFromStorage()
    },

    async findById(id: string): Promise<Program | null> {
      const programs = loadFromStorage()
      return programs.find((p) => p.id === id) ?? null
    },

    async save(program: Program): Promise<Program> {
      const programs = loadFromStorage()
      const index = programs.findIndex((p) => p.id === program.id)

      if (index >= 0) {
        programs[index] = program
      } else {
        programs.push(program)
      }

      saveToStorage(programs)
      return program
    },

    async delete(id: string): Promise<void> {
      const programs = loadFromStorage()
      const filtered = programs.filter((p) => p.id !== id)
      saveToStorage(filtered)
    }
  }
}
