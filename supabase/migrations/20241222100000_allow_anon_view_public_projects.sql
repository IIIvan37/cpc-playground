-- Migration: Allow anonymous users to view public projects
-- This enables the /explore page to show public projects to non-authenticated users

-- Add policy for anonymous users to view public projects
CREATE POLICY "projects_select_anon" ON projects FOR SELECT TO anon
  USING (visibility = 'public');

-- Also allow anonymous users to view project_files of public projects
CREATE POLICY "project_files_select_anon" ON project_files FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = project_files.project_id 
      AND projects.visibility = 'public'
    )
  );

-- Allow anonymous users to view tags
CREATE POLICY "tags_select_anon" ON tags FOR SELECT TO anon USING (true);

-- Allow anonymous users to view project_tags of public projects
CREATE POLICY "project_tags_select_anon" ON project_tags FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = project_tags.project_id 
      AND projects.visibility = 'public'
    )
  );

-- Allow anonymous users to view project_dependencies of public projects
CREATE POLICY "project_dependencies_select_anon" ON project_dependencies FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = project_dependencies.project_id 
      AND projects.visibility = 'public'
    )
  );

-- Allow anonymous users to view project_shares count (not user details) of public projects
CREATE POLICY "project_shares_select_anon" ON project_shares FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = project_shares.project_id 
      AND projects.visibility = 'public'
    )
  );
