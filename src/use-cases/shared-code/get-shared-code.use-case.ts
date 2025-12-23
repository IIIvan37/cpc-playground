import { NotFoundError } from '@/domain/errors'
import type { ISharedCodeRepository } from '@/domain/repositories/shared-code.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type GetSharedCodeInput = {
  shareId: string
}

export type GetSharedCodeOutput = {
  code: string
}

export type GetSharedCodeUseCase = {
  execute(input: GetSharedCodeInput): Promise<GetSharedCodeOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createGetSharedCodeUseCase(
  sharedCodeRepository: ISharedCodeRepository
): GetSharedCodeUseCase {
  return {
    async execute(input: GetSharedCodeInput): Promise<GetSharedCodeOutput> {
      const { shareId } = input

      if (!shareId.trim()) {
        throw new NotFoundError('Share ID is required')
      }

      const code = await sharedCodeRepository.getByShareId(shareId)

      if (code === null) {
        throw new NotFoundError(`Shared code not found or expired: ${shareId}`)
      }

      return { code }
    }
  }
}
