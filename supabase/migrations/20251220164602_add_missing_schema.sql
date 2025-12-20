-- Add missing columns and tables that weren't created in initial migration

-- Add visibility enum if not exists
DO $$ BEGIN
    CREATE TYPE project_visibility AS ENUM ('private', 'public', 'shared');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Add missing columns to projects table
ALTER TABLE projects 
  ADD COLUMN IF NOT EXISTS visibility project_visibility DEFAULT 'private' NOT NULL,
  ADD COLUMN IF NOT EXISTS is_library boolean DEFAULT false NOT NULL;

-- Create user_profiles table if not exists
CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT username_length CHECK (char_length(username) >= 3 AND char_length(username) <= 30),
  CONSTRAINT username_format CHECK (username ~ '^[a-z0-9_-]+$')
);

-- Create tags table if not exists
CREATE TABLE IF NOT EXISTS tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT tag_length CHECK (char_length(name) >= 2 AND char_length(name) <= 30),
  CONSTRAINT tag_format CHECK (name ~ '^[a-z0-9-]+$')
);

-- Create project_shares table if not exists
CREATE TABLE IF NOT EXISTS project_shares (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  PRIMARY KEY (project_id, user_id)
);

-- Create project_tags table if not exists
CREATE TABLE IF NOT EXISTS project_tags (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  tag_id uuid REFERENCES tags(id) ON DELETE CASCADE NOT NULL,
  PRIMARY KEY (project_id, tag_id)
);

-- Create project_dependencies table if not exists
CREATE TABLE IF NOT EXISTS project_dependencies (
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  dependency_id uuid REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  PRIMARY KEY (project_id, dependency_id),
  CONSTRAINT no_self_dependency CHECK (project_id != dependency_id)
);

-- Enable RLS on new tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_dependencies ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_profiles
DROP POLICY IF EXISTS "Users can view all profiles" ON user_profiles;
CREATE POLICY "Users can view all profiles"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can update own profile" ON user_profiles;
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- RLS Policies for tags
DROP POLICY IF EXISTS "Anyone can view tags" ON tags;
CREATE POLICY "Anyone can view tags"
  ON tags FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Anyone can create tags" ON tags;
CREATE POLICY "Anyone can create tags"
  ON tags FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- RLS Policies for project_shares
DROP POLICY IF EXISTS "Users can view shares for their projects" ON project_shares;
CREATE POLICY "Users can view shares for their projects"
  ON project_shares FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_shares.project_id
      AND projects.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can create shares for their projects" ON project_shares;
CREATE POLICY "Users can create shares for their projects"
  ON project_shares FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_shares.project_id
      AND projects.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can delete shares for their projects" ON project_shares;
CREATE POLICY "Users can delete shares for their projects"
  ON project_shares FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_shares.project_id
      AND projects.user_id = auth.uid()
    )
  );

-- RLS Policies for project_tags
DROP POLICY IF EXISTS "Anyone can view project tags" ON project_tags;
CREATE POLICY "Anyone can view project tags"
  ON project_tags FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can manage tags for their projects" ON project_tags;
CREATE POLICY "Users can manage tags for their projects"
  ON project_tags FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_tags.project_id
      AND projects.user_id = auth.uid()
    )
  );

-- RLS Policies for project_dependencies
DROP POLICY IF EXISTS "Anyone can view dependencies" ON project_dependencies;
CREATE POLICY "Anyone can view dependencies"
  ON project_dependencies FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can manage dependencies for their projects" ON project_dependencies;
CREATE POLICY "Users can manage dependencies for their projects"
  ON project_dependencies FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM projects
      WHERE projects.id = project_dependencies.project_id
      AND projects.user_id = auth.uid()
    )
  );

-- Update existing RLS policies for projects to include visibility
DROP POLICY IF EXISTS "Users can view own projects" ON projects;
DROP POLICY IF EXISTS "Users can view public projects" ON projects;
DROP POLICY IF EXISTS "Users can view shared projects" ON projects;

CREATE POLICY "Users can view own projects"
  ON projects FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can view public projects"
  ON projects FOR SELECT
  TO authenticated
  USING (visibility = 'public');

CREATE POLICY "Users can view shared projects"
  ON projects FOR SELECT
  TO authenticated
  USING (
    visibility = 'shared' AND
    EXISTS (
      SELECT 1 FROM project_shares
      WHERE project_shares.project_id = projects.id
      AND project_shares.user_id = auth.uid()
    )
  );

-- Trigger to auto-create user profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
DECLARE
  base_username text;
  final_username text;
  counter int := 0;
BEGIN
  -- Extract username from email (before @)
  base_username := lower(regexp_replace(split_part(new.email, '@', 1), '[^a-z0-9]', '', 'g'));
  
  -- Ensure minimum length
  IF length(base_username) < 3 THEN
    base_username := 'user' || substring(new.id::text, 1, 6);
  END IF;
  
  -- Find unique username
  final_username := base_username;
  WHILE EXISTS (SELECT 1 FROM user_profiles WHERE username = final_username) LOOP
    counter := counter + 1;
    final_username := base_username || counter;
  END LOOP;
  
  -- Create profile
  INSERT INTO public.user_profiles (id, username)
  VALUES (new.id, final_username);
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_project_shares_user_id ON project_shares(user_id);
CREATE INDEX IF NOT EXISTS idx_project_tags_tag_id ON project_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_project_dependencies_dependency_id ON project_dependencies(dependency_id);
CREATE INDEX IF NOT EXISTS idx_projects_visibility ON projects(visibility);
CREATE INDEX IF NOT EXISTS idx_projects_is_library ON projects(is_library);
