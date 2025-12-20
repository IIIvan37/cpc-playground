-- Fix handle_new_user to generate unique usernames and handle edge cases
create or replace function handle_new_user()
returns trigger as $$
declare
  base_username text;
  final_username text;
  counter int := 0;
begin
  -- Generate base username from email (before @), removing invalid chars
  base_username := lower(regexp_replace(split_part(new.email, '@', 1), '[^a-z0-9_-]', '', 'gi'));
  
  -- Ensure minimum length of 3 characters
  if length(base_username) < 3 then
    base_username := 'user_' || substring(new.id::text, 1, 8);
  end if;
  
  -- Truncate if too long (max 30 chars, leave room for suffix)
  if length(base_username) > 25 then
    base_username := substring(base_username, 1, 25);
  end if;
  
  final_username := base_username;
  
  -- Check for uniqueness and add suffix if needed
  while exists (select 1 from public.user_profiles where username = final_username) loop
    counter := counter + 1;
    final_username := base_username || '_' || counter::text;
  end loop;
  
  insert into public.user_profiles (id, username)
  values (new.id, final_username);
  
  return new;
exception
  when others then
    -- Log error but don't block user creation
    raise warning 'Failed to create user profile for %: %', new.id, sqlerrm;
    return new;
end;
$$ language plpgsql security definer;
