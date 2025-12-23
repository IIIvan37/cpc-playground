/**
 * Assembler Registry
 * Manages available assemblers and provides selection
 */

import type {
  AssemblerConfig,
  AssemblerRegistry,
  AssemblerType,
  IAssembler
} from '@/domain/services/assembler.interface'
import { createRasmAssembler } from './rasm-assembler'

/**
 * Create the assembler registry with all available assemblers
 */
export function createAssemblerRegistry(): AssemblerRegistry {
  const assemblers = new Map<AssemblerType, IAssembler>()

  // Register default assemblers
  const rasm = createRasmAssembler()
  assemblers.set('rasm', rasm)

  // Future assemblers can be registered here:
  // assemblers.set('pasmo', createPasmoAssembler())
  // assemblers.set('sjasm', createSjasmAssembler())
  // assemblers.set('vasm', createVasmAssembler())

  return {
    getAll(): AssemblerConfig[] {
      return Array.from(assemblers.values()).map((a) => a.config)
    },

    get(type: AssemblerType): IAssembler | undefined {
      return assemblers.get(type)
    },

    getDefault(): IAssembler {
      return assemblers.get('rasm')!
    },

    register(assembler: IAssembler): void {
      assemblers.set(assembler.config.type, assembler)
    }
  }
}

// Singleton registry instance
let registryInstance: AssemblerRegistry | null = null

export function getAssemblerRegistry(): AssemblerRegistry {
  registryInstance ??= createAssemblerRegistry()
  return registryInstance
}
