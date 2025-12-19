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

let rasmModule: RasmModule | null = null
let rasmReady = false
let initPromise: Promise<void> | null = null

// Captured output during compilation
let stdoutLines: string[] = []
let stderrLines: string[] = []

async function initRasm(): Promise<void> {
  if (rasmModule) return
  if (initPromise) return initPromise

  initPromise = (async () => {
    console.log('[RASM Worker] Fetching WASM...')
    const wasmResponse = await fetch(RASM_WASM_URL)
    const wasmBinary = await wasmResponse.arrayBuffer()
    console.log('[RASM Worker] WASM fetched, size:', wasmBinary.byteLength)

    console.log('[RASM Worker] Fetching rasm.js...')
    const rasmJsResponse = await fetch(RASM_JS_URL)
    const rasmJsCode = await rasmJsResponse.text()
    console.log('[RASM Worker] rasm.js fetched, length:', rasmJsCode.length)

    console.log('[RASM Worker] Executing rasm.js to get factory...')
    // biome-ignore lint/security/noGlobalEval: Required to load WASM module dynamically
    const indirectEval = eval
    indirectEval(rasmJsCode)

    const createRASM = (self as unknown as Record<string, unknown>)
      .createRASM as (config: Record<string, unknown>) => Promise<RasmModule>

    if (!createRASM || typeof createRASM !== 'function') {
      throw new Error('createRASM factory not found after loading rasm.js')
    }

    console.log('[RASM Worker] Calling createRASM factory...')

    rasmModule = await createRASM({
      wasmBinary: wasmBinary,
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

    rasmReady = true
    console.log('[RASM Worker] RASM initialized successfully')
  })()

  return initPromise
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
  return `BUILDSNA
BANKSET 0
${source}
`
}

interface CompileResult {
  success: boolean
  binary?: Uint8Array
  error?: string
  stdout: string[]
  stderr: string[]
}

function compile(source: string, outputFormat: 'sna' | 'dsk'): CompileResult {
  // Reset output capture
  stdoutLines = []
  stderrLines = []

  if (!rasmModule) {
    return {
      success: false,
      error: 'RASM not initialized',
      stdout: [],
      stderr: []
    }
  }

  try {
    const FS = rasmModule.FS

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

    // Clean up source file
    try {
      FS.unlink(sourceFile)
    } catch {
      // Ignore cleanup errors
    }

    if (exitCode !== 0) {
      return {
        success: false,
        error:
          stderrLines.join('\n') || `RASM failed with exit code ${exitCode}`,
        stdout: stdoutLines,
        stderr: stderrLines
      }
    }

    const outputFile = outputFormat === 'dsk' ? '/output.dsk' : '/output.sna'

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
      FS.unlink(outputFile)
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
          FS.unlink(path)
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
  const { type, id, source, outputFormat } = e.data

  if (type === 'init') {
    try {
      await initRasm()
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
    if (!rasmReady) {
      try {
        await initRasm()
      } catch (error) {
        console.error('[RASM Worker] Compile init error:', error)
        self.postMessage({
          type: 'compile',
          id,
          success: false,
          error: `Failed to initialize RASM: ${error instanceof Error ? error.message : String(error)}`,
          stdout: [],
          stderr: []
        })
        return
      }
    }

    const result = compile(source, outputFormat)
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
  }
}

export {}
