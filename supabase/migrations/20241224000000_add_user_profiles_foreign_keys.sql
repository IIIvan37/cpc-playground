-- Add foreign keys to user_profiles for JOIN support
-- This allows Supabase to automatically resolve relations in SELECT queries

-- Add FK from projects.user_id to user_profiles.id (for author username)
ALTER TABLE projects 
ADD CONSTRAINT projects_user_id_fkey_user_profiles 
FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

-- Add FK from project_shares.user_id to user_profiles.id (for share usernames)
ALTER TABLE project_shares 
ADD CONSTRAINT project_shares_user_id_fkey_user_profiles 
FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;
