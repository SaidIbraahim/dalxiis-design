// Admin User Setup Script for Dalxiis Tourism
// This script creates the admin user in Supabase Auth and database

const { createClient } = require('@supabase/supabase-js');

// Supabase configuration
const supabaseUrl = 'https://ptkletolrnqgbxouamwm.supabase.co';
const supabaseServiceKey = 'YOUR_SERVICE_ROLE_KEY_HERE'; // Replace with your service role key

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function createAdminUser() {
  try {
    console.log('🔐 Creating secure admin user...');
    
    // Create user in Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email: 'admin@dalxiis.com',
      password: 'Dalxiis2025!Admin#Secure', // Updated with 2025
      email_confirm: true, // Auto-confirm email
      user_metadata: {
        full_name: 'Dalxiis Admin',
        role: 'superadmin'
      }
    });

    if (authError) {
      console.error('❌ Error creating auth user:', authError);
      return;
    }

    console.log('✅ Auth user created:', authData.user?.id);

    // Create profile in profiles table
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email: 'admin@dalxiis.com',
        full_name: 'Dalxiis Admin',
        role: 'superadmin',
        is_active: true,
        phone: '+252907797695'
      });

    if (profileError) {
      console.error('❌ Error creating profile:', profileError);
      return;
    }

    console.log('✅ Admin user setup complete!');
    console.log('📧 Email: admin@dalxiis.com');
    console.log('🔑 Password: Dalxiis2025!Admin#Secure');
    console.log('⚠️  IMPORTANT: Change this password after first login!');

  } catch (error) {
    console.error('❌ Setup failed:', error);
  }
}

// Run the script
createAdminUser();
