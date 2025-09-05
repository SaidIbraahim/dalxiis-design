# 🔐 Manual Admin Setup - 2025

## Current Status
✅ **Database**: Admin user exists in profiles table  
⏳ **Auth**: Need to create user in Supabase Auth  

## Method 1: Supabase Dashboard (Easiest)

1. **Go to Supabase Dashboard**
   - Visit: https://supabase.com/dashboard
   - Select project: `dalxiis-tourism`

2. **Navigate to Authentication**
   - Go to **Authentication** → **Users**
   - Click **Invite User**

3. **Create Admin User**
   - **Email**: `admin@dalxiis.com`
   - **Password**: `Dalxiis2025!Admin#Secure`
   - **Auto-confirm**: ✅ Yes
   - Click **Send Invite**

## Method 2: Supabase CLI (Current Session)

Since you're already logged in, run these commands:

```bash
# Link to your project
supabase link --project-ref ptkletolrnqgbxouamwm

# Create admin user
supabase auth users create admin@dalxiis.com --password "Dalxiis2025!Admin#Secure" --email-confirm

# If user already exists, update password
supabase auth users update admin@dalxiis.com --password "Dalxiis2025!Admin#Secure"
```

## Method 3: Direct SQL (Emergency)

If CLI doesn't work, you can create the user directly in the database:

```sql
-- Run this in Supabase SQL Editor
INSERT INTO auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  gen_random_uuid(),
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'admin@dalxiis.com',
  crypt('Dalxiis2025!Admin#Secure', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
);
```

## Verification

After creating the user, verify it works:

1. **Test Login**: Go to http://localhost:5173/admin/login
2. **Enter Credentials**:
   - Email: `admin@dalxiis.com`
   - Password: `Dalxiis2025!Admin#Secure`
3. **Should redirect to admin dashboard**

## Next Steps

1. ✅ Create user in Supabase Auth
2. ✅ Test login works
3. ⏳ Change password after first login
4. ⏳ Enable 2FA if available

---

**Current Admin Credentials:**
- **Email**: admin@dalxiis.com
- **Password**: Dalxiis2025!Admin#Secure
- **Role**: superadmin
- **Status**: active
