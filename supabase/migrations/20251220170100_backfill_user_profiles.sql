-- Create user profiles for existing users that don't have one yet

INSERT INTO user_profiles (id, username)
SELECT 
  u.id,
  COALESCE(
    lower(regexp_replace(split_part(u.email, '@', 1), '[^a-z0-9]', '', 'g')),
    'user' || substring(u.id::text, 1, 8)
  ) as username
FROM auth.users u
LEFT JOIN user_profiles up ON u.id = up.id
WHERE up.id IS NULL
ON CONFLICT (id) DO NOTHING;

-- Handle username conflicts by appending numbers
DO $$
DECLARE
  user_record RECORD;
  base_name text;
  final_name text;
  counter int;
BEGIN
  FOR user_record IN 
    SELECT u.id, u.email 
    FROM auth.users u
    LEFT JOIN user_profiles up ON u.id = up.id
    WHERE up.id IS NULL
  LOOP
    base_name := lower(regexp_replace(split_part(user_record.email, '@', 1), '[^a-z0-9]', '', 'g'));
    
    IF length(base_name) < 3 THEN
      base_name := 'user' || substring(user_record.id::text, 1, 6);
    END IF;
    
    final_name := base_name;
    counter := 0;
    
    WHILE EXISTS (SELECT 1 FROM user_profiles WHERE username = final_name) LOOP
      counter := counter + 1;
      final_name := base_name || counter;
    END LOOP;
    
    INSERT INTO user_profiles (id, username)
    VALUES (user_record.id, final_name)
    ON CONFLICT (id) DO NOTHING;
  END LOOP;
END $$;
