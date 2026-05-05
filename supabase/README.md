# Supabase migrations

SQL migrations for Courtly. Designed to be run via the Supabase Studio SQL Editor against the linked project (`qahwbiurcqjbaucmiisg`).

## Naming convention

Files use the standard Supabase CLI format `YYYYMMDDHHMMSS_description.sql` so they remain compatible with `supabase db push` if we adopt CLI-driven migrations later.

## How to run

For each file in numerical order:

1. Open Supabase Studio → **SQL Editor** → **New query**.
2. Paste the file contents.
3. Click **Run**.
4. Verify success (no error in the output panel).

Each file is wrapped in `BEGIN;` / `COMMIT;` so partial failures roll back automatically.

## Migration order

| # | File | What it does |
|---|---|---|
| 1 | `20260505100000_initial_schema.sql` | Extensions, enums, helper functions, all tables, indexes, triggers, city seeds, RLS enabled (no policies yet) |
| 2 | `20260505100001_rls_policies.sql` | RLS policies + the self-elevation guard triggers |

After running both, every public schema table will have RLS enabled with the right scoped access — anonymous users can read published profiles + active cities + approved photos, providers can manage their own data, admins can do everything.

## Granting admin access

The `is_admin()` helper checks `auth.users.raw_app_meta_data.role = 'admin'`. To grant yourself admin:

```sql
-- Replace with your auth.users email
UPDATE auth.users
SET raw_app_meta_data =
  COALESCE(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
WHERE email = 'martinc140291@gmail.com';
```

Run this via Studio SQL Editor too. After running, sign out and sign back in for the JWT to refresh with the new role claim.

## Verifying RLS is working

A quick sanity check after running both migrations, run as the **authenticated** role would (Studio's SQL Editor runs as service role which bypasses RLS — use the **API → Test query** UI or the app for real checks):

```sql
-- Should return only the 6 active cities
SELECT slug, name FROM public.cities;

-- Should return zero rows when run as anon (no published profiles yet)
SELECT id, display_name FROM public.profiles;
```

## Optional: synthetic seed data

`seed.sql` adds 12 fictional providers across the 6 launch cities so the directory has something to render during development. It's optional, idempotent, and clearly marked synthetic data.

To apply: open Studio SQL Editor → paste `seed.sql` → run.

The seed creates:

- 12 fake `auth.users` (placeholder bcrypt passwords — these accounts cannot log in until we set real passwords via the Auth admin API)
- 12 published profiles spread across Brussels (5), Antwerp (2), Ghent (2), Liège, Charleroi, Bruges
- Translations in EN for all, plus FR and/or NL for some — deliberately **incomplete coverage** to test the locale fallback rule (e.g., Camille has only FR; Maya has only NL)
- 1 cover photo per provider via `placehold.co` (Courtly palette colour swatches; not real imagery)
- 2–3 contact methods per provider (mix of WhatsApp, Telegram, Phone, Email)
- All on `founding_free` subscriptions

Sanity check queries are at the bottom of `seed.sql` (commented out by default).

To remove seed data later, delete the auth users — `ON DELETE CASCADE` will clean up all related rows:

```sql
DELETE FROM auth.users WHERE email LIKE '%+seed@thecourtly.com';
```

## Storage buckets — TODO

Profile photos and verification documents will need Supabase Storage buckets:

- `profile-photos` — public read for `approved` photos (or signed URLs)
- `verification-documents` — private, admin-only access; documents nulled after review per the data minimisation rule

These will be authored in a future migration `20260505100002_storage_buckets.sql` once we wire photo uploads. Not blocking for the schema work itself.

## Future migrations

Add a new file with the next sequential timestamp. Keep each migration focused on a single concern (one table, one feature, one column) so rollback or selective re-runs are practical.

## What's NOT in this schema

Deliberately deferred until the corresponding feature lands:

- Storage bucket policies (waiting for photo upload flow)
- Service area reference data (canonical area lists per city are hardcoded app-side for MVP; can be promoted to a `service_areas` table if needed)
- Audit log table (admin actions trace) — needed before launch but not for foundation
- Soft-delete trigger that auto-stamps `status = 'deleted'` instead of allowing hard delete (currently only admin can hard-delete)
- Tour calendar / cross-city service areas (v2 — see `project_courtly_provider_location_model.md`)
