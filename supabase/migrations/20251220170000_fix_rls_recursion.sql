-- Fix RLS recursion issues and user_profiles access

-- First, fix user_profiles policies - add INSERT policy for user creation
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Fix projects RLS policies to avoid recursion with project_dependencies
-- The issue is that when fetching dependencies (which are also projects),
-- the RLS policies are evaluated again, causing infinite recursion.

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own projects" ON projects;
DROP POLICY IF EXISTS "Users can view public projects" ON projects;
DROP POLICY IF EXISTS "Users can view shared projects" ON projects;

-- Create a helper function to check project visibility WITHOUT causing recursion
CREATE OR REPLACE FUNCTION public.can_view_project(project_id uuid, requesting_user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM projects p
    WHERE p.id = project_id
    AND (
      -- Owner can view
      p.user_id = requesting_user_id
      -- Public projects
      OR p.visibility = 'public'
      -- Shared projects where user is in project_shares
      OR (
        p.visibility = 'shared'
        AND EXISTS (
          SELECT 1 FROM project_shares ps
          WHERE ps.project_id = p.id
          AND ps.user_id = requesting_user_id
        )
      )
      -- Library projects can be viewed by anyone
      OR p.is_library = true
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Create simplified RLS policy using the function
CREATE POLICY "Users can view accessible projects"
  ON projects FOR SELECT
  TO authenticated
  USING (
    -- Owner can view
    user_id = auth.uid()
    -- Public projects
    OR visibility = 'public'
    -- Shared projects
    OR (
      visibility = 'shared'
      AND EXISTS (
        SELECT 1 FROM project_shares ps
        WHERE ps.project_id = projects.id
        AND ps.user_id = auth.uid()
      )
    )
    -- Library projects (for dependencies)
    OR is_library = true
  );

-- Keep other project policies
CREATE POLICY "Users can insert own projects"
  ON projects FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own projects"
  ON projects FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can delete own projects"
  ON projects FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

-- Grant execute permission on the helper function
GRANT EXECUTE ON FUNCTION public.can_view_project TO authenticated;
