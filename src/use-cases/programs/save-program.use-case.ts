import { createProgram, type Program } from '@/domain/entities/program.entity'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'
import { createProgramName } from '@/domain/value-objects/program-name.vo'

type SaveProgramInput = {
  id?: string
  name: string
  code: string
}

type SaveProgramOutput = {
  program: Program
}

export function createSaveProgramUseCase(
  programsRepository: IProgramsRepository
) {
  return {
    async execute(input: SaveProgramInput): Promise<SaveProgramOutput> {
      const programName = createProgramName(input.name)
      const now = new Date()

      let program: Program

      if (input.id) {
        // Update existing program
        const existing = await programsRepository.findById(input.id)

        if (existing) {
          program = createProgram({
            id: existing.id,
            name: programName,
            code: input.code,
            createdAt: existing.createdAt,
            updatedAt: now
          })
        } else {
          // ID provided but not found - create new with this ID
          program = createProgram({
            id: input.id,
            name: programName,
            code: input.code,
            createdAt: now,
            updatedAt: now
          })
        }
      } else {
        // Create new program
        program = createProgram({
          id: crypto.randomUUID(),
          name: programName,
          code: input.code,
          createdAt: now,
          updatedAt: now
        })
      }

      await programsRepository.save(program)

      return { program }
    }
  }
}
