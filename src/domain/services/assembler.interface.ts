/**
 * Assembler Interface
 * Defines contract for Z80 assemblers (RASM, PASMO, SJASM, VASM, etc.)
 */

import type { AssemblerErrorParser } from './assembler-error-parser.interface'

/**
 * Supported assembler types
 */
export type AssemblerType = 'rasm' | 'pasmo' | 'sjasm' | 'vasm'

/**
 * Output format for compiled binaries
 */
export type OutputFormat = 'sna' | 'dsk' | 'bin'

/**
 * File to be included in compilation
 */
export interface AssemblerFile {
  name: string
  content: string
  projectName?: string
}

/**
 * Result of a compilation
 */
export interface CompileResult {
  success: boolean
  binary?: Uint8Array
  error?: string
  stdout: string[]
  stderr: string[]
}

/**
 * Assembler configuration
 */
export interface AssemblerConfig {
  /** Unique identifier */
  type: AssemblerType
  /** Display name */
  name: string
  /** Description */
  description: string
  /** Supported output formats */
  supportedFormats: OutputFormat[]
  /** Default output format */
  defaultFormat: OutputFormat
  /** URL to WASM binary */
  wasmUrl: string
  /** URL to JS loader */
  jsUrl: string
  /** Error parser for this assembler */
  errorParser: AssemblerErrorParser
  /** Whether this assembler supports CPC Plus features */
  supportsCpcPlus: boolean
  /** Documentation URL */
  docsUrl?: string
}

/**
 * Source preparation options
 */
export interface SourcePreparationOptions {
  source: string
  outputFormat: OutputFormat
  /** Entry point address (default: &4000) */
  entryPoint?: number
}

/**
 * Assembler service interface
 */
export interface IAssembler {
  /** Get assembler configuration */
  readonly config: AssemblerConfig

  /**
   * Prepare source code for compilation
   * Each assembler may need specific directives (BUILDSNA, SAVE, etc.)
   */
  prepareSource(options: SourcePreparationOptions): string

  /**
   * Get command line arguments for compilation
   */
  getCompileArgs(sourceFile: string, outputFile: string): string[]

  /**
   * Get expected output file path based on format
   */
  getOutputFilePath(format: OutputFormat): string

  /**
   * Get alternate output file paths to check (for recovery)
   */
  getAlternateOutputPaths(format: OutputFormat): string[]
}

/**
 * Registry of available assemblers
 */
export interface AssemblerRegistry {
  /** Get all available assemblers */
  getAll(): AssemblerConfig[]

  /** Get assembler by type */
  get(type: AssemblerType): IAssembler | undefined

  /** Get default assembler */
  getDefault(): IAssembler

  /** Register a new assembler */
  register(assembler: IAssembler): void
}
