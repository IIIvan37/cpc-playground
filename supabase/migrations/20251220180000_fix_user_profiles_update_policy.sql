-- Fix user_profiles UPDATE policy to include WITH CHECK clause

-- The issue: UPDATE policy only has USING clause but no WITH CHECK
-- This causes 400 Bad Request when trying to update the profile

DROP POLICY IF EXISTS "Users can update own profile" ON user_profiles;
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);
