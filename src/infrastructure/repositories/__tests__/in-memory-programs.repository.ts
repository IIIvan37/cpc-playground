import type { Program } from '@/domain/entities/program.entity'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'

/**
 * In-memory implementation of IProgramsRepository for testing purposes.
 */
export function createInMemoryProgramsRepository(): IProgramsRepository & {
  _clear: () => void
  _getAll: () => Program[]
} {
  const programs = new Map<string, Program>()

  return {
    async findAll(): Promise<readonly Program[]> {
      return Array.from(programs.values())
    },

    async findById(id: string): Promise<Program | null> {
      return programs.get(id) ?? null
    },

    async save(program: Program): Promise<Program> {
      programs.set(program.id, program)
      return program
    },

    async delete(id: string): Promise<void> {
      programs.delete(id)
    },

    // Test helpers
    _clear(): void {
      programs.clear()
    },

    _getAll(): Program[] {
      return Array.from(programs.values())
    }
  }
}
