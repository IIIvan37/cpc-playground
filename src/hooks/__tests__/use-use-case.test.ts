import { act, renderHook } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import { useUseCase, useUseCaseWithoutInput } from '../use-use-case'

describe('useUseCase', () => {
  describe('initial state', () => {
    it('should start with loading false', () => {
      const useCase = { execute: vi.fn() }
      const { result } = renderHook(() => useUseCase(useCase))

      expect(result.current.loading).toBe(false)
    })

    it('should start with error null', () => {
      const useCase = { execute: vi.fn() }
      const { result } = renderHook(() => useUseCase(useCase))

      expect(result.current.error).toBe(null)
    })

    it('should start with data null', () => {
      const useCase = { execute: vi.fn() }
      const { result } = renderHook(() => useUseCase(useCase))

      expect(result.current.data).toBe(null)
    })
  })

  describe('execute', () => {
    it('should set loading to true when executing', async () => {
      let resolvePromise: (value: string) => void
      const promise = new Promise<string>((resolve) => {
        resolvePromise = resolve
      })
      const useCase = { execute: vi.fn().mockReturnValue(promise) }
      const { result } = renderHook(() => useUseCase(useCase))

      act(() => {
        result.current.execute({ input: 'test' })
      })

      expect(result.current.loading).toBe(true)

      await act(async () => {
        resolvePromise!('result')
      })
    })

    it('should call useCase.execute with input', async () => {
      const useCase = { execute: vi.fn().mockResolvedValue('result') }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        await result.current.execute({ id: '123', name: 'test' })
      })

      expect(useCase.execute).toHaveBeenCalledWith({ id: '123', name: 'test' })
    })

    it('should return the result from useCase', async () => {
      const expectedResult = { id: '123', name: 'Test Project' }
      const useCase = { execute: vi.fn().mockResolvedValue(expectedResult) }
      const { result } = renderHook(() => useUseCase(useCase))

      let executeResult: typeof expectedResult | undefined
      await act(async () => {
        executeResult = (await result.current.execute({ input: 'test' })) as
          | typeof expectedResult
          | undefined
      })

      expect(executeResult).toEqual(expectedResult)
    })

    it('should set data after successful execution', async () => {
      const expectedResult = { id: '123', name: 'Test' }
      const useCase = { execute: vi.fn().mockResolvedValue(expectedResult) }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        await result.current.execute({ input: 'test' })
      })

      expect(result.current.data).toEqual(expectedResult)
    })

    it('should set loading to false after successful execution', async () => {
      const useCase = { execute: vi.fn().mockResolvedValue('result') }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        await result.current.execute({ input: 'test' })
      })

      expect(result.current.loading).toBe(false)
    })

    it('should clear error after successful execution', async () => {
      const useCase = {
        execute: vi
          .fn()
          .mockRejectedValueOnce(new Error('First error'))
          .mockResolvedValueOnce('success')
      }
      const { result } = renderHook(() => useUseCase(useCase))

      // First call fails
      await act(async () => {
        try {
          await result.current.execute({ input: 'test' })
        } catch {
          // Expected
        }
      })

      expect(result.current.error).toBeTruthy()

      // Second call succeeds
      await act(async () => {
        await result.current.execute({ input: 'test' })
      })

      expect(result.current.error).toBe(null)
    })
  })

  describe('error handling', () => {
    it('should set error when execution fails with Error', async () => {
      const error = new Error('Something went wrong')
      const useCase = { execute: vi.fn().mockRejectedValue(error) }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        try {
          await result.current.execute({ input: 'test' })
        } catch {
          // Expected
        }
      })

      expect(result.current.error).toBe(error)
    })

    it('should convert string errors to Error objects', async () => {
      const useCase = { execute: vi.fn().mockRejectedValue('String error') }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        try {
          await result.current.execute({ input: 'test' })
        } catch {
          // Expected
        }
      })

      expect(result.current.error).toBeInstanceOf(Error)
      expect(result.current.error?.message).toBe('String error')
    })

    it('should set loading to false after error', async () => {
      const useCase = {
        execute: vi.fn().mockRejectedValue(new Error('Error'))
      }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        try {
          await result.current.execute({ input: 'test' })
        } catch {
          // Expected
        }
      })

      expect(result.current.loading).toBe(false)
    })

    it('should rethrow the error', async () => {
      const error = new Error('Test error')
      const useCase = { execute: vi.fn().mockRejectedValue(error) }
      const { result } = renderHook(() => useUseCase(useCase))

      await expect(
        act(async () => {
          await result.current.execute({ input: 'test' })
        })
      ).rejects.toThrow('Test error')
    })
  })

  describe('reset', () => {
    it('should reset all state', async () => {
      const useCase = { execute: vi.fn().mockResolvedValue({ data: 'test' }) }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        await result.current.execute({ input: 'test' })
      })

      expect(result.current.data).toBeTruthy()

      act(() => {
        result.current.reset()
      })

      expect(result.current.loading).toBe(false)
      expect(result.current.error).toBe(null)
      expect(result.current.data).toBe(null)
    })

    it('should reset error state', async () => {
      const useCase = {
        execute: vi.fn().mockRejectedValue(new Error('Error'))
      }
      const { result } = renderHook(() => useUseCase(useCase))

      await act(async () => {
        try {
          await result.current.execute({ input: 'test' })
        } catch {
          // Expected
        }
      })

      expect(result.current.error).toBeTruthy()

      act(() => {
        result.current.reset()
      })

      expect(result.current.error).toBe(null)
    })
  })

  describe('stability', () => {
    it('should maintain stable execute reference', async () => {
      const useCase = { execute: vi.fn().mockResolvedValue('result') }
      const { result, rerender } = renderHook(() => useUseCase(useCase))

      const firstExecute = result.current.execute
      rerender()
      const secondExecute = result.current.execute

      expect(firstExecute).toBe(secondExecute)
    })

    it('should maintain stable reset reference', () => {
      const useCase = { execute: vi.fn() }
      const { result, rerender } = renderHook(() => useUseCase(useCase))

      const firstReset = result.current.reset
      rerender()
      const secondReset = result.current.reset

      expect(firstReset).toBe(secondReset)
    })
  })
})

describe('useUseCaseWithoutInput', () => {
  it('should call execute without arguments', async () => {
    const useCase = { execute: vi.fn().mockResolvedValue(['item1', 'item2']) }
    const { result } = renderHook(() => useUseCaseWithoutInput(useCase))

    await act(async () => {
      await result.current.execute()
    })

    expect(useCase.execute).toHaveBeenCalledWith()
  })

  it('should return data after execution', async () => {
    const expectedData = [{ id: '1' }, { id: '2' }]
    const useCase = { execute: vi.fn().mockResolvedValue(expectedData) }
    const { result } = renderHook(() => useUseCaseWithoutInput(useCase))

    await act(async () => {
      await result.current.execute()
    })

    expect(result.current.data).toEqual(expectedData)
  })

  it('should handle errors', async () => {
    const error = new Error('Failed to fetch')
    const useCase = { execute: vi.fn().mockRejectedValue(error) }
    const { result } = renderHook(() => useUseCaseWithoutInput(useCase))

    await act(async () => {
      try {
        await result.current.execute()
      } catch {
        // Expected
      }
    })

    expect(result.current.error).toBe(error)
  })
})
