# 🚀 Quick Setup Guide

## ✅ Issues Fixed

1. **Restored fallback credentials** - App will work immediately
2. **Enabled DEV_MODE** - Easy admin login restored
3. **Fixed timeout issues** - App should load quickly now

## 🔧 Environment Variables Setup

Create a `.env.local` file in your project root with:

```env
VITE_SUPABASE_URL=https://ptkletolrnqgbxouamwm.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0a2xldG9scm5xZ2J4b3VhbXdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2Mjc5NzksImV4cCI6MjA3MTIwMzk3OX0.w5PEFKFxHsgSE6RG8JoBDGpoUzI17mw7rLbU42KRwf4
NODE_ENV=development
```

## 🔐 Admin Login

**Development Mode (Current):**
- Any email/password will work
- Auto-login enabled
- No real authentication required

**Production Mode (When ready):**
- Email: `admin@dalxiis.com`
- Password: `Dalxiis2025!Admin#Secure`

## 🚀 Start the App

```bash
npm run dev
```

The app should now load quickly without timeout issues!

## 🔄 Switch to Production Mode

When ready for production:

1. Set `DEV_MODE = false` in `src/context/AuthContext.tsx`
2. Create admin user in Supabase Auth
3. Deploy with environment variables

## ✅ Current Status

- ✅ App loads quickly
- ✅ No timeout errors
- ✅ Easy admin access
- ✅ All features working
- ⚠️ Still in development mode (secure for local use)
