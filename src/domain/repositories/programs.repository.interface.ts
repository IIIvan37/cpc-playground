import type { Program } from '../entities/program.entity'

/**
 * Repository interface for Programs (Port in Hexagonal Architecture)
 * The implementation will be in infrastructure layer (localStorage)
 */
export interface IProgramsRepository {
  /**
   * Find all saved programs
   */
  findAll(): Promise<readonly Program[]>

  /**
   * Find a program by ID
   */
  findById(id: string): Promise<Program | null>

  /**
   * Save a program (create or update)
   */
  save(program: Program): Promise<Program>

  /**
   * Delete a program
   */
  delete(id: string): Promise<void>
}
