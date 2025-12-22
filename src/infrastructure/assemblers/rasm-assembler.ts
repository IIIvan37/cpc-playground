/**
 * RASM Assembler Implementation
 * https://github.com/EdouardBERGE/rasm
 */

import type {
  AssemblerConfig,
  IAssembler,
  OutputFormat,
  SourcePreparationOptions
} from '@/domain/services/assembler.interface'
import { createRasmErrorParser } from './rasm-error-parser'

const CDN_BASE = import.meta.env.VITE_CDN_BASE ?? '/cdn'

/**
 * RASM adds offset lines for directives we prepend:
 * - SNA: BUILDSNA + BANKSET = 2 lines
 * - DSK: blank line + __cpc_playground_start equ = 2 lines
 */
const RASM_LINE_OFFSET = 2

export const rasmConfig: AssemblerConfig = {
  type: 'rasm',
  name: 'RASM',
  description:
    'Powerful Z80 assembler by Roudoudou with advanced macro support',
  supportedFormats: ['sna', 'dsk'],
  defaultFormat: 'sna',
  wasmUrl: `${CDN_BASE}/rasm.wasm`,
  jsUrl: `${CDN_BASE}/rasm.js`,
  errorParser: createRasmErrorParser({ lineOffset: RASM_LINE_OFFSET }),
  supportsCpcPlus: true,
  docsUrl: 'https://github.com/EdouardBERGE/rasm'
}

/**
 * Prepare source for DSK output
 */
function prepareDskSource(source: string, entryPoint?: number): string {
  // Extract ORG address from source if not provided
  let orgAddress = entryPoint ? `#${entryPoint.toString(16)}` : '#4000'

  if (!entryPoint) {
    const orgPattern = /org\s+[&$#]?([\da-f]+)/i
    const orgMatch = orgPattern.exec(source)
    if (orgMatch) {
      orgAddress = `#${orgMatch[1]}`
    }
  }

  return `
__cpc_playground_start equ ${orgAddress}
${source}
__cpc_playground_end:
SAVE 'PROGRAM.BIN',__cpc_playground_start,__cpc_playground_end-__cpc_playground_start,DSK,'/output.dsk'
`
}

/**
 * Prepare source for SNA output
 */
function prepareSnaSource(source: string): string {
  const hasBuildsna = /^\s*BUILDSNA\b/im.test(source)
  const hasBankset = /^\s*BANKSET\b/im.test(source)

  let result = source
  if (!hasBankset) {
    result = `BANKSET 0\n${result}`
  }
  if (!hasBuildsna) {
    result = `BUILDSNA\n${result}`
  }
  return result
}

/**
 * Create RASM assembler instance
 */
export function createRasmAssembler(): IAssembler {
  return {
    config: rasmConfig,

    prepareSource(options: SourcePreparationOptions): string {
      const { source, outputFormat, entryPoint } = options

      switch (outputFormat) {
        case 'sna':
          return prepareSnaSource(source)
        case 'dsk':
          return prepareDskSource(source, entryPoint)
        default:
          return source
      }
    },

    getCompileArgs(sourceFile: string, _outputFile: string): string[] {
      return [sourceFile, '-o', '/output']
    },

    getOutputFilePath(format: OutputFormat): string {
      return format === 'dsk' ? '/output.dsk' : '/output.sna'
    },

    getAlternateOutputPaths(format: OutputFormat): string[] {
      return format === 'dsk'
        ? ['program.dsk', '/program.dsk', 'output.dsk']
        : ['output.sna', '/output.sna']
    }
  }
}
