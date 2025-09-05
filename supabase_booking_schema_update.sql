-- Supabase Booking Table Schema Update
-- Add missing fields and improve data structure

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

-- Example of how selected_services JSONB should look:
-- [
--   {
--     "id": "airport-transfer",
--     "name": "Airport Transfer",
--     "quantity": 1,
--     "price": 25,
--     "category": "Transport"
--   },
--   {
--     "id": "package-1", 
--     "name": "Garowe to Bosaso Adventure",
--     "quantity": 1,
--     "price": 450,
--     "category": "Package"
--   }
-- ]