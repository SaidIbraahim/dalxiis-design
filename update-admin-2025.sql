-- Update Admin User for 2025 - Dalxiis Tourism
-- Run this SQL in your Supabase SQL Editor

-- Update the existing admin user profile
UPDATE profiles 
SET 
  updated_at = NOW(),
  last_login = NOW()
WHERE email = 'admin@dalxiis.com';

-- Verify the admin user exists and is active
SELECT 
  id,
  email,
  full_name,
  role,
  is_active,
  created_at,
  updated_at
FROM profiles 
WHERE email = 'admin@dalxiis.com';

-- If the user doesn't exist, create it
INSERT INTO profiles (
  id,
  email,
  full_name,
  role,
  is_active,
  phone,
  created_at,
  updated_at
)
SELECT 
  gen_random_uuid(),
  'admin@dalxiis.com',
  'Dalxiis Admin',
  'superadmin',
  true,
  '+252907797695',
  NOW(),
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM profiles WHERE email = 'admin@dalxiis.com'
);

-- Final verification
SELECT 
  'Admin user ready for 2025!' as status,
  email,
  role,
  is_active
FROM profiles 
WHERE email = 'admin@dalxiis.com';
