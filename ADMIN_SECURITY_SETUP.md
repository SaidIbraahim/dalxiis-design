# 🔐 Admin Security Setup Guide

## Current Status
- ✅ Admin user exists in database: `admin@dalxiis.com`
- ✅ User has `superadmin` role
- ✅ User is active
- ⚠️ **NEEDS**: Secure password setup

## Step 1: Create Secure Admin Password

### Option A: Using Supabase Dashboard (Recommended)
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Navigate to your project: `ptkletolrnqgbxouamwm`
3. Go to **Authentication** → **Users**
4. Find the user `admin@dalxiis.com`
5. Click **Edit** or **Reset Password**
6. Set a strong password: `Dalxiis2024!Admin#Secure`

### Option B: Using Supabase CLI
```bash
# Install Supabase CLI if not already installed
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref ptkletolrnqgbxouamwm

# Update user password
supabase auth users update 6fcedbd6-bc4a-44d8-b05c-9cb9d5f76ae6 --password "Dalxiis2024!Admin#Secure"
```

## Step 2: Recommended Strong Password

Use this secure password (or create your own following these guidelines):

```
Dalxiis2025!Admin#Secure
```

**Password Requirements:**
- ✅ At least 12 characters
- ✅ Mix of uppercase and lowercase letters
- ✅ Numbers (2025)
- ✅ Special characters (!#)
- ✅ Company name (Dalxiis)
- ✅ Year (2025)
- ✅ Purpose (Admin)
- ✅ Security indicator (Secure)

## Step 3: Additional Security Measures

### Enable Two-Factor Authentication (2FA)
1. In Supabase Dashboard → Authentication → Users
2. Find your admin user
3. Enable 2FA if available

### Create Backup Admin User
```sql
-- Create a backup admin user
INSERT INTO profiles (id, email, full_name, role, is_active, phone)
VALUES (
  gen_random_uuid(),
  'backup-admin@dalxiis.com',
  'Backup Admin',
  'admin',
  true,
  '+252907797695'
);
```

### Monitor Admin Access
```sql
-- Check admin login activity
SELECT 
  email,
  role,
  last_login,
  created_at,
  is_active
FROM profiles 
WHERE role IN ('admin', 'superadmin')
ORDER BY last_login DESC;
```

## Step 4: Security Best Practices

### 1. Regular Password Updates
- Change password every 90 days
- Use unique passwords for different systems
- Never reuse passwords

### 2. Access Monitoring
- Monitor login attempts
- Check for unusual access patterns
- Review admin actions regularly

### 3. Environment Variables
Update your `.env` file:
```env
VITE_SUPABASE_URL=https://ptkletolrnqgbxouamwm.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

### 4. Database Security
- Enable Row Level Security (RLS) on all tables
- Use service role key only for server-side operations
- Never expose service role key in client-side code

## Step 5: Testing the Setup

1. **Test Login**: Try logging in with the new credentials
2. **Verify Access**: Ensure you can access admin dashboard
3. **Check Permissions**: Verify all admin functions work
4. **Test Logout**: Ensure logout works properly

## Emergency Access

If you lose access to the admin account:

1. **Database Access**: Use Supabase Dashboard to reset password
2. **Service Role**: Use service role key for emergency access
3. **Backup Admin**: Use the backup admin account if created

## Security Checklist

- [ ] Strong password set
- [ ] 2FA enabled (if available)
- [ ] Backup admin created
- [ ] Environment variables secured
- [ ] RLS policies reviewed
- [ ] Access monitoring enabled
- [ ] Regular security updates scheduled

## Contact Information

- **Primary Admin**: admin@dalxiis.com
- **Backup Admin**: backup-admin@dalxiis.com (if created)
- **Support**: +252907797695

---

**⚠️ IMPORTANT**: Keep this document secure and never share admin credentials publicly!
