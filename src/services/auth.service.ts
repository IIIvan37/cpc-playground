// TODO: Remove @ts-nocheck - Migrate to Clean Architecture use-cases instead of direct Supabase calls
// This file will be replaced by use-cases/auth/* once authentication is migrated
// @ts-nocheck
import { supabase } from '@/lib/supabase'
import type {
  AuthResponse,
  SignInCredentials,
  SignUpCredentials,
  UserProfile
} from '@/types/auth.types'

/**
 * Authentication Service
 * Handles all authentication-related operations with Supabase
 */
export class AuthService {
  /**
   * Sign in with email and password
   */
  async signIn(credentials: SignInCredentials): Promise<AuthResponse> {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: credentials.email,
        password: credentials.password
      })

      if (error) {
        return { user: null, error: { message: error.message } }
      }

      return { user: data.user, error: null }
    } catch (error) {
      return {
        user: null,
        error: {
          message: error instanceof Error ? error.message : 'Failed to sign in'
        }
      }
    }
  }

  /**
   * Sign up with email and password
   */
  async signUp(credentials: SignUpCredentials): Promise<AuthResponse> {
    try {
      const { data, error } = await supabase.auth.signUp({
        email: credentials.email,
        password: credentials.password,
        options: {
          data: credentials.username ? { username: credentials.username } : {}
        }
      })

      if (error) {
        return { user: null, error: { message: error.message } }
      }

      return { user: data.user, error: null }
    } catch (error) {
      return {
        user: null,
        error: {
          message: error instanceof Error ? error.message : 'Failed to sign up'
        }
      }
    }
  }

  /**
   * Sign out current user
   */
  async signOut(): Promise<{ error: { message: string } | null }> {
    try {
      const { error } = await supabase.auth.signOut()
      if (error) {
        return { error: { message: error.message } }
      }
      return { error: null }
    } catch (error) {
      return {
        error: {
          message: error instanceof Error ? error.message : 'Failed to sign out'
        }
      }
    }
  }

  /**
   * Sign in with GitHub OAuth
   */
  async signInWithGithub(): Promise<AuthResponse> {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'github',
        options: {
          redirectTo: window.location.origin
        }
      })

      if (error) {
        return { user: null, error: { message: error.message } }
      }

      return { user: null, error: null } // OAuth redirects, so no immediate user
    } catch (error) {
      return {
        user: null,
        error: {
          message:
            error instanceof Error
              ? error.message
              : 'Failed to sign in with GitHub'
        }
      }
    }
  }

  /**
   * Get current session
   */
  async getSession() {
    const {
      data: { session },
      error
    } = await supabase.auth.getSession()
    return { session, error }
  }

  /**
   * Get current user
   */
  async getUser() {
    const {
      data: { user },
      error
    } = await supabase.auth.getUser()
    return { user, error }
  }

  /**
   * Get user profile by ID
   */
  async getUserProfile(userId: string): Promise<UserProfile | null> {
    try {
      const { data, error } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('id', userId)
        .single()

      if (error) throw error

      return {
        id: data.id,
        username: data.username,
        createdAt: data.created_at,
        updatedAt: data.updated_at
      }
    } catch (error) {
      console.error('Failed to fetch user profile:', error)
      return null
    }
  }

  /**
   * Update user profile
   */
  async updateUserProfile(
    userId: string,
    updates: { username?: string }
  ): Promise<{ error: { message: string } | null }> {
    try {
      const { error } = await supabase
        .from('user_profiles')
        .update(updates)
        .eq('id', userId)

      if (error) {
        return { error: { message: error.message } }
      }

      return { error: null }
    } catch (error) {
      return {
        error: {
          message:
            error instanceof Error ? error.message : 'Failed to update profile'
        }
      }
    }
  }

  /**
   * Subscribe to auth state changes
   */
  onAuthStateChange(callback: (user: any) => void) {
    const {
      data: { subscription }
    } = supabase.auth.onAuthStateChange((_event, session) => {
      callback(session?.user ?? null)
    })
    return subscription
  }
}

// Singleton instance
export const authService = new AuthService()
