-- CPC Playground Database Schema
-- This is a clean, consolidated schema

-- ============================================================================
-- ENUMS
-- ============================================================================
CREATE TYPE project_visibility AS ENUM ('private', 'public', 'shared');

-- ============================================================================
-- TABLES
-- ============================================================================

-- User profiles table (extends auth.users)
CREATE TABLE user_profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL,
  
  CONSTRAINT username_length CHECK (char_length(username) >= 3 AND char_length(username) <= 30),
  CONSTRAINT username_format CHECK (username ~ '^[a-z0-9_-]+$')
);

-- Tags table
CREATE TABLE tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  
  CONSTRAINT tag_length CHECK (char_length(name) >= 2 AND char_length(name) <= 30),
  CONSTRAINT tag_format CHECK (name ~ '^[a-z0-9-]+$')
);

-- Projects table
CREATE TABLE projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
  name text NOT NULL,
  description text,
  visibility project_visibility DEFAULT 'private' NOT NULL,
  is_library boolean DEFAULT false NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- Project files table
CREATE TABLE project_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  content text NOT NULL,
  is_main boolean DEFAULT false NOT NULL,
  "order" integer DEFAULT 0 NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL,
  
  UNIQUE(project_id, name)
);

-- Project shares table (for shared projects with specific users)
CREATE TABLE project_shares (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  
  PRIMARY KEY (project_id, user_id)
);

-- Project tags table (many-to-many relationship)
CREATE TABLE project_tags (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  tag_id uuid REFERENCES tags(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  
  PRIMARY KEY (project_id, tag_id)
);

-- Project dependencies table (projects can depend on other projects)
CREATE TABLE project_dependencies (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  dependency_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  
  PRIMARY KEY (project_id, dependency_id),
  CONSTRAINT no_self_dependency CHECK (project_id != dependency_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================
CREATE INDEX user_profiles_username_idx ON user_profiles(username);
CREATE INDEX tags_name_idx ON tags(name);
CREATE INDEX projects_user_id_idx ON projects(user_id);
CREATE INDEX projects_visibility_idx ON projects(visibility);
CREATE INDEX project_files_project_id_idx ON project_files(project_id);
CREATE INDEX project_files_is_main_idx ON project_files(is_main);
CREATE INDEX project_shares_project_id_idx ON project_shares(project_id);
CREATE INDEX project_shares_user_id_idx ON project_shares(user_id);
CREATE INDEX project_tags_project_id_idx ON project_tags(project_id);
CREATE INDEX project_tags_tag_id_idx ON project_tags(tag_id);
CREATE INDEX project_dependencies_project_id_idx ON project_dependencies(project_id);
CREATE INDEX project_dependencies_dependency_id_idx ON project_dependencies(dependency_id);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_dependencies ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- RLS POLICIES
-- Note: Complex authorization logic is handled in application code.
-- DB-level RLS provides basic protection only.
-- ============================================================================

-- USER_PROFILES
CREATE POLICY "user_profiles_select" ON user_profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "user_profiles_insert" ON user_profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);
CREATE POLICY "user_profiles_update" ON user_profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- TAGS
CREATE POLICY "tags_select" ON tags FOR SELECT TO authenticated USING (true);
CREATE POLICY "tags_insert" ON tags FOR INSERT TO authenticated WITH CHECK (true);

-- PROJECTS
-- Owner can do everything, others can view public/library projects
CREATE POLICY "projects_select" ON projects FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR visibility = 'public' OR is_library = true);
CREATE POLICY "projects_insert" ON projects FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());
CREATE POLICY "projects_update" ON projects FOR UPDATE TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "projects_delete" ON projects FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- PROJECT_FILES
-- Open access - authorization handled in application code
CREATE POLICY "project_files_select" ON project_files FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_files_insert" ON project_files FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_files_update" ON project_files FOR UPDATE TO authenticated USING (true);
CREATE POLICY "project_files_delete" ON project_files FOR DELETE TO authenticated USING (true);

-- PROJECT_SHARES
CREATE POLICY "project_shares_select" ON project_shares FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_shares_insert" ON project_shares FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_shares_delete" ON project_shares FOR DELETE TO authenticated USING (true);

-- PROJECT_DEPENDENCIES
CREATE POLICY "project_dependencies_select" ON project_dependencies FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_dependencies_insert" ON project_dependencies FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "project_dependencies_delete" ON project_dependencies FOR DELETE TO authenticated USING (true);

-- PROJECT_TAGS
CREATE POLICY "project_tags_select" ON project_tags FOR SELECT TO authenticated USING (true);
CREATE POLICY "project_tags_all" ON project_tags FOR ALL TO authenticated USING (true);

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS trigger AS $$
BEGIN
  new.updated_at = now();
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- Function to handle new user signup with unique username generation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
DECLARE
  base_username text;
  final_username text;
  counter int := 0;
BEGIN
  -- Generate base username from email (before @), removing invalid chars
  base_username := lower(regexp_replace(split_part(new.email, '@', 1), '[^a-z0-9_-]', '', 'gi'));
  
  -- Ensure minimum length of 3 characters
  IF length(base_username) < 3 THEN
    base_username := 'user_' || substring(new.id::text, 1, 8);
  END IF;
  
  -- Truncate if too long (max 30 chars, leave room for suffix)
  IF length(base_username) > 25 THEN
    base_username := substring(base_username, 1, 25);
  END IF;
  
  final_username := base_username;
  
  -- Check for uniqueness and add suffix if needed
  WHILE EXISTS (SELECT 1 FROM public.user_profiles WHERE username = final_username) LOOP
    counter := counter + 1;
    final_username := base_username || '_' || counter::text;
  END LOOP;
  
  INSERT INTO public.user_profiles (id, username)
  VALUES (new.id, final_username);
  
  RETURN new;
EXCEPTION
  WHEN others THEN
    -- Log error but don't block user creation
    RAISE WARNING 'Failed to create user profile for %: %', new.id, sqlerrm;
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Auto-update updated_at timestamps
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_files_updated_at
  BEFORE UPDATE ON project_files
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create user profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();
