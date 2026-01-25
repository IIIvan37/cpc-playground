/**
 * Generic pagination types for paginated queries
 */

export type PaginationParams = {
  readonly limit: number
  readonly offset: number
}

export type PaginatedResult<T> = {
  readonly items: readonly T[]
  readonly total: number
  readonly hasMore: boolean
}

export const DEFAULT_PAGE_SIZE = 20
