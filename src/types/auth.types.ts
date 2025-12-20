import type { User } from '@supabase/supabase-js'

export interface UserProfile {
  id: string
  username: string
  createdAt: string
  updatedAt: string
}

export interface AuthUser extends User {
  profile?: UserProfile
}

export interface SignInCredentials {
  email: string
  password: string
}

export interface SignUpCredentials extends SignInCredentials {
  username?: string
}

export interface AuthError {
  message: string
  status?: number
}

export interface AuthResponse {
  user: AuthUser | null
  error: AuthError | null
}
