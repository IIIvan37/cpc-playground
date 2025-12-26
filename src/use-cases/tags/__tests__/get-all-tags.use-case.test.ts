import { describe, expect, it, vi } from 'vitest'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createGetAllTagsUseCase } from '../get-all-tags.use-case'

const mockRepository = {
  getAllTags: vi.fn() as any
} as IProjectsRepository

describe('GetAllTagsUseCase', () => {
  it('should return all tags ordered by name', async () => {
    const mockTags = [
      { id: '1', name: 'game' },
      { id: '2', name: 'demo' },
      { id: '3', name: 'utility' }
    ]

    ;(mockRepository.getAllTags as any).mockResolvedValue(mockTags)

    const useCase = createGetAllTagsUseCase(mockRepository)
    const result = await useCase.execute({})

    expect(result).toEqual({ tags: ['game', 'demo', 'utility'] })
    expect(mockRepository.getAllTags as any).toHaveBeenCalled()
  })

  it('should return empty array when no tags exist', async () => {
    ;(mockRepository.getAllTags as any).mockResolvedValue([])

    const useCase = createGetAllTagsUseCase(mockRepository)
    const result = await useCase.execute({})

    expect(result).toEqual({ tags: [] })
  })

  it('should handle database errors', async () => {
    ;(mockRepository.getAllTags as any).mockRejectedValue(
      new Error('Database connection failed')
    )

    const useCase = createGetAllTagsUseCase(mockRepository)

    await expect(useCase.execute({})).rejects.toThrow(
      'Database connection failed'
    )
  })

  it('should handle unexpected errors', async () => {
    ;(mockRepository.getAllTags as any).mockRejectedValue(
      new Error('Network error')
    )

    const useCase = createGetAllTagsUseCase(mockRepository)

    await expect(useCase.execute({})).rejects.toThrow('Network error')
  })
})
