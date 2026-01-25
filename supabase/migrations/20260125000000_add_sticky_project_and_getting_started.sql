-- Add is_sticky column to projects table
ALTER TABLE projects ADD COLUMN is_sticky boolean DEFAULT false NOT NULL;

-- Create index for sticky projects
CREATE INDEX projects_is_sticky_idx ON projects(is_sticky) WHERE is_sticky = true;

-- Insert the "Getting Started" example project
-- This will be owned by a system user or the first admin
-- For now, we'll create it without a specific user (will need to be assigned)

-- Note: Run this after deploying the migration to create the example project:
-- 
-- INSERT INTO projects (id, name, description, visibility, is_library, is_sticky, user_id)
-- VALUES (
--   'getting-started-project-id',
--   'Getting Started',
--   'A simple Hello World example to get you started with Z80 assembly on Amstrad CPC',
--   'public',
--   false,
--   true,
--   '<your-user-id>'
-- );
--
-- INSERT INTO project_files (project_id, name, content, is_main, "order")
-- VALUES 
--   ('getting-started-project-id', 'main.asm', '...', true, 0),
--   ('getting-started-project-id', 'getting-started.md', '...', false, 1);
