-- Client Notes Table
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

-- Client Activities Table
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

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_client_notes_client_id ON client_notes(client_id);
CREATE INDEX IF NOT EXISTS idx_client_notes_created_at ON client_notes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_client_notes_type ON client_notes(type);
CREATE INDEX IF NOT EXISTS idx_client_notes_priority ON client_notes(priority);

CREATE INDEX IF NOT EXISTS idx_client_activities_client_id ON client_activities(client_id);
CREATE INDEX IF NOT EXISTS idx_client_activities_created_at ON client_activities(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_client_activities_type ON client_activities(type);

-- RLS Policies (if using Row Level Security)
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

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at on client_notes
CREATE TRIGGER update_client_notes_updated_at 
    BEFORE UPDATE ON client_notes 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Sample data for testing
INSERT INTO client_notes (client_id, content, author, author_id, type, priority, tags) VALUES
('saidabdishakur2000@gmail.com', 'Customer prefers vegetarian meals and has dietary restrictions. Very polite and easy to work with.', 'Admin User', 'admin-1', 'note', 'medium', ARRAY['dietary', 'preferences', 'polite']),
('saidabdishakur2000@gmail.com', 'Called customer to confirm booking details for Mogadishu City Tour. Customer was very excited about the trip and asked about local cuisine recommendations.', 'Support Team', 'support-1', 'call', 'low', ARRAY['follow-up', 'satisfied', 'cuisine']),
('saidabdishakur2000@gmail.com', 'Sent welcome email with detailed itinerary and travel tips. Customer responded with appreciation and additional questions about weather.', 'Marketing Team', 'marketing-1', 'email', 'low', ARRAY['welcome', 'itinerary', 'weather']);

INSERT INTO client_activities (client_id, type, description, metadata, user_name) VALUES
('saidabdishakur2000@gmail.com', 'booking_created', 'New booking created for Mogadishu City Tour', '{"booking_id": "1", "package": "Mogadishu City Tour", "amount": 305.00}', 'System'),
('saidabdishakur2000@gmail.com', 'payment_received', 'Payment received for booking #DLX-001', '{"booking_id": "1", "amount": 305.00, "method": "system"}', 'Payment Gateway'),
('saidabdishakur2000@gmail.com', 'status_changed', 'Booking status changed from pending to confirmed', '{"booking_id": "1", "old_status": "pending", "new_status": "confirmed"}', 'Admin User'),
('saidabdishakur2000@gmail.com', 'note_added', 'Note added about dietary preferences', '{"note_id": "note-1", "type": "note"}', 'Admin User'),
('saidabdishakur2000@gmail.com', 'booking_created', 'New booking created for Beach Resort Package', '{"booking_id": "2", "package": "Beach Resort Package", "amount": 450.00}', 'System'),
('saidabdishakur2000@gmail.com', 'payment_received', 'Payment received for booking #DLX-002', '{"booking_id": "2", "amount": 450.00, "method": "system"}', 'Payment Gateway');