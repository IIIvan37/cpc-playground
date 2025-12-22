import type { Program } from '@/domain/entities/program.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
import { PROGRAM_ERRORS } from '@/domain/errors/error-messages'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'

type LoadProgramInput = {
  id: string
}

type LoadProgramOutput = {
  program: Program
}

export function createLoadProgramUseCase(
  programsRepository: IProgramsRepository
) {
  return {
    async execute(input: LoadProgramInput): Promise<LoadProgramOutput> {
      const program = await programsRepository.findById(input.id)

      if (!program) {
        throw new NotFoundError(PROGRAM_ERRORS.NOT_FOUND)
      }

      return { program }
    }
  }
}
