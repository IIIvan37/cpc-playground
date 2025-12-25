import type { User, UserProfile } from '../entities/user.entity'

/**
 * Credentials for email/password sign in
 */
export type SignInCredentials = {
  email: string
  password: string
}

/**
 * Credentials for email/password sign up
 */
export type SignUpCredentials = {
  email: string
  password: string
  username?: string
}

/**
 * OAuth providers supported
 */
export type OAuthProvider = 'github' | 'google'

/**
 * Authentication result
 */
export type AuthResult = {
  user: User | null
  error: Error | null
}

/**
 * Auth state change callback
 */
export type AuthStateCallback = (user: User | null) => void

/**
 * Unsubscribe function for auth state listener
 */
export type Unsubscribe = () => void

/**
 * Repository interface for Authentication (Port in Hexagonal Architecture)
 * The implementation will be in infrastructure layer (Supabase)
 */
export interface IAuthRepository {
  /**
   * Sign in with email and password
   */
  signIn(credentials: SignInCredentials): Promise<AuthResult>

  /**
   * Sign up with email and password
   */
  signUp(credentials: SignUpCredentials): Promise<AuthResult>

  /**
   * Sign out current user
   */
  signOut(): Promise<{ error: Error | null }>

  /**
   * Sign in with OAuth provider
   */
  signInWithOAuth(provider: OAuthProvider): Promise<AuthResult>

  /**
   * Get current authenticated user
   */
  getCurrentUser(): Promise<User | null>

  /**
   * Subscribe to auth state changes
   */
  onAuthStateChange(callback: AuthStateCallback): Unsubscribe

  /**
   * Get user profile by ID
   */
  getUserProfile(userId: string): Promise<UserProfile | null>

  /**
   * Update user profile
   */
  updateUserProfile(
    userId: string,
    updates: { username?: string }
  ): Promise<{ error: Error | null }>

  /**
   * Send a password reset email
   */
  resetPasswordForEmail(
    email: string,
    redirectTo?: string
  ): Promise<{ error: Error | null }>

  /**
   * Update user's password (for authenticated user after reset link)
   */
  updatePassword(newPassword: string): Promise<{ error: Error | null }>

  /**
   * Check if there is an active session
   */
  hasSession(): Promise<boolean>

  /**
   * Subscribe to password recovery event
   * Called when user clicks the reset link in email
   */
  onPasswordRecovery(callback: () => void): Unsubscribe
}
