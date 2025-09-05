-- Insert Dalxiis Tourism Tour Packages
-- This script inserts the 7 tour packages with correct information

-- Clear existing packages (optional - remove if you want to keep existing data)
-- DELETE FROM tour_packages;

-- Insert the 7 tour packages
INSERT INTO tour_packages (id, name, description, price, duration_days, max_participants, category, status, highlights, included_services, excluded_services, images) VALUES

-- 1. Garowe to Eyl Package ($130/person)
(
  gen_random_uuid(),
  'Garowe to Eyl Package',
  'Experience the stunning beauty of Eyl with its pristine beaches, historical sites, and desert landscapes. This 3-day adventure includes transportation, accommodation, and all meals.',
  130.00,
  3,
  15,
  'basic',
  'active',
  ARRAY['Pristine Beaches', 'Historical Sites', 'Desert Explorations', 'Boat Excursions', 'Mountain Views'],
  ARRAY['Transportation', 'Hotel Accommodation', '3 Meals per Day', 'Professional Guide', 'All Activities'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance'],
  ARRAY['https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 2. Garowe to Bosaso Package ($160/person)
(
  gen_random_uuid(),
  'Garowe to Bosaso Package',
  'Discover the coastal charm of Bosaso with visits to Marero beach, Biyo Kulule, and enjoy traditional Qaaci music. This 3-day package includes all transportation, accommodation, and meals.',
  160.00,
  3,
  12,
  'premium',
  'active',
  ARRAY['Marero Beach', 'Biyo Kulule', 'Night Program', 'Qaaci Music', 'Coastal Views'],
  ARRAY['Transportation', 'Hotel Accommodation', '3 Meals per Day', 'Professional Guide', 'All Activities', 'Night Entertainment'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance'],
  ARRAY['https://images.pexels.com/photos/1287460/pexels-photo-1287460.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 3. Garowe to Garacad Coast Package ($175/person)
(
  gen_random_uuid(),
  'Garowe to Garacad Coast Package',
  'Explore the beautiful Garacad coast and port with its unique attractions. This 3-day package includes transportation, accommodation, meals, and traditional Qaaci entertainment.',
  175.00,
  3,
  10,
  'premium',
  'active',
  ARRAY['Garacad Coast', 'Garacad Port', 'Night Program', 'Qaaci Music', 'Coastal Activities'],
  ARRAY['Transportation', 'Hotel Accommodation', '3 Meals per Day', 'Professional Guide', 'All Activities', 'Night Entertainment'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance'],
  ARRAY['https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/1287460/pexels-photo-1287460.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 4. Galkio to Bosaso Package ($185/person)
(
  gen_random_uuid(),
  'Galkio to Bosaso Package',
  'Journey from Galkio to the beautiful coastal city of Bosaso. Visit Marero beach, Biyo Kulule, and other attractions. This 3-day package includes transportation, accommodation, and 2 meals per day.',
  185.00,
  3,
  12,
  'premium',
  'active',
  ARRAY['Marero Beach', 'Biyo Kulule', 'Coastal Views', 'Local Attractions', 'Cultural Sites'],
  ARRAY['Transportation', 'Hotel Accommodation', '2 Meals per Day', 'Professional Guide', 'All Activities'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance', 'Additional Meals'],
  ARRAY['https://images.pexels.com/photos/1287460/pexels-photo-1287460.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 5. Bosaso to Biyo Kulule Package ($40/person, 1-day trip)
(
  gen_random_uuid(),
  'Bosaso to Biyo Kulule Day Trip',
  'A perfect day trip from Bosaso to the beautiful Biyo Kulule. Experience the natural beauty and enjoy a relaxing day in this scenic location.',
  40.00,
  1,
  20,
  'basic',
  'active',
  ARRAY['Biyo Kulule', 'Natural Beauty', 'Scenic Views', 'Relaxation'],
  ARRAY['Transportation', 'Professional Guide', 'Lunch'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance', 'Accommodation', 'Breakfast', 'Dinner'],
  ARRAY['https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 6. Galkio to Garacad Package ($145/person)
(
  gen_random_uuid(),
  'Galkio to Garacad Package',
  'Discover the beauty of Garacad coast and port from Galkio. This 3-day package includes transportation, accommodation, meals, and traditional Qaaci entertainment.',
  145.00,
  3,
  10,
  'basic',
  'active',
  ARRAY['Garacad Coast', 'Garacad Port', 'Night Program', 'Qaaci Music', 'Coastal Activities'],
  ARRAY['Transportation', 'Hotel Accommodation', '3 Meals per Day', 'Professional Guide', 'All Activities', 'Night Entertainment'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance'],
  ARRAY['https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/1287460/pexels-photo-1287460.jpeg?auto=compress&cs=tinysrgb&w=800']
),

-- 7. Galkio to Eyl Package ($165/person)
(
  gen_random_uuid(),
  'Galkio to Eyl Package',
  'Experience the stunning beauty of Eyl from Galkio. This 3-day adventure includes visits to beaches, mountains, historical sites, and desert explorations with full transportation and accommodation.',
  165.00,
  3,
  15,
  'premium',
  'active',
  ARRAY['Pristine Beaches', 'Mountain Views', 'Historical Sites', 'Desert Explorations', 'Boat Excursions'],
  ARRAY['Transportation', 'Hotel Accommodation', '3 Meals per Day', 'Professional Guide', 'All Activities'],
  ARRAY['Personal Expenses', 'Optional Activities', 'Travel Insurance'],
  ARRAY['https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=800']
);

-- Success message
SELECT '🎉 Tour packages inserted successfully!' as status;
