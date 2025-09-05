-- Create Admin User for Dalxiis Tourism
-- This script creates an admin user through Supabase's auth system

-- First, let's check if we have any existing users in the auth.users table
SELECT 
    id,
    email,
    created_at
FROM auth.users 
LIMIT 5;

-- Check if we have any existing profiles
SELECT 
    id,
    email,
    full_name,
    role,
    is_active
FROM profiles 
LIMIT 5;

-- Note: To create a proper admin user, you need to:
-- 1. Go to Supabase Dashboard > Authentication > Users
-- 2. Click "Add User" 
-- 3. Enter: admin@dalxiis.com / password: Admin123!
-- 4. Or use the Supabase CLI to create the user

-- After creating the user in auth.users, you can update their profile:
-- UPDATE profiles 
-- SET 
--     full_name = 'System Administrator',
--     role = 'superadmin',
--     is_active = true,
--     phone = '+252 907793854'
-- WHERE email = 'admin@dalxiis.com';

-- For now, let's just check what we have:
SELECT 'Please create admin user through Supabase Dashboard > Authentication > Users' as instruction;
