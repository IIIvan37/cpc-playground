/**
 * Assembler Adapter Interface
 * Defines the contract for assembler worker adapters
 * This abstracts the communication with Web Workers for different assemblers
 */

import type { AssemblerType, OutputFormat } from './assembler.interface'

/**
 * File to include in compilation
 */
export interface CompilationFile {
  name: string
  content: string
  projectName?: string
}

/**
 * Result of a compilation
 */
export interface CompilationResult {
  success: boolean
  binary?: Uint8Array
  error?: string
  stdout: string[]
  stderr: string[]
}

/**
 * Compilation options
 */
export interface CompilationOptions {
  source: string
  outputFormat: OutputFormat
  additionalFiles?: CompilationFile[]
}

/**
 * Assembler adapter interface
 * Each assembler (RASM, PASMO, etc.) implements this interface
 * to provide a unified API for compilation
 */
export interface IAssemblerAdapter {
  /** The type of assembler this adapter handles */
  readonly type: AssemblerType

  /**
   * Initialize the adapter (load WASM, etc.)
   * Should be called before compile()
   */
  initialize(): Promise<void>

  /**
   * Check if the adapter is initialized and ready
   */
  isReady(): boolean

  /**
   * Compile source code
   */
  compile(options: CompilationOptions): Promise<CompilationResult>

  /**
   * Dispose of resources (terminate worker, etc.)
   */
  dispose(): void
}

/**
 * Factory function type for creating assembler adapters
 */
export type AssemblerAdapterFactory = () => IAssemblerAdapter
