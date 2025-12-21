-- Fix infinite recursion in RLS policies when querying projects with dependencies

-- The problem:
-- When querying projects with project_dependencies, the dependency:projects join
-- triggers RLS evaluation on the joined projects, which then checks project_shares,
-- creating infinite recursion.

-- Solution: Use SECURITY DEFINER functions to bypass RLS for specific checks

-- Drop all existing project SELECT policies
DROP POLICY IF EXISTS "Users can view own projects" ON projects;
DROP POLICY IF EXISTS "Users can view public projects" ON projects;
DROP POLICY IF EXISTS "Users can view library projects" ON projects;
DROP POLICY IF EXISTS "Users can view shared projects" ON projects;

-- Create a SECURITY DEFINER function to check if a user can access a project
-- This function bypasses RLS, preventing the recursion
CREATE OR REPLACE FUNCTION public.user_can_access_project(project_id uuid, user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.projects p
    WHERE p.id = project_id
    AND (
      -- User owns the project
      p.user_id = user_id
      -- Project is public
      OR p.visibility = 'public'
      -- Project is a library
      OR p.is_library = true
      -- User has explicit share access
      OR (
        p.visibility = 'shared' 
        AND EXISTS (
          SELECT 1 FROM public.project_shares ps
          WHERE ps.project_id = p.id AND ps.user_id = user_can_access_project.user_id
        )
      )
    )
  );
$$;

-- Create a single, simple policy using the function
CREATE POLICY "Users can view accessible projects"
  ON projects FOR SELECT
  TO authenticated
  USING (
    user_can_access_project(id, auth.uid())
  );

-- Also update project_dependencies policy to allow viewing dependencies
-- of projects the user can access
DROP POLICY IF EXISTS "Users can view project dependencies" ON project_dependencies;
CREATE POLICY "Users can view project dependencies"
  ON project_dependencies FOR SELECT
  TO authenticated
  USING (
    user_can_access_project(project_id, auth.uid())
  );

-- Allow viewing all projects that are dependencies (they're referenced, so viewable)
-- This is needed for the nested join to work
DROP POLICY IF EXISTS "Users can view dependency projects" ON projects;
CREATE POLICY "Users can view dependency projects"
  ON projects FOR SELECT
  TO authenticated
  USING (
    -- Project is referenced as a dependency by any project the user can access
    EXISTS (
      SELECT 1 FROM public.project_dependencies pd
      WHERE pd.dependency_id = projects.id
    )
  );
