-- Create document_records table for tracking generated documents
CREATE TABLE IF NOT EXISTS document_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  customer_name VARCHAR(255) NOT NULL,
  document_type VARCHAR(20) NOT NULL CHECK (document_type IN ('receipt', 'ticket')),
  generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  print_count INTEGER DEFAULT 0,
  last_printed TIMESTAMP WITH TIME ZONE,
  document_url TEXT,
  file_size INTEGER, -- in bytes
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'archived', 'deleted')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_document_records_booking_id ON document_records(booking_id);
CREATE INDEX IF NOT EXISTS idx_document_records_type ON document_records(document_type);
CREATE INDEX IF NOT EXISTS idx_document_records_status ON document_records(status);
CREATE INDEX IF NOT EXISTS idx_document_records_generated_at ON document_records(generated_at);

-- Create updated_at trigger for document_records
CREATE TRIGGER update_document_records_updated_at
  BEFORE UPDATE ON document_records
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Add RLS policies for document_records
ALTER TABLE document_records ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to view document records
CREATE POLICY "Allow authenticated users to view document records" ON document_records
  FOR SELECT USING (auth.role() = 'authenticated');

-- Policy: Allow authenticated users to insert document records
CREATE POLICY "Allow authenticated users to insert document records" ON document_records
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy: Allow authenticated users to update document records
CREATE POLICY "Allow authenticated users to update document records" ON document_records
  FOR UPDATE USING (auth.role() = 'authenticated');

-- Policy: Allow authenticated users to delete document records
CREATE POLICY "Allow authenticated users to delete document records" ON document_records
  FOR DELETE USING (auth.role() = 'authenticated');

-- Function to update print count and last printed timestamp
CREATE OR REPLACE FUNCTION update_document_print_info()
RETURNS TRIGGER AS $$
BEGIN
  NEW.print_count = COALESCE(OLD.print_count, 0) + 1;
  NEW.last_printed = NOW();
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update print information
CREATE TRIGGER update_document_print_info_trigger
  BEFORE UPDATE ON document_records
  FOR EACH ROW
  WHEN (OLD.print_count IS DISTINCT FROM NEW.print_count)
  EXECUTE FUNCTION update_document_print_info();
