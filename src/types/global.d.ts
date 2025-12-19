declare global {
  interface Window {
    cpcec: {
      canvas: HTMLCanvasElement
      boot: () => void
      reset: () => void
      loadBinary: (data: Uint8Array, address: number) => void
      run: (address: number) => void
      setKeyboardEnabled: (enabled: boolean) => void
    }
    rasm: {
      compile: (source: string) => {
        success: boolean
        binary?: Uint8Array
        errors?: string[]
        output?: string
      }
    }
  }

  var cpcec: Window['cpcec']
  var rasm: Window['rasm']
}

export {}
