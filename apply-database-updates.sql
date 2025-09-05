-- Apply Database Updates for Dalxiis Tourism
-- Run this script in your Supabase SQL Editor

-- 1. First, apply the booking schema updates
-- Add new columns to bookings table
ALTER TABLE bookings 
ADD COLUMN IF NOT EXISTS gender VARCHAR(20),
ADD COLUMN IF NOT EXISTS nationality VARCHAR(100),
ADD COLUMN IF NOT EXISTS end_date DATE,
ADD COLUMN IF NOT EXISTS dietary_requirements TEXT,
ADD COLUMN IF NOT EXISTS adults INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS children INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS selected_services JSONB;

-- Update existing columns to be more descriptive
COMMENT ON COLUMN bookings.gender IS 'Customer gender (Male, Female, Other, Prefer not to say)';
COMMENT ON COLUMN bookings.nationality IS 'Customer nationality for travel documentation';
COMMENT ON COLUMN bookings.end_date IS 'Trip end date';
COMMENT ON COLUMN bookings.dietary_requirements IS 'Special dietary needs';
COMMENT ON COLUMN bookings.adults IS 'Number of adult participants';
COMMENT ON COLUMN bookings.children IS 'Number of child participants';
COMMENT ON COLUMN bookings.selected_services IS 'JSON array of selected services with details';

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bookings_gender ON bookings(gender);
CREATE INDEX IF NOT EXISTS idx_bookings_nationality ON bookings(nationality);
CREATE INDEX IF NOT EXISTS idx_bookings_end_date ON bookings(end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_adults ON bookings(adults);

-- 2. Create client_notes table
CREATE TABLE IF NOT EXISTS client_notes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id TEXT NOT NULL, -- Using email as client identifier
    content TEXT NOT NULL,
    author TEXT NOT NULL,
    author_id TEXT,
    type TEXT NOT NULL CHECK (type IN ('note', 'call', 'email', 'meeting', 'system')),
    priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    tags TEXT[], -- Array of tags
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create client_activities table
CREATE TABLE IF NOT EXISTS client_activities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id TEXT NOT NULL, -- Using email as client identifier
    type TEXT NOT NULL CHECK (type IN ('booking_created', 'booking_updated', 'payment_received', 'status_changed', 'note_added', 'profile_updated')),
    description TEXT NOT NULL,
    metadata JSONB, -- Additional data about the activity
    user_id TEXT,
    user_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_client_notes_client_id ON client_notes(client_id);
CREATE INDEX IF NOT EXISTS idx_client_notes_created_at ON client_notes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_client_notes_type ON client_notes(type);
CREATE INDEX IF NOT EXISTS idx_client_notes_priority ON client_notes(priority);

CREATE INDEX IF NOT EXISTS idx_client_activities_client_id ON client_activities(client_id);
CREATE INDEX IF NOT EXISTS idx_client_activities_created_at ON client_activities(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_client_activities_type ON client_activities(type);

-- 5. Set up RLS Policies
ALTER TABLE client_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_activities ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist, then recreate them
DROP POLICY IF EXISTS "Users can manage client notes" ON client_notes;
DROP POLICY IF EXISTS "Users can manage client activities" ON client_activities;

-- Allow authenticated users to read/write their own data
CREATE POLICY "Users can manage client notes" ON client_notes
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Users can manage client activities" ON client_activities
    FOR ALL USING (auth.role() = 'authenticated');

-- 6. Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 7. Create trigger to automatically update updated_at on client_notes
DROP TRIGGER IF EXISTS update_client_notes_updated_at ON client_notes;
CREATE TRIGGER update_client_notes_updated_at 
    BEFORE UPDATE ON client_notes 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 8. Insert sample data for testing (only if tables are empty)
INSERT INTO client_notes (client_id, content, author, author_id, type, priority, tags) 
SELECT * FROM (VALUES
('saidabdishakur2000@gmail.com', 'Customer prefers vegetarian meals and has dietary restrictions. Very polite and easy to work with.', 'Admin User', 'admin-1', 'note', 'medium', ARRAY['dietary', 'preferences', 'polite']),
('saidabdishakur2000@gmail.com', 'Called customer to confirm booking details for Mogadishu City Tour. Customer was very excited about the trip and asked about local cuisine recommendations.', 'Support Team', 'support-1', 'call', 'low', ARRAY['follow-up', 'satisfied', 'cuisine']),
('saidabdishakur2000@gmail.com', 'Sent welcome email with detailed itinerary and travel tips. Customer responded with appreciation and additional questions about weather.', 'Marketing Team', 'marketing-1', 'email', 'low', ARRAY['welcome', 'itinerary', 'weather'])
) AS sample_notes(client_id, content, author, author_id, type, priority, tags)
WHERE NOT EXISTS (SELECT 1 FROM client_notes WHERE client_id = 'saidabdishakur2000@gmail.com');

INSERT INTO client_activities (client_id, type, description, metadata, user_name) 
SELECT * FROM (VALUES
('saidabdishakur2000@gmail.com', 'booking_created', 'New booking created for Mogadishu City Tour', '{"booking_id": "1", "package": "Mogadishu City Tour", "amount": 305.00}'::jsonb, 'System'),
('saidabdishakur2000@gmail.com', 'payment_received', 'Payment received for booking #DLX-001', '{"booking_id": "1", "amount": 305.00, "method": "system"}'::jsonb, 'Payment Gateway'),
('saidabdishakur2000@gmail.com', 'status_changed', 'Booking status changed from pending to confirmed', '{"booking_id": "1", "old_status": "pending", "new_status": "confirmed"}'::jsonb, 'Admin User'),
('saidabdishakur2000@gmail.com', 'note_added', 'Note added about dietary preferences', '{"note_id": "note-1", "type": "note"}'::jsonb, 'Admin User'),
('saidabdishakur2000@gmail.com', 'booking_created', 'New booking created for Beach Resort Package', '{"booking_id": "2", "package": "Beach Resort Package", "amount": 450.00}'::jsonb, 'System'),
('saidabdishakur2000@gmail.com', 'payment_received', 'Payment received for booking #DLX-002', '{"booking_id": "2", "amount": 450.00, "method": "system"}'::jsonb, 'Payment Gateway')
) AS sample_activities(client_id, type, description, metadata, user_name)
WHERE NOT EXISTS (SELECT 1 FROM client_activities WHERE client_id = 'saidabdishakur2000@gmail.com');

-- 9. Insert sample booking data (only if no bookings exist)
INSERT INTO bookings (
    customer_name, customer_email, customer_phone, nationality, gender, 
    booking_date, end_date, adults, children, total_amount, 
    status, payment_status, special_requests, dietary_requirements, selected_services
) 
SELECT * FROM (VALUES
('Said Abdishakur', 'saidabdishakur2000@gmail.com', '+252907841579', 'Somali', 'Male', 
 '2025-01-15'::date, '2025-01-17'::date, 2, 0, 305.00, 
 'confirmed', 'paid', 'Vegetarian meals preferred', 'Vegetarian meals preferred', 
 '[{"id": "1", "name": "City Tour", "price": 150, "category": "Tour", "quantity": 1}, {"id": "2", "name": "Hotel Accommodation", "price": 155, "category": "Accommodation", "quantity": 2}]'::jsonb),
('Said Abdishakur', 'saidabdishakur2000@gmail.com', '+252907841579', 'Somali', 'Male', 
 '2024-12-20'::date, '2024-12-23'::date, 1, 1, 450.00, 
 'completed', 'paid', null, null, 
 '[{"id": "3", "name": "Beach Resort", "price": 300, "category": "Resort", "quantity": 3}, {"id": "4", "name": "Water Sports", "price": 150, "category": "Activity", "quantity": 1}]'::jsonb)
) AS sample_bookings(customer_name, customer_email, customer_phone, nationality, gender, 
    booking_date, end_date, adults, children, total_amount, 
    status, payment_status, special_requests, dietary_requirements, selected_services)
WHERE NOT EXISTS (SELECT 1 FROM bookings WHERE customer_email = 'saidabdishakur2000@gmail.com');

-- Success message
SELECT 'Database updates applied successfully!' as status;
