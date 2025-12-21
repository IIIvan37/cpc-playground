-- Simplify RLS: minimal DB-level security, complex logic in application code
-- This approach avoids recursion issues and is easier to maintain/debug

-- ============================================================================
-- PROJECTS: Simple owner-based RLS only
-- ============================================================================
DROP POLICY IF EXISTS "projects_select_own" ON projects;
DROP POLICY IF EXISTS "projects_select_public" ON projects;
DROP POLICY IF EXISTS "projects_select_library" ON projects;
DROP POLICY IF EXISTS "projects_select_shared" ON projects;
DROP POLICY IF EXISTS "Users can view their own projects" ON projects;
DROP POLICY IF EXISTS "Users can view public projects" ON projects;
DROP POLICY IF EXISTS "Users can view projects shared with them" ON projects;
DROP POLICY IF EXISTS "Users can create their own projects" ON projects;
DROP POLICY IF EXISTS "Users can update their own projects" ON projects;
DROP POLICY IF EXISTS "Users can delete their own projects" ON projects;

-- Simple policies: authenticated users can do everything on their own projects
-- Public/shared access will be handled in application code
CREATE POLICY "projects_owner_select" ON projects FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR visibility = 'public' OR is_library = true);

CREATE POLICY "projects_owner_insert" ON projects FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "projects_owner_update" ON projects FOR UPDATE TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "projects_owner_delete" ON projects FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- ============================================================================
-- PROJECT_FILES: Follow project ownership
-- ============================================================================
DROP POLICY IF EXISTS "Users can view files from their own projects" ON project_files;
DROP POLICY IF EXISTS "Users can view files from public projects" ON project_files;
DROP POLICY IF EXISTS "Users can view files from shared projects" ON project_files;
DROP POLICY IF EXISTS "Users can create files in their own projects" ON project_files;
DROP POLICY IF EXISTS "Users can update files in their own projects" ON project_files;
DROP POLICY IF EXISTS "Users can delete files from their own projects" ON project_files;

-- Allow all operations for authenticated users - project ownership checked in app
CREATE POLICY "project_files_select" ON project_files FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_files_insert" ON project_files FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_files_update" ON project_files FOR UPDATE TO authenticated USING (true);
CREATE POLICY "project_files_delete" ON project_files FOR DELETE TO authenticated USING (true);

-- ============================================================================
-- PROJECT_SHARES: Simple access
-- ============================================================================
DROP POLICY IF EXISTS "project_shares_select_owner" ON project_shares;
DROP POLICY IF EXISTS "project_shares_select_recipient" ON project_shares;
DROP POLICY IF EXISTS "Project owners can view shares" ON project_shares;
DROP POLICY IF EXISTS "Project owners can create shares" ON project_shares;
DROP POLICY IF EXISTS "Project owners can delete shares" ON project_shares;

CREATE POLICY "project_shares_select" ON project_shares FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_shares_insert" ON project_shares FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_shares_delete" ON project_shares FOR DELETE TO authenticated USING (true);

-- ============================================================================
-- PROJECT_DEPENDENCIES: Open access (dependencies are just references)
-- ============================================================================
DROP POLICY IF EXISTS "project_dependencies_select" ON project_dependencies;
DROP POLICY IF EXISTS "Anyone can view dependencies of visible projects" ON project_dependencies;
DROP POLICY IF EXISTS "Project owners can manage dependencies" ON project_dependencies;

CREATE POLICY "project_dependencies_select" ON project_dependencies FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_dependencies_insert" ON project_dependencies FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_dependencies_delete" ON project_dependencies FOR DELETE TO authenticated USING (true);

-- ============================================================================
-- PROJECT_TAGS: Open access
-- ============================================================================
DROP POLICY IF EXISTS "Anyone can view project tags" ON project_tags;
DROP POLICY IF EXISTS "Project owners can manage tags" ON project_tags;

CREATE POLICY "project_tags_select" ON project_tags FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_tags_all" ON project_tags FOR ALL TO authenticated USING (true);
