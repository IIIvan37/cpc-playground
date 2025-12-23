import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'

type DeleteProgramInput = {
  id: string
}

type DeleteProgramOutput = {
  success: boolean
}

export function createDeleteProgramUseCase(
  programsRepository: IProgramsRepository
) {
  return {
    async execute(input: DeleteProgramInput): Promise<DeleteProgramOutput> {
      await programsRepository.delete(input.id)
      return { success: true }
    }
  }
}
