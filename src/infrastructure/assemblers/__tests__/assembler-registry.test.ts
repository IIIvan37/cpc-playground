import { describe, expect, it } from 'vitest'
import type { OutputFormat } from '@/domain/services'
import {
  createAssemblerRegistry,
  getAssemblerRegistry
} from '../assembler-registry'

describe('AssemblerRegistry', () => {
  describe('createAssemblerRegistry', () => {
    it('should create registry with RASM registered', () => {
      const registry = createAssemblerRegistry()
      const rasm = registry.get('rasm')

      expect(rasm).toBeDefined()
      expect(rasm?.config.type).toBe('rasm')
    })

    it('should return undefined for unknown assembler', () => {
      const registry = createAssemblerRegistry()
      const unknown = registry.get('unknown' as any)

      expect(unknown).toBeUndefined()
    })

    it('should return RASM as default', () => {
      const registry = createAssemblerRegistry()
      const defaultAssembler = registry.getDefault()

      expect(defaultAssembler.config.type).toBe('rasm')
    })

    it('should list all available assemblers', () => {
      const registry = createAssemblerRegistry()
      const all = registry.getAll()

      expect(all).toHaveLength(1)
      expect(all[0].type).toBe('rasm')
    })

    it('should allow registering new assemblers', () => {
      const registry = createAssemblerRegistry()

      // Mock assembler
      const mockAssembler = {
        config: {
          type: 'pasmo' as const,
          name: 'PASMO',
          description: 'Portable Z80 assembler',
          supportedFormats: ['bin'] as OutputFormat[],
          defaultFormat: 'bin' as const,
          wasmUrl: '/pasmo.wasm',
          jsUrl: '/pasmo.js',
          errorParser: {
            extractLineNumber: () => undefined,
            extractRawLineNumber: () => undefined,
            hasError: () => false,
            parseError: (text: string) => ({
              text,
              line: undefined,
              rawLine: undefined
            })
          },
          supportsCpcPlus: false
        },
        prepareSource: () => '',
        getCompileArgs: () => [],
        getOutputFilePath: () => '/output.bin',
        getAlternateOutputPaths: () => []
      }

      registry.register(mockAssembler)

      const all = registry.getAll()
      expect(all).toHaveLength(2)
      expect(registry.get('pasmo')).toBeDefined()
    })
  })

  describe('getAssemblerRegistry', () => {
    it('should return singleton instance', () => {
      const registry1 = getAssemblerRegistry()
      const registry2 = getAssemblerRegistry()

      expect(registry1).toBe(registry2)
    })

    it('should have RASM available', () => {
      const registry = getAssemblerRegistry()
      expect(registry.get('rasm')).toBeDefined()
    })
  })
})
