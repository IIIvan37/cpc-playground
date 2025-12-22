import { describe, expect, it, vi } from 'vitest'
import type { ISharedCodeRepository } from '@/domain/repositories/shared-code.repository.interface'
import { createGetSharedCodeUseCase } from '../get-shared-code.use-case'

describe('GetSharedCodeUseCase', () => {
  const createMockRepository = (
    overrides: Partial<ISharedCodeRepository> = {}
  ): ISharedCodeRepository => ({
    getByShareId: vi.fn(),
    create: vi.fn(),
    ...overrides
  })

  describe('execute', () => {
    it('should return code when share exists', async () => {
      const mockCode = '; Hello World\norg #4000'
      const repository = createMockRepository({
        getByShareId: vi.fn().mockResolvedValue(mockCode)
      })
      const useCase = createGetSharedCodeUseCase(repository)

      const result = await useCase.execute({ shareId: 'abc123' })

      expect(result.code).toBe(mockCode)
      expect(repository.getByShareId).toHaveBeenCalledWith('abc123')
    })

    it('should throw NotFoundError when share does not exist', async () => {
      const repository = createMockRepository({
        getByShareId: vi.fn().mockResolvedValue(null)
      })
      const useCase = createGetSharedCodeUseCase(repository)

      await expect(useCase.execute({ shareId: 'notfound' })).rejects.toThrow(
        'Shared code not found or expired'
      )
    })

    it('should throw NotFoundError for empty shareId', async () => {
      const repository = createMockRepository()
      const useCase = createGetSharedCodeUseCase(repository)

      await expect(useCase.execute({ shareId: '' })).rejects.toThrow(
        'Share ID is required'
      )
    })

    it('should throw NotFoundError for whitespace-only shareId', async () => {
      const repository = createMockRepository()
      const useCase = createGetSharedCodeUseCase(repository)

      await expect(useCase.execute({ shareId: '   ' })).rejects.toThrow(
        'Share ID is required'
      )
    })

    it('should propagate repository errors', async () => {
      const repository = createMockRepository({
        getByShareId: vi.fn().mockRejectedValue(new Error('Network error'))
      })
      const useCase = createGetSharedCodeUseCase(repository)

      await expect(useCase.execute({ shareId: 'abc123' })).rejects.toThrow(
        'Network error'
      )
    })
  })
})
