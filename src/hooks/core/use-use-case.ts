/**
 * Generic hook factory for use-cases
 * Reduces boilerplate by providing a consistent pattern for:
 * - Loading state management
 * - Error handling
 * - Async execution
 */

import { useCallback, useState } from 'react'

type UseCase<TInput, TOutput> = {
  execute: (input: TInput) => Promise<TOutput>
}

type UseCaseState<TOutput> = {
  loading: boolean
  error: Error | null
  data: TOutput | null
}

type UseCaseResult<TInput, TOutput> = UseCaseState<TOutput> & {
  execute: (input: TInput) => Promise<TOutput>
  reset: () => void
}

/**
 * Creates a hook that wraps a use-case with loading/error state management
 *
 * @example
 * ```tsx
 * // In a component:
 * const { execute, loading, error } = useUseCase(container.createProject)
 *
 * const handleCreate = async () => {
 *   const result = await execute({ name: 'My Project', userId: user.id })
 * }
 * ```
 */
export function useUseCase<TInput, TOutput>(
  useCase: UseCase<TInput, TOutput>
): UseCaseResult<TInput, TOutput> {
  const [state, setState] = useState<UseCaseState<TOutput>>({
    loading: false,
    error: null,
    data: null
  })

  const execute = useCallback(
    async (input: TInput): Promise<TOutput> => {
      setState((prev) => ({ ...prev, loading: true, error: null }))

      try {
        const result = await useCase.execute(input)
        setState({ loading: false, error: null, data: result })
        return result
      } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err))
        setState((prev) => ({ ...prev, loading: false, error }))
        throw error
      }
    },
    [useCase]
  )

  const reset = useCallback(() => {
    setState({ loading: false, error: null, data: null })
  }, [])

  return {
    ...state,
    execute,
    reset
  }
}

/**
 * Factory to create simple hooks that just rename the execute function
 * Reduces boilerplate for hooks that don't need state sync
 *
 * @example
 * ```tsx
 * export const useAddTag = createSimpleHook(
 *   container.addTag,
 *   'addTag'
 * )
 * // Returns: { addTag, loading, error, reset, data }
 * ```
 */
export function createSimpleHook<TInput, TOutput, TMethodName extends string>(
  useCase: UseCase<TInput, TOutput>,
  methodName: TMethodName
): () => UseCaseState<TOutput> & {
  [K in TMethodName]: (input: TInput) => Promise<TOutput>
} & { reset: () => void } {
  return () => {
    const { execute, loading, error, reset, data } = useUseCase(useCase)
    return {
      [methodName]: execute,
      loading,
      error,
      reset,
      data
    } as UseCaseState<TOutput> & {
      [K in TMethodName]: (input: TInput) => Promise<TOutput>
    } & { reset: () => void }
  }
}

/**
 * Creates a hook for use-cases that don't require input (like getAll operations)
 */
export function useUseCaseWithoutInput<TOutput>(useCase: {
  execute: () => Promise<TOutput>
}): Omit<UseCaseResult<never, TOutput>, 'execute'> & {
  execute: () => Promise<TOutput>
} {
  const [state, setState] = useState<UseCaseState<TOutput>>({
    loading: false,
    error: null,
    data: null
  })

  const execute = useCallback(async (): Promise<TOutput> => {
    setState((prev) => ({ ...prev, loading: true, error: null }))

    try {
      const result = await useCase.execute()
      setState({ loading: false, error: null, data: result })
      return result
    } catch (err) {
      const error = err instanceof Error ? err : new Error(String(err))
      setState((prev) => ({ ...prev, loading: false, error }))
      throw error
    }
  }, [useCase])

  const reset = useCallback(() => {
    setState({ loading: false, error: null, data: null })
  }, [])

  return {
    ...state,
    execute,
    reset
  }
}
