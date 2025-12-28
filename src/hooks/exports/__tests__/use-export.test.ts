import { act, renderHook } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { Project } from '@/domain/entities/project.entity'
import { useExport } from '../use-export'

// Mock dependencies
const mockGetProjectWithDependencies = vi.fn()

vi.mock('@/infrastructure/container', () => ({
  container: {
    getProjectWithDependencies: {
      execute: (...args: unknown[]) => mockGetProjectWithDependencies(...args)
    }
  }
}))

vi.mock('@/lib/logger', () => ({
  createLogger: () => ({
    info: vi.fn(),
    warn: vi.fn(),
    error: vi.fn()
  })
}))

// Mock store atoms
let mockCompilationOutput: Uint8Array | null = null
let mockOutputFormat: 'sna' | 'dsk' = 'sna'

vi.mock('@/store', () => ({
  compilationOutputAtom: { key: 'compilationOutput' },
  outputFormatAtom: { key: 'outputFormat' }
}))

vi.mock('jotai', async (importOriginal) => {
  const actual = await importOriginal<typeof import('jotai')>()
  return {
    ...actual,
    useAtomValue: (atom: { key: string }) => {
      if (atom.key === 'compilationOutput') {
        return mockCompilationOutput
      }
      if (atom.key === 'outputFormat') {
        return mockOutputFormat
      }
      return null
    }
  }
})

// Helper to create a mock project
function createMockProject(overrides: Partial<Project> = {}): Project {
  return {
    id: 'project-1',
    name: { value: 'Test Project' },
    description: { value: 'Test description' },
    visibility: { value: 'public' },
    isLibrary: false,
    userId: 'user-1',
    files: [
      {
        id: 'file-1',
        name: { value: 'main.asm' },
        content: { value: '; Main file' },
        isMain: true,
        order: 0
      }
    ],
    dependencies: [],
    tags: [],
    sharedWith: [],
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides
  } as Project
}

// Mock for download - stored at module level and reused
const mockClick = vi.fn()
const mockCreateObjectURL = vi.fn(() => 'blob:test-url')
const mockRevokeObjectURL = vi.fn()

// Setup global mocks once
const originalCreateElement = document.createElement.bind(document)
document.createElement = ((tagName: string) => {
  if (tagName === 'a') {
    const anchor = originalCreateElement('a')
    anchor.click = mockClick
    return anchor
  }
  return originalCreateElement(tagName)
}) as typeof document.createElement

globalThis.URL.createObjectURL = mockCreateObjectURL
globalThis.URL.revokeObjectURL = mockRevokeObjectURL

describe('useExport', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mockCompilationOutput = null
    mockOutputFormat = 'sna'
  })

  describe('initial state', () => {
    it('returns correct initial state', () => {
      const { result } = renderHook(() => useExport())

      expect(result.current.exportingProject).toBe(false)
      expect(result.current.hasCompiledOutput).toBe(false)
      expect(result.current.currentOutputFormat).toBe('sna')
      expect(typeof result.current.exportProject).toBe('function')
      expect(typeof result.current.exportBinary).toBe('function')
      expect(typeof result.current.exportDsk).toBe('function')
      expect(typeof result.current.exportSna).toBe('function')
    })

    it('returns hasCompiledOutput true when compilation output exists', () => {
      mockCompilationOutput = new Uint8Array([1, 2, 3])

      const { result } = renderHook(() => useExport())
      expect(result.current.hasCompiledOutput).toBe(true)
    })
  })

  describe('exportProject', () => {
    it('exports project as ZIP successfully', async () => {
      const mockProject = createMockProject()
      const mockFiles = [
        {
          id: 'file-1',
          projectId: 'project-1',
          projectName: 'Test Project',
          name: 'main.asm',
          content: '; Main file',
          isMain: true,
          order: 0
        }
      ]

      mockGetProjectWithDependencies.mockResolvedValue({ files: mockFiles })

      const { result } = renderHook(() => useExport())

      let success: boolean
      await act(async () => {
        success = await result.current.exportProject(mockProject, 'user-1')
      })

      expect(success!).toBe(true)
      expect(mockGetProjectWithDependencies).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: 'user-1'
      })
      expect(mockCreateObjectURL).toHaveBeenCalled()
      expect(mockClick).toHaveBeenCalled()
      expect(mockRevokeObjectURL).toHaveBeenCalled()
    })

    it('exports project with dependencies', async () => {
      const mockProject = createMockProject()
      const mockFiles = [
        {
          id: 'file-1',
          projectId: 'project-1',
          projectName: 'Test Project',
          name: 'main.asm',
          content: '; Main file',
          isMain: true,
          order: 0
        },
        {
          id: 'file-2',
          projectId: 'dep-1',
          projectName: 'My Library',
          name: 'lib.asm',
          content: '; Library file',
          isMain: false,
          order: 0
        }
      ]

      mockGetProjectWithDependencies.mockResolvedValue({ files: mockFiles })

      const { result } = renderHook(() => useExport())

      let success: boolean
      await act(async () => {
        success = await result.current.exportProject(mockProject, 'user-1')
      })

      expect(success!).toBe(true)
      expect(mockCreateObjectURL).toHaveBeenCalledWith(expect.any(Blob))
    })

    it('returns false on error', async () => {
      const mockProject = createMockProject()
      mockGetProjectWithDependencies.mockRejectedValue(
        new Error('Failed to fetch')
      )

      const { result } = renderHook(() => useExport())

      let success: boolean
      await act(async () => {
        success = await result.current.exportProject(mockProject)
      })

      expect(success!).toBe(false)
    })

    it('exports without userId for anonymous access', async () => {
      const mockProject = createMockProject()
      mockGetProjectWithDependencies.mockResolvedValue({
        files: [
          {
            id: 'file-1',
            projectId: 'project-1',
            projectName: 'Test Project',
            name: 'main.asm',
            content: '; test',
            isMain: true,
            order: 0
          }
        ]
      })

      const { result } = renderHook(() => useExport())

      await act(async () => {
        await result.current.exportProject(mockProject)
      })

      expect(mockGetProjectWithDependencies).toHaveBeenCalledWith({
        projectId: 'project-1',
        userId: undefined
      })
    })
  })

  describe('exportBinary', () => {
    it('returns false when no compilation output exists', () => {
      const { result } = renderHook(() => useExport())

      const success = result.current.exportBinary('test-project')

      expect(success).toBe(false)
      expect(mockCreateObjectURL).not.toHaveBeenCalled()
    })

    it('exports binary when compilation output exists', () => {
      mockCompilationOutput = new Uint8Array([0x00, 0x01, 0x02, 0x03])

      const { result } = renderHook(() => useExport())

      const success = result.current.exportBinary('test-project')

      expect(success).toBe(true)
      expect(mockCreateObjectURL).toHaveBeenCalled()
      expect(mockClick).toHaveBeenCalled()
    })

    it('uses correct output format extension', () => {
      mockCompilationOutput = new Uint8Array([0x00, 0x01])
      mockOutputFormat = 'dsk'

      const { result } = renderHook(() => useExport())

      result.current.exportBinary('my-program')

      expect(mockClick).toHaveBeenCalled()
      expect(result.current.currentOutputFormat).toBe('dsk')
    })

    it('uses default name when not provided', () => {
      mockCompilationOutput = new Uint8Array([0x00])

      const { result } = renderHook(() => useExport())

      const success = result.current.exportBinary()

      expect(success).toBe(true)
      expect(mockClick).toHaveBeenCalled()
    })
  })

  describe('exportDsk', () => {
    it('exports DSK file', () => {
      const { result } = renderHook(() => useExport())
      const data = new Uint8Array([0x00, 0x01, 0x02])

      result.current.exportDsk(data, 'my-disk')

      expect(mockCreateObjectURL).toHaveBeenCalled()
      expect(mockClick).toHaveBeenCalled()
    })

    it('uses default name when not provided', () => {
      const { result } = renderHook(() => useExport())
      const data = new Uint8Array([0x00])

      result.current.exportDsk(data)

      expect(mockClick).toHaveBeenCalled()
    })
  })

  describe('exportSna', () => {
    it('exports SNA file', () => {
      const { result } = renderHook(() => useExport())
      const data = new Uint8Array([0x00, 0x01, 0x02])

      result.current.exportSna(data, 'my-snapshot')

      expect(mockCreateObjectURL).toHaveBeenCalled()
      expect(mockClick).toHaveBeenCalled()
    })

    it('uses default name when not provided', () => {
      const { result } = renderHook(() => useExport())
      const data = new Uint8Array([0x00])

      result.current.exportSna(data)

      expect(mockClick).toHaveBeenCalled()
    })
  })
})
