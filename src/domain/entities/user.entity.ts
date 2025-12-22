/**
 * User Entity
 * Represents an authenticated user in the domain
 */

export type UserProfile = Readonly<{
  id: string
  username: string
  createdAt: Date
  updatedAt: Date
}>

export type User = Readonly<{
  id: string
  email: string
  profile?: UserProfile
}>

export type CreateUserParams = {
  id: string
  email: string
  profile?: {
    id: string
    username: string
    createdAt?: Date
    updatedAt?: Date
  }
}

/**
 * Factory function to create a User entity
 */
export function createUser(params: CreateUserParams): User {
  const now = new Date()

  const user: User = {
    id: params.id,
    email: params.email,
    profile: params.profile
      ? Object.freeze({
          id: params.profile.id,
          username: params.profile.username,
          createdAt: params.profile.createdAt ?? now,
          updatedAt: params.profile.updatedAt ?? now
        })
      : undefined
  }

  return Object.freeze(user)
}

/**
 * Factory function to create a UserProfile entity
 */
export function createUserProfile(params: {
  id: string
  username: string
  createdAt?: Date
  updatedAt?: Date
}): UserProfile {
  const now = new Date()

  return Object.freeze({
    id: params.id,
    username: params.username,
    createdAt: params.createdAt ?? now,
    updatedAt: params.updatedAt ?? now
  })
}
