import { renderHook } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import {
  useHandleCreateProject,
  useHandleForkProject
} from '../use-explore-actions'

const mockNavigate = vi.fn()
vi.mock('react-router-dom', () => ({
  useNavigate: () => mockNavigate
}))

const mockCreateProject = vi.fn()
const mockForkProject = vi.fn()
const mockToastSuccess = vi.fn()
const mockToastError = vi.fn()

vi.mock('../use-projects', () => ({
  useCreateProject: () => ({ create: mockCreateProject }),
  useForkProject: () => ({ forkProject: mockForkProject, loading: false })
}))

vi.mock('../../core/use-toast', () => ({
  useToastActions: () => ({
    success: mockToastSuccess,
    error: mockToastError
  })
}))

vi.mock('@/lib/constants', () => ({
  MINIMAL_ASM_TEMPLATE: 'minimal asm template'
}))

describe('useHandleCreateProject', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('creates a project without initial code', async () => {
    const mockResult = { project: { id: '123' } }
    mockCreateProject.mockResolvedValue(mockResult)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-1',
      name: 'Test Project',
      isLibrary: false
    })

    expect(createResult.success).toBe(true)
    expect(mockCreateProject).toHaveBeenCalledWith({
      userId: 'user-1',
      name: 'Test Project',
      visibility: 'private',
      isLibrary: false,
      files: [
        {
          name: 'main.asm',
          content: 'minimal asm template',
          isMain: true
        }
      ]
    })
    expect(mockNavigate).toHaveBeenCalledWith('/?project=123')
  })

  it('creates a project with initial code', async () => {
    const mockResult = { project: { id: '456' } }
    mockCreateProject.mockResolvedValue(mockResult)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-2',
      name: 'Project with Code',
      isLibrary: false,
      initialCode: 'some code'
    })

    expect(createResult.success).toBe(true)
    expect(mockCreateProject).toHaveBeenCalledWith({
      userId: 'user-2',
      name: 'Project with Code',
      visibility: 'private',
      isLibrary: false,
      files: [
        {
          name: 'main.asm',
          content: 'some code',
          isMain: true
        }
      ]
    })
    expect(mockNavigate).toHaveBeenCalledWith('/?project=456')
  })

  it('creates a library project', async () => {
    const mockResult = { project: { id: '789' } }
    mockCreateProject.mockResolvedValue(mockResult)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-3',
      name: 'Library Project',
      isLibrary: true,
      initialCode: 'library code'
    })

    expect(createResult.success).toBe(true)
    expect(mockCreateProject).toHaveBeenCalledWith({
      userId: 'user-3',
      name: 'Library Project',
      visibility: 'private',
      isLibrary: true,
      files: [
        {
          name: 'lib.asm',
          content: 'library code',
          isMain: false
        }
      ]
    })
    expect(mockNavigate).toHaveBeenCalledWith('/?project=789')
  })

  it('handles creation failure', async () => {
    mockCreateProject.mockResolvedValue(null)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-4',
      name: 'Failed Project',
      isLibrary: false
    })

    expect(createResult.success).toBe(false)
    expect(createResult.error).toBe('Failed to create project')
    expect(mockNavigate).not.toHaveBeenCalled()
  })

  it('handles creation error', async () => {
    const error = new Error('Database error')
    mockCreateProject.mockRejectedValue(error)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-5',
      name: 'Error Project',
      isLibrary: false
    })

    expect(createResult.success).toBe(false)
    expect(createResult.error).toBe('Database error')
    expect(mockNavigate).not.toHaveBeenCalled()
  })

  it('trims initial code', async () => {
    const mockResult = { project: { id: '101' } }
    mockCreateProject.mockResolvedValue(mockResult)

    const { result } = renderHook(() => useHandleCreateProject())

    const createResult = await result.current.handleCreate({
      userId: 'user-6',
      name: 'Trimmed Code Project',
      isLibrary: false,
      initialCode: '  code with spaces  '
    })

    expect(createResult.success).toBe(true)
    expect(mockCreateProject).toHaveBeenCalledWith({
      userId: 'user-6',
      name: 'Trimmed Code Project',
      visibility: 'private',
      isLibrary: false,
      files: [
        {
          name: 'main.asm',
          content: 'code with spaces',
          isMain: true
        }
      ]
    })
  })
})

describe('useHandleForkProject', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('forks a project successfully', async () => {
    const mockResult = { project: { id: 'fork-123' } }
    mockForkProject.mockResolvedValue(mockResult)

    const { result } = renderHook(() => useHandleForkProject())

    const forkResult = await result.current.handleFork({
      projectId: 'original-123',
      userId: 'user-1'
    })

    expect(forkResult.success).toBe(true)
    expect(mockForkProject).toHaveBeenCalledWith({
      projectId: 'original-123',
      userId: 'user-1'
    })
    expect(mockToastSuccess).toHaveBeenCalledWith(
      'Project forked successfully!'
    )
    expect(mockNavigate).toHaveBeenCalledWith('/?project=fork-123')
  })

  it('handles fork failure', async () => {
    mockForkProject.mockResolvedValue(null)

    const { result } = renderHook(() => useHandleForkProject())

    const forkResult = await result.current.handleFork({
      projectId: 'original-456',
      userId: 'user-2'
    })

    expect(forkResult.success).toBe(false)
    expect(forkResult.error).toBe('Failed to fork project')
    expect(mockToastError).not.toHaveBeenCalled()
    expect(mockNavigate).not.toHaveBeenCalled()
  })

  it('handles fork error', async () => {
    const error = new Error('Fork error')
    mockForkProject.mockRejectedValue(error)

    const { result } = renderHook(() => useHandleForkProject())

    const forkResult = await result.current.handleFork({
      projectId: 'original-789',
      userId: 'user-3'
    })

    expect(forkResult.success).toBe(false)
    expect(forkResult.error).toBe('Fork error')
    expect(mockToastError).toHaveBeenCalledWith('Fork error')
    expect(mockNavigate).not.toHaveBeenCalled()
  })
})
