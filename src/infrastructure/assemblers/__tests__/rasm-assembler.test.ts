import { describe, expect, it } from 'vitest'
import { createRasmAssembler, rasmConfig } from '../rasm-assembler'

describe('RASM Assembler', () => {
  describe('rasmConfig', () => {
    it('should have correct type', () => {
      expect(rasmConfig.type).toBe('rasm')
    })

    it('should have correct name', () => {
      expect(rasmConfig.name).toBe('RASM')
    })

    it('should support sna and dsk formats', () => {
      expect(rasmConfig.supportedFormats).toContain('sna')
      expect(rasmConfig.supportedFormats).toContain('dsk')
    })

    it('should default to sna format', () => {
      expect(rasmConfig.defaultFormat).toBe('sna')
    })

    it('should support CPC Plus', () => {
      expect(rasmConfig.supportsCpcPlus).toBe(true)
    })

    it('should have error parser', () => {
      expect(rasmConfig.errorParser).toBeDefined()
      expect(rasmConfig.errorParser.extractLineNumber).toBeInstanceOf(Function)
    })
  })

  describe('createRasmAssembler', () => {
    const assembler = createRasmAssembler()

    it('should return assembler with config', () => {
      expect(assembler.config).toBe(rasmConfig)
    })

    describe('prepareSource for SNA', () => {
      it('should add BUILDSNA and BANKSET if not present', () => {
        const source = 'org #4000\nret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'sna'
        })

        expect(result).toContain('BUILDSNA')
        expect(result).toContain('BANKSET 0')
        expect(result).toContain('org #4000')
      })

      it('should not duplicate BUILDSNA if already present', () => {
        const source = 'BUILDSNA\norg #4000\nret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'sna'
        })

        const matches = result.match(/BUILDSNA/gi)
        expect(matches).toHaveLength(1)
      })

      it('should not duplicate BANKSET if already present', () => {
        const source = 'BANKSET 1\norg #4000\nret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'sna'
        })

        const matches = result.match(/BANKSET/gi)
        expect(matches).toHaveLength(1)
      })
    })

    describe('prepareSource for DSK', () => {
      it('should add SAVE directive with default address', () => {
        const source = 'ret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'dsk'
        })

        expect(result).toContain('__cpc_playground_start equ #4000')
        expect(result).toContain('__cpc_playground_end:')
        expect(result).toContain("SAVE 'PROGRAM.BIN'")
        expect(result).toContain('/output.dsk')
      })

      it('should extract ORG address from source', () => {
        const source = 'org #8000\nret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'dsk'
        })

        expect(result).toContain('__cpc_playground_start equ #8000')
      })

      it('should use provided entry point', () => {
        const source = 'org #4000\nret'
        const result = assembler.prepareSource({
          source,
          outputFormat: 'dsk',
          entryPoint: 0x6000
        })

        expect(result).toContain('__cpc_playground_start equ #6000')
      })
    })

    describe('getCompileArgs', () => {
      it('should return correct arguments', () => {
        const args = assembler.getCompileArgs('/input.asm', '/output')
        expect(args).toEqual(['/input.asm', '-o', '/output'])
      })
    })

    describe('getOutputFilePath', () => {
      it('should return .sna path for sna format', () => {
        expect(assembler.getOutputFilePath('sna')).toBe('/output.sna')
      })

      it('should return .dsk path for dsk format', () => {
        expect(assembler.getOutputFilePath('dsk')).toBe('/output.dsk')
      })
    })

    describe('getAlternateOutputPaths', () => {
      it('should return alternate paths for sna', () => {
        const paths = assembler.getAlternateOutputPaths('sna')
        expect(paths).toContain('output.sna')
      })

      it('should return alternate paths for dsk', () => {
        const paths = assembler.getAlternateOutputPaths('dsk')
        expect(paths).toContain('program.dsk')
        expect(paths).toContain('output.dsk')
      })
    })
  })
})
