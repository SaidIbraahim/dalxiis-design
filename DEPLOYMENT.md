# Dalxiis Tourism - Deployment Guide

## 🚀 Production Deployment

This guide covers deploying the Dalxiis Tourism application to production with secure authentication.

### Prerequisites

- Node.js 18+ installed
- Vercel CLI installed (`npm i -g vercel`)
- Supabase project configured
- Admin user created in database

### 🔐 Security Configuration

#### Admin Authentication
- **Development Mode**: Disabled (`DEV_MODE = false`)
- **Admin User**: `admin@dalxiis.com`
- **Role**: `superadmin`
- **Authentication**: Supabase Auth with profile-based role checking

#### Database Security
- Row Level Security (RLS) enabled on sensitive tables
- Profile-based access control
- Audit logging for admin actions

### 📦 Build & Deploy

#### 1. Build for Production
```bash
npm run build:prod
```

#### 2. Deploy to Vercel
```bash
# Deploy to preview
npm run deploy:preview

# Deploy to production
npm run deploy:vercel
```

#### 3. Environment Variables
The following environment variables are configured in `vercel.json`:
- `VITE_SUPABASE_URL`: Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Supabase anonymous key
- `NODE_ENV`: production

### 🔑 Admin Login Credentials

**For Production Use:**
- **Email**: `admin@dalxiis.com`
- **Password**: [Set via Supabase Auth Dashboard]

**To set admin password:**
1. Go to Supabase Dashboard → Authentication → Users
2. Find `admin@dalxiis.com` user
3. Click "Reset Password" to set a new password
4. Use the new password to login

### 🛡️ Security Features

#### Authentication Flow
1. User enters credentials on login page
2. Supabase Auth validates credentials
3. System checks user role in `profiles` table
4. Access granted only for `superadmin` or `admin` roles
5. Session managed by Supabase Auth

#### Access Control
- Admin dashboard requires authentication
- All admin routes protected by role checking
- Automatic logout on role mismatch
- Session persistence across browser refreshes

### 📊 Database Configuration

#### Admin User Profile
```sql
-- Admin profile in profiles table
{
  "id": "6fcedbd6-bc4a-44d8-b05c-9cb9d5f76ae6",
  "email": "admin@dalxiis.com",
  "role": "superadmin",
  "is_active": true,
  "full_name": "Dalxiis Admin",
  "phone": "+252 61 234 5678"
}
```

#### Required Tables
- `profiles` - User roles and permissions
- `auth.users` - Supabase authentication
- All business tables (bookings, packages, etc.)

### 🚨 Security Checklist

- [x] Development mode disabled
- [x] Admin user created with proper role
- [x] RLS enabled on sensitive tables
- [x] Environment variables secured
- [x] Authentication flow implemented
- [x] Role-based access control active
- [x] Session management configured

### 🔧 Troubleshooting

#### Login Issues
1. Verify admin user exists in `auth.users`
2. Check profile role is `superadmin` or `admin`
3. Ensure `is_active` is `true` in profiles table
4. Verify Supabase connection in browser console

#### Deployment Issues
1. Check environment variables in Vercel dashboard
2. Verify build logs for errors
3. Test database connection
4. Check Supabase project status

### 📱 Post-Deployment

1. **Test Admin Login**: Verify login works with admin credentials
2. **Test All Features**: Ensure all admin functions work
3. **Monitor Logs**: Check for any authentication errors
4. **Update DNS**: Point domain to Vercel deployment
5. **SSL Certificate**: Vercel provides automatic SSL

### 🔄 Maintenance

#### Regular Tasks
- Monitor admin login activity
- Review audit logs for suspicious activity
- Update admin passwords periodically
- Monitor database performance

#### Emergency Access
If admin access is lost:
1. Access Supabase Dashboard directly
2. Reset admin user password
3. Verify profile role in database
4. Test login functionality

---

**Deployment Status**: ✅ Ready for Production
**Last Updated**: January 2025
**Version**: 1.0.0
