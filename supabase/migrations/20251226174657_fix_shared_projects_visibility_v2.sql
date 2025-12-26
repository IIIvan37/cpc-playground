-- Fix projects select policy to allow viewing shared projects
-- This migration handles both cases: when the policy exists and when it doesn't

-- Drop the old policy if it exists
DROP POLICY IF EXISTS "projects_select" ON projects;

-- Create new policy that includes shared projects
CREATE POLICY "projects_select" ON projects FOR SELECT TO authenticated
  USING (
    user_id = auth.uid()
    OR visibility = 'public'
    OR is_library = true
    OR EXISTS (
      SELECT 1 FROM project_shares
      WHERE project_shares.project_id = projects.id
      AND project_shares.user_id = auth.uid()
    )
  );