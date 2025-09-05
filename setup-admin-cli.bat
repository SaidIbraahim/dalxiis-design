@echo off
echo 🔐 Setting up Dalxiis Admin User for 2025...
echo.

REM Check if Supabase CLI is installed
where supabase >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Supabase CLI not found. Installing...
    npm install -g supabase
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to install Supabase CLI. Please install manually.
        pause
        exit /b 1
    )
)

echo ✅ Supabase CLI found
echo.

REM Login to Supabase
echo 🔑 Logging into Supabase...
supabase login
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to login to Supabase
    pause
    exit /b 1
)

echo.

REM Link to project
echo 🔗 Linking to dalxiis-tourism project...
supabase link --project-ref ptkletolrnqgbxouamwm
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to link to project
    pause
    exit /b 1
)

echo.

REM Create admin user
echo 👤 Creating admin user...
supabase auth users create admin@dalxiis.com --password "Dalxiis2025!Admin#Secure" --email-confirm
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to create admin user
    echo This might be because the user already exists
    echo.
    echo 🔄 Trying to update existing user...
    supabase auth users update admin@dalxiis.com --password "Dalxiis2025!Admin#Secure"
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to update user password
        pause
        exit /b 1
    )
)

echo.
echo ✅ Admin user setup complete!
echo.
echo 📧 Email: admin@dalxiis.com
echo 🔑 Password: Dalxiis2025!Admin#Secure
echo.
echo ⚠️  IMPORTANT: Change this password after first login!
echo.
echo 🚀 You can now test the login at: http://localhost:5173/admin/login
echo.
pause
