/**
 * Assembler Adapter Registry
 * Manages the available assembler adapters
 */

import type { AssemblerType } from '@/domain/services/assembler.interface'
import type {
  AssemblerAdapterFactory,
  IAssemblerAdapter
} from '@/domain/services/assembler-adapter.interface'
import { createRasmWorkerAdapter } from './rasm-worker-adapter'

/**
 * Registry of assembler adapter factories
 */
const adapterFactories = new Map<AssemblerType, AssemblerAdapterFactory>([
  ['rasm', createRasmWorkerAdapter]
])

/**
 * Cached adapter instances (singleton per type)
 */
const adapterInstances = new Map<AssemblerType, IAssemblerAdapter>()

/**
 * Get an assembler adapter by type
 * Returns a singleton instance for each assembler type
 */
export function getAssemblerAdapter(type: AssemblerType): IAssemblerAdapter {
  let adapter = adapterInstances.get(type)

  if (!adapter) {
    const factory = adapterFactories.get(type)

    if (!factory) {
      throw new Error(`No adapter registered for assembler type: ${type}`)
    }

    adapter = factory()
    adapterInstances.set(type, adapter)
  }

  return adapter
}

/**
 * Register a new assembler adapter factory
 */
export function registerAssemblerAdapter(
  type: AssemblerType,
  factory: AssemblerAdapterFactory
): void {
  adapterFactories.set(type, factory)
  // Clear cached instance if exists
  const existing = adapterInstances.get(type)
  if (existing) {
    existing.dispose()
    adapterInstances.delete(type)
  }
}

/**
 * Get all available assembler types
 */
export function getAvailableAssemblerTypes(): AssemblerType[] {
  return Array.from(adapterFactories.keys())
}

/**
 * Dispose all adapter instances
 */
export function disposeAllAdapters(): void {
  for (const adapter of adapterInstances.values()) {
    adapter.dispose()
  }
  adapterInstances.clear()
}
