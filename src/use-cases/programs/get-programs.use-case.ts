import type { Program } from '@/domain/entities/program.entity'
import type { IProgramsRepository } from '@/domain/repositories/programs.repository.interface'

type GetProgramsOutput = {
  programs: readonly Program[]
}

export function createGetProgramsUseCase(
  programsRepository: IProgramsRepository
) {
  return {
    async execute(): Promise<GetProgramsOutput> {
      const programs = await programsRepository.findAll()
      return { programs }
    }
  }
}
