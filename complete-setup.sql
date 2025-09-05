-- Dalxiis Tourism - Complete Database Setup Script
-- This script handles everything in the correct order for existing Supabase setup

-- STEP 1: Check current state
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 1: Checking current database state ===';
    
    -- Check what tables exist
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        RAISE NOTICE 'Profiles table exists';
    ELSE
        RAISE NOTICE 'Profiles table does not exist';
    END IF;
    
    -- Check what columns exist in profiles
    IF EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'full_name') THEN
        RAISE NOTICE 'full_name column exists in profiles';
    ELSE
        RAISE NOTICE 'full_name column missing in profiles';
    END IF;
END $$;

-- STEP 2: Add missing columns to profiles table (if needed)
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 2: Adding missing columns to profiles ===';
    
    -- Add missing columns to existing profiles table
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'full_name') THEN
        ALTER TABLE profiles ADD COLUMN full_name VARCHAR(255);
        RAISE NOTICE 'Added full_name column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'phone') THEN
        ALTER TABLE profiles ADD COLUMN phone VARCHAR(50);
        RAISE NOTICE 'Added phone column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'role') THEN
        ALTER TABLE profiles ADD COLUMN role VARCHAR(20);
        RAISE NOTICE 'Added role column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'avatar_url') THEN
        ALTER TABLE profiles ADD COLUMN avatar_url TEXT;
        RAISE NOTICE 'Added avatar_url column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'is_active') THEN
        ALTER TABLE profiles ADD COLUMN is_active BOOLEAN DEFAULT true;
        RAISE NOTICE 'Added is_active column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'last_login') THEN
        ALTER TABLE profiles ADD COLUMN last_login TIMESTAMP WITH TIME ZONE;
        RAISE NOTICE 'Added last_login column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'created_at') THEN
        ALTER TABLE profiles ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        RAISE NOTICE 'Added created_at column';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'updated_at') THEN
        ALTER TABLE profiles ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        RAISE NOTICE 'Added updated_at column';
    END IF;
    
    -- Add role constraint if it doesn't exist
    IF NOT EXISTS (SELECT FROM information_schema.check_constraints WHERE constraint_name LIKE '%role%') THEN
        ALTER TABLE profiles ADD CONSTRAINT profiles_role_check CHECK (role IN ('superadmin', 'admin', 'staff'));
        RAISE NOTICE 'Added role constraint';
    END IF;
END $$;

-- STEP 3: Update existing user profile (you need to replace the email)
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 3: Updating existing user profile ===';
    
    -- Get the first user from auth.users to update their profile
    -- You can modify this to target a specific email if needed
    UPDATE profiles 
    SET 
        full_name = 'System Administrator',
        role = 'superadmin',
        is_active = true,
        phone = '+252 907793854',
        updated_at = NOW()
    WHERE id IN (
        SELECT id FROM auth.users LIMIT 1
    );
    
    RAISE NOTICE 'Updated existing user profile with admin role';
END $$;

-- STEP 4: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- STEP 5: Create all the business tables
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 5: Creating business tables ===';
END $$;

-- TOUR_PACKAGES TABLE
CREATE TABLE IF NOT EXISTS tour_packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  duration_days INTEGER,
  max_participants INTEGER,
  category VARCHAR(50) CHECK (category IN ('basic', 'premium', 'vip', 'custom')),
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'inactive')),
  highlights TEXT[],
  included_services TEXT[],
  excluded_services TEXT[],
  images TEXT[],
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- DESTINATIONS TABLE
CREATE TABLE IF NOT EXISTS destinations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  region VARCHAR(100) NOT NULL,
  description TEXT,
  highlights TEXT[],
  images TEXT[],
  coordinates JSONB,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL,
  customer_phone VARCHAR(50),
  package_id UUID REFERENCES tour_packages(id),
  destination_id UUID REFERENCES destinations(id),
  booking_date DATE NOT NULL,
  participants INTEGER DEFAULT 1,
  total_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled', 'rejected')),
  payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'refunded')),
  special_requests TEXT,
  assigned_to UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- INCOME TABLE
CREATE TABLE IF NOT EXISTS income (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type VARCHAR(100) NOT NULL,
  source VARCHAR(100),
  amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'received', 'overdue')),
  payment_method VARCHAR(100),
  reference VARCHAR(255),
  notes TEXT,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- EXPENSES TABLE
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  vendor VARCHAR(255),
  receipt_url TEXT,
  approved_by UUID REFERENCES profiles(id),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- FINANCIAL_REPORTS TABLE
CREATE TABLE IF NOT EXISTS financial_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period VARCHAR(50) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_income DECIMAL(12,2) DEFAULT 0,
  total_expenses DECIMAL(12,2) DEFAULT 0,
  net_profit DECIMAL(12,2) GENERATED ALWAYS AS (total_income - total_expenses) STORED,
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'completed', 'approved')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- AUDIT_LOGS TABLE
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  action VARCHAR(100) NOT NULL,
  table_name VARCHAR(100),
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- STEP 6: Create indexes for performance
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 6: Creating indexes ===';
END $$;

CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_tour_packages_status ON tour_packages(status);
CREATE INDEX IF NOT EXISTS idx_destinations_region ON destinations(region);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_income_date ON income(date);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_status ON expenses(status);
CREATE INDEX IF NOT EXISTS idx_financial_reports_period ON financial_reports(period);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);

-- STEP 7: Create triggers for updated_at
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 7: Creating triggers ===';
END $$;

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to all tables
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tour_packages_updated_at BEFORE UPDATE ON tour_packages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_destinations_updated_at BEFORE UPDATE ON destinations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_income_updated_at BEFORE UPDATE ON income FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_financial_reports_updated_at BEFORE UPDATE ON financial_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- STEP 8: Insert sample data
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 8: Inserting sample data ===';
END $$;

-- Insert sample tour packages
INSERT INTO tour_packages (id, name, description, price, duration_days, max_participants, category, status, highlights) 
SELECT 
    gen_random_uuid(),
    'Puntland Adventure', 
    'Explore the beautiful landscapes of Puntland', 
    299.99, 
    3, 
    10, 
    'basic', 
    'active', 
    ARRAY['Scenic views', 'Local culture', 'Adventure activities']
WHERE NOT EXISTS (SELECT 1 FROM tour_packages LIMIT 1);

INSERT INTO tour_packages (id, name, description, price, duration_days, max_participants, category, status, highlights) 
SELECT 
    gen_random_uuid(),
    'Somalia Heritage Tour', 
    'Discover the rich heritage of Somalia', 
    499.99, 
    5, 
    8, 
    'premium', 
    'active', 
    ARRAY['Historical sites', 'Cultural experiences', 'Luxury accommodation']
WHERE NOT EXISTS (SELECT 1 FROM tour_packages WHERE name = 'Somalia Heritage Tour');

-- Insert sample destinations
INSERT INTO destinations (id, name, region, description, highlights, status) 
SELECT 
    gen_random_uuid(),
    'Garowe', 
    'Puntland', 
    'Capital city of Puntland with modern infrastructure', 
    ARRAY['City tours', 'Shopping', 'Local cuisine'], 
    'active'
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE name = 'Garowe');

INSERT INTO destinations (id, name, region, description, highlights, status) 
SELECT 
    gen_random_uuid(),
    'Bosaso', 
    'Puntland', 
    'Coastal city with beautiful beaches', 
    ARRAY['Beach activities', 'Water sports', 'Fishing'], 
    'active'
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE name = 'Bosaso');

-- STEP 9: Final verification
DO $$ 
BEGIN
    RAISE NOTICE '=== STEP 9: Final verification ===';
END $$;

-- Check what we created
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Check profiles structure
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'profiles' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Success message
SELECT '🎉 Complete database setup finished successfully!' as status;
