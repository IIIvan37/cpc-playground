-- Fix project_files RLS policies
-- Problem: Current policies only allow users to see files from their OWN projects
-- Solution: Allow authenticated users to read ALL files (authorization handled in app code)
--           Allow anonymous users to read files from PUBLIC projects only

-- Drop ALL existing SELECT policies (including the incorrectly named ones from production)
DROP POLICY IF EXISTS "project_files_select" ON project_files;
DROP POLICY IF EXISTS "project_files_select_anon" ON project_files;
DROP POLICY IF EXISTS "Users can view files from their own projects" ON project_files;

-- Recreate the policy for authenticated users
-- Open read access - authorization is handled in application code
-- This allows users to view files from public projects and shared projects
CREATE POLICY "project_files_select" ON project_files FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_files.project_id
      AND (
        projects.user_id = auth.uid()           -- Own projects
        OR projects.visibility = 'public'        -- Public projects
        OR projects.is_library = true            -- Library projects
        OR EXISTS (                              -- Shared projects
          SELECT 1 FROM project_shares
          WHERE project_shares.project_id = projects.id
          AND project_shares.user_id = auth.uid()
        )
      )
    )
  );

-- Recreate the policy for anonymous users (only public projects)
CREATE POLICY "project_files_select_anon" ON project_files FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = project_files.project_id 
      AND projects.visibility = 'public'
    )
  );
