/**
 * Repository interface for shared code snippets
 * These are temporary code shares via URL (not project sharing)
 */
export interface ISharedCodeRepository {
  /**
   * Get a shared code snippet by its ID
   * @param shareId - The unique share identifier
   * @returns The code string or null if not found/expired
   */
  getByShareId(shareId: string): Promise<string | null>

  /**
   * Create a new shared code snippet
   * @param code - The code to share
   * @returns The share ID
   */
  create(code: string): Promise<string>
}
