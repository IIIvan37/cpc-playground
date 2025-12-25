import type { Mock } from 'vitest'
import { beforeEach, describe, expect, it, vi } from 'vitest'

// Mock FS interface matching the worker's RasmModule['FS']
interface MockFS {
  writeFile: Mock<(path: string, data: string | Uint8Array) => void>
  readFile: Mock<
    (path: string, opts?: { encoding?: string }) => Uint8Array | string
  >
  unlink: Mock<(path: string) => void>
  readdir: Mock<(path: string) => string[]>
  mkdir: Mock<(path: string) => void>
  stat: Mock<(path: string) => { mode: number }>
}

interface ProjectFile {
  name: string
  content: string
  projectName?: string
}

// Extract the logic we want to test (mirrors the worker implementation)
function ensureDirectoryExists(FS: MockFS, dirPath: string): void {
  try {
    FS.stat(dirPath)
  } catch {
    FS.mkdir(dirPath)
  }
}

function writeAdditionalFiles(
  FS: MockFS,
  additionalFiles?: ProjectFile[]
): void {
  if (!additionalFiles || additionalFiles.length === 0) return

  // Collect all unique directories that need to be created
  const directories = new Set<string>()
  for (const file of additionalFiles) {
    if (file.projectName) {
      directories.add(`/${file.projectName}`)
    }
  }

  // Create all required directories first
  for (const dir of directories) {
    ensureDirectoryExists(FS, dir)
  }

  // Now write all files
  for (const file of additionalFiles) {
    const filePath = file.projectName
      ? `/${file.projectName}/${file.name}`
      : `/${file.name}`
    FS.writeFile(filePath, file.content)
  }
}

describe('RASM Worker Helper Functions', () => {
  let mockFS: MockFS

  beforeEach(() => {
    mockFS = {
      writeFile: vi.fn(),
      readFile: vi.fn(),
      unlink: vi.fn(),
      readdir: vi.fn(),
      mkdir: vi.fn(),
      stat: vi.fn()
    }
  })

  describe('ensureDirectoryExists', () => {
    it('should not create directory if it already exists', () => {
      mockFS.stat.mockReturnValue({ mode: 16877 }) // Directory exists

      ensureDirectoryExists(mockFS, '/mylib')

      expect(mockFS.stat).toHaveBeenCalledWith('/mylib')
      expect(mockFS.mkdir).not.toHaveBeenCalled()
    })

    it('should create directory if it does not exist', () => {
      mockFS.stat.mockImplementation(() => {
        throw new Error('ENOENT')
      })

      ensureDirectoryExists(mockFS, '/mylib')

      expect(mockFS.stat).toHaveBeenCalledWith('/mylib')
      expect(mockFS.mkdir).toHaveBeenCalledWith('/mylib')
    })
  })

  describe('writeAdditionalFiles', () => {
    it('should do nothing when additionalFiles is undefined', () => {
      writeAdditionalFiles(mockFS)

      expect(mockFS.writeFile).not.toHaveBeenCalled()
      expect(mockFS.mkdir).not.toHaveBeenCalled()
    })

    it('should do nothing when additionalFiles is empty', () => {
      writeAdditionalFiles(mockFS, [])

      expect(mockFS.writeFile).not.toHaveBeenCalled()
      expect(mockFS.mkdir).not.toHaveBeenCalled()
    })

    it('should write files without projectName to root', () => {
      const files: ProjectFile[] = [
        { name: 'utils.asm', content: '; utils' },
        { name: 'macros.asm', content: '; macros' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).not.toHaveBeenCalled()
      expect(mockFS.writeFile).toHaveBeenCalledTimes(2)
      expect(mockFS.writeFile).toHaveBeenCalledWith('/utils.asm', '; utils')
      expect(mockFS.writeFile).toHaveBeenCalledWith('/macros.asm', '; macros')
    })

    it('should create directory and write files with projectName', () => {
      mockFS.stat.mockImplementation(() => {
        throw new Error('ENOENT')
      })

      const files: ProjectFile[] = [
        { name: 'lib.asm', content: '; library code', projectName: 'mylib' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).toHaveBeenCalledWith('/mylib')
      expect(mockFS.writeFile).toHaveBeenCalledWith(
        '/mylib/lib.asm',
        '; library code'
      )
    })

    it('should create directory only once for multiple files in same project', () => {
      mockFS.stat.mockImplementation(() => {
        throw new Error('ENOENT')
      })

      const files: ProjectFile[] = [
        { name: 'main.asm', content: '; main', projectName: 'mylib' },
        { name: 'utils.asm', content: '; utils', projectName: 'mylib' },
        { name: 'helpers.asm', content: '; helpers', projectName: 'mylib' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).toHaveBeenCalledTimes(1)
      expect(mockFS.mkdir).toHaveBeenCalledWith('/mylib')
      expect(mockFS.writeFile).toHaveBeenCalledTimes(3)
    })

    it('should handle mix of files with and without projectName', () => {
      mockFS.stat.mockImplementation(() => {
        throw new Error('ENOENT')
      })

      const files: ProjectFile[] = [
        { name: 'local.asm', content: '; local' },
        { name: 'lib.asm', content: '; lib', projectName: 'external' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).toHaveBeenCalledTimes(1)
      expect(mockFS.mkdir).toHaveBeenCalledWith('/external')
      expect(mockFS.writeFile).toHaveBeenCalledWith('/local.asm', '; local')
      expect(mockFS.writeFile).toHaveBeenCalledWith(
        '/external/lib.asm',
        '; lib'
      )
    })

    it('should create multiple directories for different projects', () => {
      mockFS.stat.mockImplementation(() => {
        throw new Error('ENOENT')
      })

      const files: ProjectFile[] = [
        { name: 'a.asm', content: '; a', projectName: 'lib1' },
        { name: 'b.asm', content: '; b', projectName: 'lib2' },
        { name: 'c.asm', content: '; c', projectName: 'lib1' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).toHaveBeenCalledTimes(2)
      expect(mockFS.mkdir).toHaveBeenCalledWith('/lib1')
      expect(mockFS.mkdir).toHaveBeenCalledWith('/lib2')
      expect(mockFS.writeFile).toHaveBeenCalledTimes(3)
    })

    it('should not recreate directory if it already exists', () => {
      // First call succeeds (directory exists), second fails (doesn't exist)
      mockFS.stat.mockImplementation((path: string) => {
        if (path === '/existing') {
          return { mode: 16877 }
        }
        throw new Error('ENOENT')
      })

      const files: ProjectFile[] = [
        { name: 'a.asm', content: '; a', projectName: 'existing' },
        { name: 'b.asm', content: '; b', projectName: 'newdir' }
      ]

      writeAdditionalFiles(mockFS, files)

      expect(mockFS.mkdir).toHaveBeenCalledTimes(1)
      expect(mockFS.mkdir).toHaveBeenCalledWith('/newdir')
      expect(mockFS.mkdir).not.toHaveBeenCalledWith('/existing')
    })
  })
})
