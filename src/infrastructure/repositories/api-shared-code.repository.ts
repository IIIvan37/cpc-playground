import type { ISharedCodeRepository } from '@/domain/repositories/shared-code.repository.interface'

/**
 * Implementation of shared code repository using Netlify API
 */
export function createApiSharedCodeRepository(): ISharedCodeRepository {
  return {
    async getByShareId(shareId: string): Promise<string | null> {
      const response = await fetch(
        `/api/share?id=${encodeURIComponent(shareId)}`
      )

      if (!response.ok) {
        if (response.status === 404) {
          return null
        }
        const data = await response.json()
        throw new Error(data.error || 'Failed to load shared code')
      }

      const data = await response.json()
      return data.code
    },

    async create(code: string): Promise<string> {
      const response = await fetch('/api/share', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code })
      })

      if (!response.ok) {
        const data = await response.json()
        throw new Error(data.error || 'Failed to create share')
      }

      const data = await response.json()
      return data.id
    }
  }
}
