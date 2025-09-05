# Dalxiis Admin Setup Script for 2025
# PowerShell version

Write-Host "🔐 Setting up Dalxiis Admin User for 2025..." -ForegroundColor Cyan
Write-Host ""

# Check if Supabase CLI is installed
try {
    $supabaseVersion = supabase --version
    Write-Host "✅ Supabase CLI found: $supabaseVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Supabase CLI not found. Installing..." -ForegroundColor Red
    try {
        npm install -g supabase
        Write-Host "✅ Supabase CLI installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install Supabase CLI. Please install manually:" -ForegroundColor Red
        Write-Host "npm install -g supabase" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""

# Login to Supabase
Write-Host "🔑 Logging into Supabase..." -ForegroundColor Yellow
try {
    supabase login
    Write-Host "✅ Successfully logged into Supabase" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to login to Supabase" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Link to project
Write-Host "🔗 Linking to dalxiis-tourism project..." -ForegroundColor Yellow
try {
    supabase link --project-ref ptkletolrnqgbxouamwm
    Write-Host "✅ Successfully linked to project" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to link to project" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Create admin user
Write-Host "👤 Creating admin user..." -ForegroundColor Yellow
try {
    supabase auth users create admin@dalxiis.com --password "Dalxiis2025!Admin#Secure" --email-confirm
    Write-Host "✅ Admin user created successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️  User might already exist. Trying to update password..." -ForegroundColor Yellow
    try {
        supabase auth users update admin@dalxiis.com --password "Dalxiis2025!Admin#Secure"
        Write-Host "✅ Admin user password updated successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to create/update admin user" -ForegroundColor Red
        Write-Host "Please check the Supabase Dashboard manually" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""
Write-Host "🎉 Admin user setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📧 Email: admin@dalxiis.com" -ForegroundColor Cyan
Write-Host "🔑 Password: Dalxiis2025!Admin#Secure" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  IMPORTANT: Change this password after first login!" -ForegroundColor Red
Write-Host ""
Write-Host "🚀 You can now test the login at: http://localhost:5173/admin/login" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to continue"
