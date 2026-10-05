-- Customers who signed up before "Complete your profile" existed and already
-- have a name count as having a finished profile.
UPDATE "users"
SET "profile_completed_at" = now(),
    "first_name" = split_part("full_name", ' ', 1),
    "last_name" = NULLIF(btrim(substr("full_name", length(split_part("full_name", ' ', 1)) + 1)), '')
WHERE "role" = 'CUSTOMER'
  AND "full_name" IS NOT NULL
  AND "profile_completed_at" IS NULL;
