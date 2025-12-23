-- Allow anonymous users to view user profiles (for displaying author usernames)
-- This is needed so anonymous users can see who created public projects

CREATE POLICY "user_profiles_select_anon" ON user_profiles 
FOR SELECT 
TO anon 
USING (true);
