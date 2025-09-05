-- Data Migration Script for Old Bookings
-- This script helps extract data from special_requests and populate the new fields

-- Update nationality from special_requests for old bookings
UPDATE bookings 
SET nationality = 
  CASE 
    WHEN special_requests LIKE '%Nationality: Somali%' THEN 'Somali'
    WHEN special_requests LIKE '%Nationality: Kenyan%' THEN 'Kenyan'
    WHEN special_requests LIKE '%Nationality: Norwegian%' THEN 'Norwegian'
    WHEN special_requests LIKE '%Nationality: French%' THEN 'French'
    WHEN special_requests LIKE '%Nationality: British%' THEN 'British'
    WHEN special_requests LIKE '%Nationality: Ethiopian%' THEN 'Ethiopian'
    ELSE NULL
  END
WHERE nationality IS NULL AND special_requests IS NOT NULL;

-- Update end_date from special_requests for old bookings
UPDATE bookings 
SET end_date = 
  CASE 
    WHEN special_requests ~ 'End Date: (\d{4}-\d{2}-\d{2})' 
    THEN (regexp_match(special_requests, 'End Date: (\d{4}-\d{2}-\d{2})'))[1]::date
    ELSE NULL
  END
WHERE end_date IS NULL AND special_requests IS NOT NULL;

-- Update dietary_requirements from special_requests for old bookings
UPDATE bookings 
SET dietary_requirements = 
  CASE 
    WHEN special_requests LIKE '%Vegetarian%' OR special_requests LIKE '%Halal%' OR special_requests LIKE '%Gluten-free%'
    THEN regexp_replace(
      substring(special_requests from '(Vegetarian|Halal|Gluten-free|Nut-free)[^\n]*'), 
      'Selected Services:.*', '', 'g'
    )
    ELSE NULL
  END
WHERE dietary_requirements IS NULL AND special_requests IS NOT NULL;

-- Fix participant counts for old bookings (this needs manual review)
-- UPDATE bookings 
-- SET adults = 2, children = 0 
-- WHERE participants = 2 AND adults = 1 AND created_at < '2025-08-29 05:00:00';

-- Clean up special_requests after migration (optional)
-- UPDATE bookings 
-- SET special_requests = 
--   regexp_replace(
--     regexp_replace(
--       regexp_replace(special_requests, 'Nationality: [^\n]*\n?', '', 'g'),
--       'End Date: [^\n]*\n?', '', 'g'
--     ),
--     'Selected Services: [^\n]*\n?', '', 'g'
--   )
-- WHERE special_requests IS NOT NULL;