import type { SupabaseClient } from '@supabase/supabase-js'
import type { User, UserProfile } from '@/domain/entities/user.entity'
import { createUser, createUserProfile } from '@/domain/entities/user.entity'
import type {
  AuthResult,
  AuthStateCallback,
  IAuthRepository,
  OAuthProvider,
  SignInCredentials,
  SignUpCredentials,
  Unsubscribe
} from '@/domain/repositories/auth.repository.interface'
import { createLogger } from '@/lib/logger'
import type { Database } from '@/types/database.types'

type UserProfileRow = Database['public']['Tables']['user_profiles']['Row']

/**
 * Map Supabase user to domain User
 */
function mapToDomainUser(
  supabaseUser: { id: string; email?: string },
  profile?: UserProfile
): User {
  return createUser({
    id: supabaseUser.id,
    email: supabaseUser.email ?? '',
    profile: profile
      ? {
          id: profile.id,
          username: profile.username,
          createdAt: profile.createdAt,
          updatedAt: profile.updatedAt
        }
      : undefined
  })
}

/**
 * Map Supabase profile row to domain UserProfile
 */
function mapToUserProfile(row: UserProfileRow): UserProfile {
  return createUserProfile({
    id: row.id,
    username: row.username,
    createdAt: new Date(row.created_at),
    updatedAt: new Date(row.updated_at)
  })
}

/**
 * Factory function that creates a Supabase implementation of IAuthRepository
 */
export function createSupabaseAuthRepository(
  supabase: SupabaseClient<Database>
): IAuthRepository {
  const logger = createLogger('SupabaseAuthRepository')

  return {
    async signIn(credentials: SignInCredentials): Promise<AuthResult> {
      try {
        const { data, error } = await supabase.auth.signInWithPassword({
          email: credentials.email,
          password: credentials.password
        })

        if (error) {
          return { user: null, error: new Error(error.message) }
        }

        if (!data.user) {
          return { user: null, error: null }
        }

        return {
          user: mapToDomainUser(data.user),
          error: null
        }
      } catch (error) {
        return {
          user: null,
          error: error instanceof Error ? error : new Error('Failed to sign in')
        }
      }
    },

    async signUp(credentials: SignUpCredentials): Promise<AuthResult> {
      try {
        const { data, error } = await supabase.auth.signUp({
          email: credentials.email,
          password: credentials.password,
          options: {
            data: credentials.username ? { username: credentials.username } : {}
          }
        })

        if (error) {
          return { user: null, error: new Error(error.message) }
        }

        if (!data.user) {
          return { user: null, error: null }
        }

        return {
          user: mapToDomainUser(data.user),
          error: null
        }
      } catch (error) {
        return {
          user: null,
          error: error instanceof Error ? error : new Error('Failed to sign up')
        }
      }
    },

    async signOut(): Promise<{ error: Error | null }> {
      try {
        const { error } = await supabase.auth.signOut({ scope: 'local' })
        // Ignore 403 errors as the session is already invalid
        if (error && !error.message.includes('403')) {
          return { error: new Error(error.message) }
        }
        return { error: null }
      } catch (error) {
        // Ignore network errors, session will be cleared locally anyway
        logger.warn('SignOut error (ignored)', error)
        return { error: null }
      }
    },

    async signInWithOAuth(provider: OAuthProvider): Promise<AuthResult> {
      try {
        const { error } = await supabase.auth.signInWithOAuth({
          provider,
          options: {
            redirectTo: globalThis.location.origin
          }
        })

        if (error) {
          return { user: null, error: new Error(error.message) }
        }

        // OAuth redirects, so no immediate user
        return { user: null, error: null }
      } catch (error) {
        return {
          user: null,
          error:
            error instanceof Error
              ? error
              : new Error(`Failed to sign in with ${provider}`)
        }
      }
    },

    async getCurrentUser(): Promise<User | null> {
      try {
        const {
          data: { user },
          error
        } = await supabase.auth.getUser()

        if (error || !user) {
          return null
        }

        return mapToDomainUser(user)
      } catch {
        return null
      }
    },

    onAuthStateChange(callback: AuthStateCallback): Unsubscribe {
      const {
        data: { subscription }
      } = supabase.auth.onAuthStateChange((event, session) => {
        // Handle token refresh failure - treat as signed out
        if (event === 'TOKEN_REFRESHED' && !session) {
          logger.warn('Token refresh failed, signing out')
          callback(null)
          return
        }

        // Handle explicit sign out
        if (event === 'SIGNED_OUT') {
          callback(null)
          return
        }

        const user = session?.user ? mapToDomainUser(session.user) : null
        callback(user)
      })

      return () => subscription.unsubscribe()
    },

    async getUserProfile(userId: string): Promise<UserProfile | null> {
      try {
        const { data, error } = await supabase
          .from('user_profiles')
          .select('*')
          .eq('id', userId)
          .single()

        if (error) {
          logger.error('Failed to fetch user profile', error)
          return null
        }

        if (!data) return null

        return mapToUserProfile(data)
      } catch (error) {
        logger.error('Failed to fetch user profile', error)
        return null
      }
    },

    async updateUserProfile(
      userId: string,
      updates: { username?: string }
    ): Promise<{ error: Error | null }> {
      try {
        const { error } = await supabase
          .from('user_profiles')
          .update(updates)
          .eq('id', userId)

        if (error) {
          return { error: new Error(error.message) }
        }

        return { error: null }
      } catch (error) {
        return {
          error:
            error instanceof Error
              ? error
              : new Error('Failed to update profile')
        }
      }
    },

    async resetPasswordForEmail(
      email: string,
      redirectTo?: string
    ): Promise<{ error: Error | null }> {
      try {
        const { error } = await supabase.auth.resetPasswordForEmail(email, {
          redirectTo:
            redirectTo ?? `${globalThis.location.origin}/reset-password`
        })

        if (error) {
          return { error: new Error(error.message) }
        }

        return { error: null }
      } catch (error) {
        return {
          error:
            error instanceof Error
              ? error
              : new Error('Failed to send password reset email')
        }
      }
    },

    async updatePassword(
      newPassword: string
    ): Promise<{ error: Error | null }> {
      try {
        const { error } = await supabase.auth.updateUser({
          password: newPassword
        })

        if (error) {
          return { error: new Error(error.message) }
        }

        return { error: null }
      } catch (error) {
        return {
          error:
            error instanceof Error
              ? error
              : new Error('Failed to update password')
        }
      }
    },

    async hasSession(): Promise<boolean> {
      try {
        const {
          data: { session }
        } = await supabase.auth.getSession()
        return session !== null
      } catch {
        return false
      }
    },

    onPasswordRecovery(callback: () => void): Unsubscribe {
      const {
        data: { subscription }
      } = supabase.auth.onAuthStateChange((event) => {
        if (event === 'PASSWORD_RECOVERY') {
          callback()
        }
      })

      return () => subscription.unsubscribe()
    }
  }
}
