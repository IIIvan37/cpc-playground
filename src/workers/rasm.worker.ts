// RASM Web Worker - Isolated from main thread to avoid Module conflicts
/// <reference lib="webworker" />

declare const self: DedicatedWorkerGlobalScope

// In workers, we can't use import.meta.env, so check location
const IS_DEV =
  self.location.hostname === 'localhost' ||
  self.location.hostname === '127.0.0.1'
const CDN_BASE = IS_DEV ? 'https://cpcec-web.iiivan.org' : '/cdn'
const RASM_WASM_URL = `${CDN_BASE}/rasm.wasm`
const RASM_JS_URL = `${CDN_BASE}/rasm.js`

interface RasmModule {
  callMain: (args: string[]) => number
  FS: {
    writeFile: (path: string, data: string | Uint8Array) => void
    readFile: (
      path: string,
      opts?: { encoding?: string }
    ) => Uint8Array | string
    unlink: (path: string) => void
    readdir: (path: string) => string[]
  }
  HEAPU8: Uint8Array
}

// Cached resources
let wasmBinary: ArrayBuffer | null = null
let createRASM:
  | ((config: Record<string, unknown>) => Promise<RasmModule>)
  | null = null

// Captured output during compilation
let stdoutLines: string[] = []
let stderrLines: string[] = []

async function loadResources(): Promise<void> {
  if (wasmBinary && createRASM) return

  console.log('[RASM Worker] Fetching WASM...')
  const wasmResponse = await fetch(RASM_WASM_URL)
  wasmBinary = await wasmResponse.arrayBuffer()
  console.log('[RASM Worker] WASM fetched, size:', wasmBinary.byteLength)

  console.log('[RASM Worker] Fetching rasm.js...')
  const rasmJsResponse = await fetch(RASM_JS_URL)
  const rasmJsCode = await rasmJsResponse.text()
  console.log('[RASM Worker] rasm.js fetched, length:', rasmJsCode.length)

  console.log('[RASM Worker] Executing rasm.js to get factory...')
  // biome-ignore lint/security/noGlobalEval: Required to load WASM module dynamically
  const indirectEval = eval
  indirectEval(rasmJsCode)

  createRASM = (self as unknown as Record<string, unknown>).createRASM as (
    config: Record<string, unknown>
  ) => Promise<RasmModule>

  if (!createRASM || typeof createRASM !== 'function') {
    throw new Error('createRASM factory not found after loading rasm.js')
  }
}

// Create a fresh RASM module for each compilation to avoid state issues
async function createFreshRasmModule(): Promise<RasmModule> {
  if (!wasmBinary || !createRASM) {
    await loadResources()
  }

  console.log('[RASM Worker] Creating fresh RASM module...')

  const module = await createRASM!({
    wasmBinary: wasmBinary!.slice(0), // Clone the binary
    wasmMemory: new WebAssembly.Memory({
      initial: 1024, // 64MB (1024 pages * 64KB)
      maximum: 2048 // 128MB max
    }),
    print: (text: string) => {
      stdoutLines.push(text)
      console.log('[RASM]', text)
    },
    printErr: (text: string) => {
      stderrLines.push(text)
      console.error('[RASM Error]', text)
    },
    locateFile: (path: string) => {
      if (path.endsWith('.wasm')) {
        return RASM_WASM_URL
      }
      return path
    }
  })

  console.log('[RASM Worker] Fresh RASM module created')
  return module
}

function prepareDskSource(source: string): string {
  const orgMatch = source.match(/org\s+[&$#]?([0-9a-fA-F]+)/i)
  const orgAddress = orgMatch ? `#${orgMatch[1]}` : '#4000'

  return `
__cpc_playground_start equ ${orgAddress}
${source}
__cpc_playground_end:
SAVE 'PROGRAM.BIN',__cpc_playground_start,__cpc_playground_end-__cpc_playground_start,DSK,'/output.dsk'
`
}

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

interface ProjectFile {
  name: string
  content: string
  projectName?: string // Optional project name for namespacing
}

interface CompileResult {
  success: boolean
  binary?: Uint8Array
  error?: string
  stdout: string[]
  stderr: string[]
}

async function compile(
  source: string,
  outputFormat: 'sna' | 'dsk',
  additionalFiles?: ProjectFile[]
): Promise<CompileResult> {
  // Reset output capture
  stdoutLines = []
  stderrLines = []

  // Keep reference to FS for recovery after crash
  let FS: RasmModule['FS'] | null = null
  const outputFile = outputFormat === 'dsk' ? '/output.dsk' : '/output.sna'

  try {
    // Create a fresh module for each compilation
    const rasmModule = await createFreshRasmModule()
    FS = rasmModule.FS

    // Write all additional files to the virtual filesystem
    if (additionalFiles && additionalFiles.length > 0) {
      for (const file of additionalFiles) {
        // If file has a projectName, write it in a subdirectory
        const filePath = file.projectName
          ? `/${file.projectName}/${file.name}`
          : `/${file.name}`

        FS.writeFile(filePath, file.content)
        console.log('[RASM Worker] Wrote additional file:', filePath)
      }
    }

    const finalSource =
      outputFormat === 'sna'
        ? prepareSnaSource(source)
        : prepareDskSource(source)

    const sourceFile = '/input.asm'
    FS.writeFile(sourceFile, finalSource)

    const args: string[] = [sourceFile, '-o', '/output']

    console.log('[RASM Worker] Running RASM with args:', args)
    const exitCode = rasmModule.callMain(args)
    console.log('[RASM Worker] RASM exit code:', exitCode)

    if (exitCode !== 0) {
      return {
        success: false,
        error:
          stderrLines.join('\n') || `RASM failed with exit code ${exitCode}`,
        stdout: stdoutLines,
        stderr: stderrLines
      }
    }

    let binary: Uint8Array
    try {
      const files = FS.readdir('/')
      console.log('[RASM Worker] Files in /:', files)

      binary = FS.readFile(outputFile) as Uint8Array
      console.log(
        '[RASM Worker] Read output file:',
        outputFile,
        'size:',
        binary.length
      )
    } catch (e) {
      console.error('[RASM Worker] Failed to read output:', e)
      const files = FS.readdir('/')

      const alternateNames =
        outputFormat === 'dsk'
          ? ['program.dsk', '/program.dsk', 'output.dsk']
          : ['output.sna', '/output.sna']

      for (const name of alternateNames) {
        try {
          const path = name.startsWith('/') ? name : `/${name}`
          binary = FS.readFile(path) as Uint8Array
          console.log('[RASM Worker] Found at alternate path:', path)
          return {
            success: true,
            binary,
            stdout: stdoutLines,
            stderr: stderrLines
          }
        } catch {
          // Continue trying
        }
      }

      return {
        success: false,
        error: `Output file not found. Available: ${files.join(', ')}`,
        stdout: stdoutLines,
        stderr: stderrLines
      }
    }

    return { success: true, binary, stdout: stdoutLines, stderr: stderrLines }
  } catch (e) {
    console.error('[RASM Worker] Compile error:', e)

    // RASM may crash after writing the output file (e.g., during symbol file generation)
    // Try to recover the output file if it was written before the crash
    if (FS) {
      try {
        console.log(
          '[RASM Worker] Attempting to recover output file after crash...'
        )
        const files = FS.readdir('/')
        console.log('[RASM Worker] Files available after crash:', files)

        if (
          files.includes(outputFile.replace('/', '')) ||
          files.includes(outputFile)
        ) {
          const binary = FS.readFile(outputFile) as Uint8Array
          if (binary && binary.length > 0) {
            console.log(
              '[RASM Worker] Successfully recovered output file, size:',
              binary.length
            )
            return {
              success: true,
              binary,
              stdout: stdoutLines,
              stderr: stderrLines
            }
          }
        }
      } catch (recoveryError) {
        console.error('[RASM Worker] Recovery failed:', recoveryError)
      }
    }

    return {
      success: false,
      error: e instanceof Error ? e.message : String(e),
      stdout: stdoutLines,
      stderr: stderrLines
    }
  }
}

// Message handler
self.onmessage = async (e: MessageEvent) => {
  const { type, id, source, outputFormat, additionalFiles } = e.data

  if (type === 'init') {
    try {
      await loadResources()
      self.postMessage({ type: 'init', id, success: true })
    } catch (error) {
      console.error('[RASM Worker] Init error:', error)
      self.postMessage({
        type: 'init',
        id,
        success: false,
        error: error instanceof Error ? error.message : 'Init failed'
      })
    }
  } else if (type === 'compile') {
    try {
      const result = await compile(source, outputFormat, additionalFiles)
      if (result.success && result.binary) {
        self.postMessage(
          {
            type: 'compile',
            id,
            success: true,
            binary: result.binary,
            stdout: result.stdout,
            stderr: result.stderr
          },
          { transfer: [result.binary.buffer] }
        )
      } else {
        self.postMessage({
          type: 'compile',
          id,
          success: false,
          error: result.error,
          stdout: result.stdout,
          stderr: result.stderr
        })
      }
    } catch (error) {
      console.error('[RASM Worker] Compile error:', error)
      self.postMessage({
        type: 'compile',
        id,
        success: false,
        error: `Compilation failed: ${error instanceof Error ? error.message : String(error)}`,
        stdout: stdoutLines,
        stderr: stderrLines
      })
    }
  }
}

export {}
