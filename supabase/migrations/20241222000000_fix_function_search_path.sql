-- ============================================================================
-- Fix function search_path security warnings
-- https://supabase.com/docs/guides/database/database-linter?lint=0011_function_search_path_mutable
-- ============================================================================

-- Fix update_updated_at_column function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  new.updated_at = now();
  RETURN new;
END;
$$;

-- Fix handle_new_user function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
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
$$;

-- Fix can_view_project function (if it exists)
-- This function may have been created manually in Supabase
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'can_view_project'
  ) THEN
    -- Drop and recreate with search_path set
    -- Note: You may need to adjust this based on the actual function definition
    EXECUTE 'ALTER FUNCTION public.can_view_project SET search_path = ''''';
  END IF;
END;
$$;
