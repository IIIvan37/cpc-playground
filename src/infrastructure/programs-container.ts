/**
 * Programs Container
 * Dependency injection for local programs (localStorage)
 */

import {
  createDeleteProgramUseCase,
  createGetProgramsUseCase,
  createLoadProgramUseCase,
  createSaveProgramUseCase
} from '@/use-cases/programs'
import { createLocalStorageProgramsRepository } from './repositories/local-storage-programs.repository'

export type ProgramsContainer = {
  saveProgram: ReturnType<typeof createSaveProgramUseCase>
  loadProgram: ReturnType<typeof createLoadProgramUseCase>
  deleteProgram: ReturnType<typeof createDeleteProgramUseCase>
  getPrograms: ReturnType<typeof createGetProgramsUseCase>
}

export function createProgramsContainer(): ProgramsContainer {
  const programsRepository = createLocalStorageProgramsRepository()

  return {
    saveProgram: createSaveProgramUseCase(programsRepository),
    loadProgram: createLoadProgramUseCase(programsRepository),
    deleteProgram: createDeleteProgramUseCase(programsRepository),
    getPrograms: createGetProgramsUseCase(programsRepository)
  }
}

export const programsContainer = createProgramsContainer()
