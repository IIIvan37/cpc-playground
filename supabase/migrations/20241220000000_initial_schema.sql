-- Visibility enum
create type project_visibility as enum ('private', 'public', 'shared');

-- User profiles table (extends auth.users)
create table user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  
  -- Username constraints
  constraint username_length check (char_length(username) >= 3 and char_length(username) <= 30),
  constraint username_format check (username ~* '^[a-z0-9_-]+$')
);

-- Tags table
create table tags (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz default now() not null,
  
  -- Tag constraints
  constraint tag_length check (char_length(name) >= 2 and char_length(name) <= 30),
  constraint tag_format check (name ~* '^[a-z0-9-]+$')
);

-- Projects table
create table projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null default auth.uid(),
  name text not null,
  description text,
  visibility project_visibility default 'private' not null,
  is_library boolean default false not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Project files table
create table project_files (
  id uuid primary key default gen_random_uuid(),
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

-- Project shares table (for shared projects with specific users)
create table project_shares (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete cascade not null,
  created_at timestamptz default now() not null,
  
  -- Ensure a user is shared on a project only once
  unique(project_id, user_id)
);

-- Project tags table (many-to-many relationship)
create table project_tags (
  project_id uuid references projects(id) on delete cascade not null,
  tag_id uuid references tags(id) on delete cascade not null,
  created_at timestamptz default now() not null,
  
  primary key (project_id, tag_id)
);

-- Project dependencies table (projects can depend on other projects)
create table project_dependencies (
  project_id uuid references projects(id) on delete cascade not null,
  dependency_id uuid references projects(id) on delete cascade not null,
  created_at timestamptz default now() not null,
  
  primary key (project_id, dependency_id),
  
  -- Prevent self-reference
  constraint no_self_dependency check (project_id != dependency_id)
);

-- Indexes for performance
create index user_profiles_username_idx on user_profiles(username);
create index tags_name_idx on tags(name);
create index projects_user_id_idx on projects(user_id);
create index projects_visibility_idx on projects(visibility);
create index project_files_project_id_idx on project_files(project_id);
create index project_files_is_main_idx on project_files(is_main);
create index project_shares_project_id_idx on project_shares(project_id);
create index project_shares_user_id_idx on project_shares(user_id);
create index project_tags_project_id_idx on project_tags(project_id);
create index project_tags_tag_id_idx on project_tags(tag_id);
create index project_dependencies_project_id_idx on project_dependencies(project_id);
create index project_dependencies_dependency_id_idx on project_dependencies(dependency_id);

-- Enable Row Level Security
alter table user_profiles enable row level security;
alter table tags enable row level security;
alter table projects enable row level security;
alter table project_files enable row level security;
alter table project_shares enable row level security;
alter table project_tags enable row level security;
alter table project_dependencies enable row level security;

-- RLS Policies for user_profiles
create policy "Users can view all profiles"
  on user_profiles for select
  using (true);

create policy "Users can update their own profile"
  on user_profiles for update
  using (auth.uid() = id);

create policy "Users can insert their own profile"
  on user_profiles for insert
  with check (auth.uid() = id);

-- RLS Policies for tags
create policy "Anyone can view tags"
  on tags for select
  using (true);

create policy "Authenticated users can create tags"
  on tags for insert
  with check (auth.uid() is not null);

-- RLS Policies for projects
create policy "Users can view their own projects"
  on projects for select
  using (auth.uid() = user_id);

create policy "Users can view public projects"
  on projects for select
  using (visibility = 'public');

create policy "Users can view projects shared with them"
  on projects for select
  using (
    visibility = 'shared'
    and exists (
      select 1 from project_shares
      where project_shares.project_id = projects.id
      and project_shares.user_id = auth.uid()
    )
  );

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

create policy "Users can view files from public projects"
  on project_files for select
  using (
    exists (
      select 1 from projects
      where projects.id = project_files.project_id
      and projects.visibility = 'public'
    )
  );

create policy "Users can view files from shared projects"
  on project_files for select
  using (
    exists (
      select 1 from projects
      join project_shares on projects.id = project_shares.project_id
      where projects.id = project_files.project_id
      and projects.visibility = 'shared'
      and project_shares.user_id = auth.uid()
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

-- RLS Policies for project_shares
create policy "Project owners can view shares"
  on project_shares for select
  using (
    exists (
      select 1 from projects
      where projects.id = project_shares.project_id
      and projects.user_id = auth.uid()
    )
  );

create policy "Project owners can create shares"
  on project_shares for insert
  with check (
    exists (
      select 1 from projects
      where projects.id = project_shares.project_id
      and projects.user_id = auth.uid()
    )
  );

create policy "Project owners can delete shares"
  on project_shares for delete
  using (
    exists (
      select 1 from projects
      where projects.id = project_shares.project_id
      and projects.user_id = auth.uid()
    )
  );

-- RLS Policies for project_tags
create policy "Anyone can view project tags"
  on project_tags for select
  using (true);

create policy "Project owners can manage tags"
  on project_tags for all
  using (
    exists (
      select 1 from projects
      where projects.id = project_tags.project_id
      and projects.user_id = auth.uid()
    )
  );

-- RLS Policies for project_dependencies
create policy "Anyone can view dependencies of visible projects"
  on project_dependencies for select
  using (
    exists (
      select 1 from projects
      where projects.id = project_dependencies.project_id
      and (
        projects.user_id = auth.uid()
        or projects.visibility = 'public'
        or (
          projects.visibility = 'shared'
          and exists (
            select 1 from project_shares
            where project_shares.project_id = projects.id
            and project_shares.user_id = auth.uid()
          )
        )
      )
    )
  );

create policy "Project owners can manage dependencies"
  on project_dependencies for all
  using (
    exists (
      select 1 from projects
      where projects.id = project_dependencies.project_id
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
create trigger update_user_profiles_updated_at
  before update on user_profiles
  for each row
  execute function update_updated_at_column();

create trigger update_projects_updated_at
  before update on projects
  for each row
  execute function update_updated_at_column();

create trigger update_project_files_updated_at
  before update on project_files
  for each row
  execute function update_updated_at_column();

-- Function to handle new user signup
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.user_profiles (id, username)
  values (
    new.id,
    -- Generate a default username from email (before @) or use a UUID if no email
    coalesce(
      regexp_replace(split_part(new.email, '@', 1), '[^a-z0-9_-]', '', 'gi'),
      'user_' || substring(new.id::text, 1, 8)
    )
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger to create profile on signup
create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function handle_new_user();
