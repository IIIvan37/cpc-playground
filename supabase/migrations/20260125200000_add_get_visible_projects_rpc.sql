-- RPC function to get visible projects with pagination
-- This avoids the issue of sending hundreds of IDs in the URL query string

CREATE OR REPLACE FUNCTION get_visible_projects_paginated(
  p_user_id uuid DEFAULT NULL,
  p_limit integer DEFAULT 20,
  p_offset integer DEFAULT 0,
  p_search text DEFAULT NULL,
  p_libraries_only boolean DEFAULT FALSE
)
RETURNS TABLE (
  id uuid,
  user_id uuid,
  name text,
  description text,
  visibility project_visibility,
  is_library boolean,
  is_sticky boolean,
  thumbnail_path text,
  created_at timestamptz,
  updated_at timestamptz,
  total_count bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_total bigint;
BEGIN
  -- First, count total visible projects
  SELECT COUNT(DISTINCT p.id) INTO v_total
  FROM projects p
  WHERE (
    -- Anonymous user: only public projects
    (p_user_id IS NULL AND p.visibility = 'public')
    OR
    -- Authenticated user: public + own + shared
    (p_user_id IS NOT NULL AND (
      p.visibility = 'public'
      OR p.user_id = p_user_id
      OR EXISTS (
        SELECT 1 FROM project_shares ps 
        WHERE ps.project_id = p.id AND ps.user_id = p_user_id
      )
    ))
  )
  AND (NOT p_libraries_only OR p.is_library = TRUE)
  AND (
    p_search IS NULL 
    OR p.name ILIKE '%' || p_search || '%'
    OR p.description ILIKE '%' || p_search || '%'
  );

  -- Return paginated results with total count
  RETURN QUERY
  SELECT 
    p.id,
    p.user_id,
    p.name,
    p.description,
    p.visibility,
    p.is_library,
    p.is_sticky,
    p.thumbnail_path,
    p.created_at,
    p.updated_at,
    v_total AS total_count
  FROM projects p
  WHERE (
    -- Anonymous user: only public projects
    (p_user_id IS NULL AND p.visibility = 'public')
    OR
    -- Authenticated user: public + own + shared
    (p_user_id IS NOT NULL AND (
      p.visibility = 'public'
      OR p.user_id = p_user_id
      OR EXISTS (
        SELECT 1 FROM project_shares ps 
        WHERE ps.project_id = p.id AND ps.user_id = p_user_id
      )
    ))
  )
  AND (NOT p_libraries_only OR p.is_library = TRUE)
  AND (
    p_search IS NULL 
    OR p.name ILIKE '%' || p_search || '%'
    OR p.description ILIKE '%' || p_search || '%'
  )
  ORDER BY p.is_sticky DESC NULLS LAST, p.updated_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

-- Grant execute permission to anon and authenticated roles
GRANT EXECUTE ON FUNCTION get_visible_projects_paginated TO anon;
GRANT EXECUTE ON FUNCTION get_visible_projects_paginated TO authenticated;
