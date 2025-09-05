-- Create payment_records table for tracking individual payment transactions
CREATE TABLE IF NOT EXISTS payment_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  customer_name VARCHAR(255) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(100) NOT NULL CHECK (payment_method IN ('cash', 'sahal', 'e_dahab', 'mycash', 'bank_transfer', 'cheque', 'other')),
  transaction_id VARCHAR(255),
  notes TEXT,
  type VARCHAR(20) NOT NULL CHECK (type IN ('payment', 'refund')),
  status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('completed', 'pending', 'failed')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_payment_records_booking_id ON payment_records(booking_id);
CREATE INDEX IF NOT EXISTS idx_payment_records_type ON payment_records(type);
CREATE INDEX IF NOT EXISTS idx_payment_records_status ON payment_records(status);
CREATE INDEX IF NOT EXISTS idx_payment_records_created_at ON payment_records(created_at);

-- Create updated_at trigger for payment_records
CREATE TRIGGER update_payment_records_updated_at 
  BEFORE UPDATE ON payment_records 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- Add RLS policies for payment_records
ALTER TABLE payment_records ENABLE ROW LEVEL SECURITY;

-- Policy: Admins can view all payment records
CREATE POLICY "Admins can view all payment records" ON payment_records
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('superadmin', 'admin')
    )
  );

-- Policy: Admins can insert payment records
CREATE POLICY "Admins can insert payment records" ON payment_records
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('superadmin', 'admin')
    )
  );

-- Policy: Admins can update payment records
CREATE POLICY "Admins can update payment records" ON payment_records
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('superadmin', 'admin')
    )
  );

-- Policy: Admins can delete payment records
CREATE POLICY "Admins can delete payment records" ON payment_records
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('superadmin', 'admin')
    )
  );
