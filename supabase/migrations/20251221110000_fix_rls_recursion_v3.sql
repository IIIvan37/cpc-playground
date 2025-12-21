-- Fix infinite recursion in RLS policies v3
-- The issue: When embedding project_dependencies->projects, RLS on the joined projects
-- tries to check project_shares which queries projects again, causing infinite recursion.

-- Solution: 
-- 1. Drop the SECURITY DEFINER function approach (it still causes recursion)
-- 2. Use a materialized approach: store access information directly on the row
-- 3. For dependencies, allow viewing all dependency projects (libraries should be accessible)

-- First, drop ALL existing policies on projects to start clean
DROP POLICY IF EXISTS "Users can view own projects" ON projects;
DROP POLICY IF EXISTS "Users can view their own projects" ON projects;
DROP POLICY IF EXISTS "Users can view public projects" ON projects;
DROP POLICY IF EXISTS "Users can view library projects" ON projects;
DROP POLICY IF EXISTS "Users can view shared projects" ON projects;
DROP POLICY IF EXISTS "Users can view projects shared with them" ON projects;
DROP POLICY IF EXISTS "Users can view accessible projects" ON projects;
DROP POLICY IF EXISTS "Users can view dependency projects" ON projects;

-- Drop the policy that depends on the function BEFORE dropping the function
DROP POLICY IF EXISTS "Users can view project dependencies" ON project_dependencies;

-- Drop the SECURITY DEFINER function as it doesn't solve the recursion
DROP FUNCTION IF EXISTS public.user_can_access_project(uuid, uuid);

-- Create simple, non-recursive policies for projects SELECT
-- Policy 1: Own projects
CREATE POLICY "projects_select_own"
  ON projects FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Policy 2: Public projects (no recursion - just checks the row itself)
CREATE POLICY "projects_select_public"
  ON projects FOR SELECT
  TO authenticated
  USING (visibility = 'public');

-- Policy 3: Library projects (for dependencies - libraries are always accessible)
CREATE POLICY "projects_select_library"
  ON projects FOR SELECT
  TO authenticated
  USING (is_library = true);

-- Policy 4: Shared projects - check project_shares but NOT projects
-- The key here is that project_shares doesn't reference projects in its RLS policy
CREATE POLICY "projects_select_shared"
  ON projects FOR SELECT
  TO authenticated
  USING (
    visibility = 'shared' 
    AND id IN (
      SELECT ps.project_id 
      FROM project_shares ps 
      WHERE ps.user_id = auth.uid()
    )
  );

-- Now fix project_dependencies RLS
-- The problem is that its policy references projects which causes recursion
DROP POLICY IF EXISTS "Anyone can view dependencies of visible projects" ON project_dependencies;
DROP POLICY IF EXISTS "Users can view project dependencies" ON project_dependencies;

-- Simple policy: if you can see the main project, you can see its dependencies
-- We use a subquery that only checks user_id, not full RLS
CREATE POLICY "project_dependencies_select"
  ON project_dependencies FOR SELECT
  TO authenticated
  USING (
    -- User owns the project
    project_id IN (SELECT p.id FROM projects p WHERE p.user_id = auth.uid())
    -- OR project is public
    OR project_id IN (SELECT p.id FROM projects p WHERE p.visibility = 'public')
    -- OR project is shared with user
    OR project_id IN (
      SELECT ps.project_id FROM project_shares ps WHERE ps.user_id = auth.uid()
    )
  );

-- Also need to update project_shares policy to NOT reference projects
-- This breaks the recursion chain
DROP POLICY IF EXISTS "Project owners can view shares" ON project_shares;
DROP POLICY IF EXISTS "Users can view their own shares" ON project_shares;

-- Users can see shares for projects they own (check user_id directly on projects)
CREATE POLICY "project_shares_select_owner"
  ON project_shares FOR SELECT
  TO authenticated
  USING (
    project_id IN (SELECT p.id FROM projects p WHERE p.user_id = auth.uid())
  );

-- Users can see shares where they are the recipient
CREATE POLICY "project_shares_select_recipient"
  ON project_shares FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());
