import { act, renderHook } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { useSearchUsers } from '../use-search-users'

const mockSearchUsers = vi.fn()
vi.mock('@/infrastructure/container', () => ({
  container: {
    searchUsers: {
      execute: (...args: unknown[]) => mockSearchUsers(...args)
    }
  }
}))

describe('useSearchUsers', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('returns initial state', () => {
    const { result } = renderHook(() => useSearchUsers())

    expect(result.current.users).toEqual([])
    expect(result.current.loading).toBe(false)
    expect(result.current.error).toBe(null)
    expect(typeof result.current.searchUsers).toBe('function')
  })

  it('searches users successfully', async () => {
    const mockUsers = [
      { id: 'user-1', username: 'testuser1' },
      { id: 'user-2', username: 'testuser2' }
    ]

    mockSearchUsers.mockResolvedValue({
      users: mockUsers
    })

    const { result } = renderHook(() => useSearchUsers())

    await act(async () => {
      await result.current.searchUsers('test')
    })

    expect(result.current.users).toEqual(mockUsers)
    expect(result.current.error).toBe(null)
    expect(mockSearchUsers).toHaveBeenCalledWith({
      query: 'test',
      limit: undefined
    })
  })

  it('searches users with custom limit', async () => {
    const mockUsers = [{ id: 'user-1', username: 'testuser1' }]

    mockSearchUsers.mockResolvedValue({
      users: mockUsers
    })

    const { result } = renderHook(() => useSearchUsers())

    await act(async () => {
      await result.current.searchUsers('test', 5)
    })

    expect(result.current.users).toEqual(mockUsers)
    expect(mockSearchUsers).toHaveBeenCalledWith({
      query: 'test',
      limit: 5
    })
  })

  it('handles search error', async () => {
    const searchError = new Error('Search failed')
    mockSearchUsers.mockRejectedValue(searchError)

    const { result } = renderHook(() => useSearchUsers())

    await act(async () => {
      await result.current.searchUsers('test')
    })

    expect(result.current.users).toEqual([])
    expect(result.current.error).toBe(searchError)
  })

  it('handles non-Error search failure', async () => {
    mockSearchUsers.mockRejectedValue('String error')

    const { result } = renderHook(() => useSearchUsers())

    await act(async () => {
      await result.current.searchUsers('test')
    })

    expect(result.current.users).toEqual([])
    expect(result.current.error).toBeInstanceOf(Error)
    expect(result.current.error?.message).toBe('Failed to search users')
  })

  it('clears previous error on new search', async () => {
    const searchError = new Error('Search failed')
    mockSearchUsers
      .mockRejectedValueOnce(searchError)
      .mockResolvedValueOnce({ users: [] })

    const { result } = renderHook(() => useSearchUsers())

    // First search fails
    await act(async () => {
      await result.current.searchUsers('fail')
    })
    expect(result.current.error).toBe(searchError)

    // Second search succeeds and clears error
    await act(async () => {
      await result.current.searchUsers('success')
    })
    expect(result.current.error).toBe(null)
  })
})
