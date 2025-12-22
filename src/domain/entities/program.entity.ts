/**
 * Program Entity
 * Represents a locally saved program (localStorage)
 */

import type { ProgramName } from '../value-objects/program-name.vo'

export type Program = Readonly<{
  id: string
  name: ProgramName
  code: string
  createdAt: Date
  updatedAt: Date
}>

type CreateProgramInput = {
  id: string
  name: ProgramName
  code: string
  createdAt?: Date
  updatedAt?: Date
}

export function createProgram(input: CreateProgramInput): Program {
  const now = new Date()
  return Object.freeze({
    id: input.id,
    name: input.name,
    code: input.code,
    createdAt: input.createdAt ?? now,
    updatedAt: input.updatedAt ?? now
  })
}

export function updateProgram(
  program: Program,
  updates: Partial<Pick<Program, 'name' | 'code'>>
): Program {
  return Object.freeze({
    ...program,
    ...(updates.name !== undefined && { name: updates.name }),
    ...(updates.code !== undefined && { code: updates.code }),
    updatedAt: new Date()
  })
}
