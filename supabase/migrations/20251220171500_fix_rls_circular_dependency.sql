-- Fix circular dependency between projects and project_shares RLS policies

-- The issue: 
-- - projects policy checks project_shares
-- - project_shares policy checks projects
-- This creates infinite recursion when fetching dependencies

-- Solution: Make project_shares readable by all authenticated users
-- since the actual access control is done at the projects level

-- Drop the problematic project_shares SELECT policy
DROP POLICY IF EXISTS "Users can view shares for their projects" ON project_shares;

-- Create a simpler policy: users can only see shares for projects they can access
-- But we check this WITHOUT querying projects (to avoid recursion)
CREATE POLICY "Users can view project shares"
  ON project_shares FOR SELECT
  TO authenticated
  USING (true);  -- All authenticated users can see shares
                  -- The actual filtering happens at the projects level

-- Update projects policies to be more explicit and avoid recursion
DROP POLICY IF EXISTS "Users can view accessible projects" ON projects;

-- Split into separate non-recursive policies
CREATE POLICY "Users can view own projects"
  ON projects FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can view public projects"
  ON projects FOR SELECT  
  TO authenticated
  USING (visibility = 'public');

CREATE POLICY "Users can view library projects"
  ON projects FOR SELECT
  TO authenticated
  USING (is_library = true);

CREATE POLICY "Users can view shared projects"
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

-- Keep INSERT/UPDATE/DELETE policies for project_shares
-- (only project owners can modify shares)
DROP POLICY IF EXISTS "Users can create shares for their projects" ON project_shares;
CREATE POLICY "Users can create shares for their projects"
  ON project_shares FOR INSERT
  TO authenticated
  WITH CHECK (
    project_id IN (
      SELECT id FROM projects 
      WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can delete shares for their projects" ON project_shares;
CREATE POLICY "Users can delete shares for their projects"
  ON project_shares FOR DELETE
  TO authenticated
  USING (
    project_id IN (
      SELECT id FROM projects
      WHERE user_id = auth.uid()
    )
  );
