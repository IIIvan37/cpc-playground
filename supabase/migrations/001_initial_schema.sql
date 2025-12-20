-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Projects table
create table projects (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade not null default auth.uid(),
  name text not null,
  description text,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Project files table
create table project_files (
  id uuid primary key default uuid_generate_v4(),
  project_id uuid references projects(id) on delete cascade not null,
  name text not null,
  content text not null,
  is_main boolean default false not null,
  "order" integer default 0 not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  
  -- Ensure file names are unique within a project
  unique(project_id, name)
);

-- Indexes for performance
create index projects_user_id_idx on projects(user_id);
create index project_files_project_id_idx on project_files(project_id);
create index project_files_is_main_idx on project_files(is_main);

-- Enable Row Level Security
alter table projects enable row level security;
alter table project_files enable row level security;

-- RLS Policies for projects
create policy "Users can view their own projects"
  on projects for select
  using (auth.uid() = user_id);

create policy "Users can create their own projects"
  on projects for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own projects"
  on projects for update
  using (auth.uid() = user_id);

create policy "Users can delete their own projects"
  on projects for delete
  using (auth.uid() = user_id);

-- RLS Policies for project_files
create policy "Users can view files from their own projects"
  on project_files for select
  using (
    exists (
      select 1 from projects
      where projects.id = project_files.project_id
      and projects.user_id = auth.uid()
    )
  );

create policy "Users can create files in their own projects"
  on project_files for insert
  with check (
    exists (
      select 1 from projects
      where projects.id = project_files.project_id
      and projects.user_id = auth.uid()
    )
  );

create policy "Users can update files in their own projects"
  on project_files for update
  using (
    exists (
      select 1 from projects
      where projects.id = project_files.project_id
      and projects.user_id = auth.uid()
    )
  );

create policy "Users can delete files from their own projects"
  on project_files for delete
  using (
    exists (
      select 1 from projects
      where projects.id = project_files.project_id
      and projects.user_id = auth.uid()
    )
  );

-- Function to update updated_at timestamp
create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Triggers to auto-update updated_at
create trigger update_projects_updated_at
  before update on projects
  for each row
  execute function update_updated_at_column();

create trigger update_project_files_updated_at
  before update on project_files
  for each row
  execute function update_updated_at_column();
