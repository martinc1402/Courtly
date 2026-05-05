-- Courtly synthetic seed data — 12 fictional providers
-- Run this AFTER migrations 20260505100000 and 20260505100001.
--
-- IMPORTANT: this is fictional, GDPR-clean test data.
--   - No real-person likeness, no real names, no real photos.
--   - Photo URLs use placehold.co — clearly placeholder colour swatches
--     in the Courtly palette. Swap for real imagery before production.
--   - Auth user passwords are placeholder bcrypt hashes — seed users
--     CANNOT log in. We'll update passwords (or recreate via Auth API)
--     when the sign-in flow lands.
--
-- The script is idempotent: re-running it does not duplicate rows
-- (uses ON CONFLICT (id) DO NOTHING throughout).

BEGIN;

-- ============================================================
-- 1. Auth users — 12 placeholder accounts
-- ============================================================
-- Stable UUIDs by persona so subsequent inserts can reference them.
-- encrypted_password is a placeholder; these users cannot log in until
-- we set real passwords via the Auth admin API.

INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at
) VALUES
  ('aaaa1111-1111-4111-8111-111111111111', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'isabella+seed@thecourtly.com',  '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa2222-2222-4222-8222-222222222222', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sophia+seed@thecourtly.com',    '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa3333-3333-4333-8333-333333333333', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'camille+seed@thecourtly.com',   '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa4444-4444-4444-8444-444444444444', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'anais+seed@thecourtly.com',     '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa5555-5555-4555-8555-555555555555', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlotte+seed@thecourtly.com', '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa6666-6666-4666-8666-666666666666', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'eline+seed@thecourtly.com',     '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa7777-7777-4777-8777-777777777777', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maya+seed@thecourtly.com',      '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa8888-8888-4888-8888-888888888888', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lieke+seed@thecourtly.com',     '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaa9999-9999-4999-8999-999999999999', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'stella+seed@thecourtly.com',    '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'margaux+seed@thecourtly.com',   '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaabbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'romane+seed@thecourtly.com',    '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('aaaacccc-cccc-4ccc-8ccc-cccccccccccc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lotte+seed@thecourtly.com',     '$2a$10$courtlyseedplaceholderhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 2. Profiles — 12 fictional providers
-- ============================================================
-- Distribution: Brussels 5, Antwerp 2, Ghent 2, Liège/Charleroi/Bruges 1 each.
-- All published, all age_verified+photo_verified+verified for testing.

INSERT INTO public.profiles (
  id, user_id, display_name, slug, city_id, provider_type,
  status, verification_status, age_verified, photo_verified,
  featured, availability_status, last_active_at,
  rates_from_minor_units, rates_currency, rates_text,
  service_areas, modalities, languages,
  created_at, updated_at
) VALUES
  ( 'bbbb1111-1111-4111-8111-111111111111', 'aaaa1111-1111-4111-8111-111111111111', 'Isabella', 'isabella-x4f7q9',
    (SELECT id FROM public.cities WHERE slug = 'brussels'), 'independent',
    'published', 'verified', true, true, true, 'available_this_week', now() - interval '2 hours',
    35000, 'EUR', '1h €350 / 2h €600 / 3h €850 / Dinner date €800 / Overnight €2,400',
    ARRAY['sablon','brussels-centre','ixelles']::text[],
    ARRAY['incall_fixed','outcall']::text[],
    ARRAY['fr','en','nl']::text[],
    now() - interval '90 days', now() - interval '2 hours' ),

  ( 'bbbb2222-2222-4222-8222-222222222222', 'aaaa2222-2222-4222-8222-222222222222', 'Sophia', 'sophia-k2m9p4',
    (SELECT id FROM public.cities WHERE slug = 'brussels'), 'independent',
    'published', 'verified', true, true, true, 'available_today', now() - interval '15 minutes',
    32000, 'EUR', '1h €320 / 2h €580',
    ARRAY['saint-gilles','chatelain']::text[],
    ARRAY['incall_fixed','outcall']::text[],
    ARRAY['fr','en']::text[],
    now() - interval '60 days', now() - interval '15 minutes' ),

  ( 'bbbb3333-3333-4333-8333-333333333333', 'aaaa3333-3333-4333-8333-333333333333', 'Camille', 'camille-h7w3z8',
    (SELECT id FROM public.cities WHERE slug = 'brussels'), 'independent',
    'published', 'verified', true, true, false, 'taking_enquiries', now() - interval '1 day',
    40000, 'EUR', '1h €400 / 2h €750 / Dinner date €900',
    ARRAY['sablon','ixelles']::text[],
    ARRAY['incall_fixed']::text[],
    ARRAY['fr']::text[],
    now() - interval '120 days', now() - interval '1 day' ),

  ( 'bbbb4444-4444-4444-8444-444444444444', 'aaaa4444-4444-4444-8444-444444444444', 'Anaïs', 'anais-r5t8u2',
    (SELECT id FROM public.cities WHERE slug = 'brussels'), 'independent',
    'published', 'verified', true, true, false, 'available_today', now() - interval '45 minutes',
    28000, 'EUR', '1h €280 / 2h €520',
    ARRAY['brussels-centre','etterbeek']::text[],
    ARRAY['outcall']::text[],
    ARRAY['fr','nl']::text[],
    now() - interval '45 days', now() - interval '45 minutes' ),

  ( 'bbbb5555-5555-4555-8555-555555555555', 'aaaa5555-5555-4555-8555-555555555555', 'Charlotte', 'charlotte-d6f1k9',
    (SELECT id FROM public.cities WHERE slug = 'brussels'), 'independent',
    'published', 'verified', true, true, false, 'taking_enquiries', now() - interval '4 hours',
    38000, 'EUR', '1h €380 / 2h €700 / Overnight €2,200',
    ARRAY['saint-gilles','forest','ixelles']::text[],
    ARRAY['incall_rotating','outcall']::text[],
    ARRAY['en','fr']::text[],
    now() - interval '75 days', now() - interval '4 hours' ),

  ( 'bbbb6666-6666-4666-8666-666666666666', 'aaaa6666-6666-4666-8666-666666666666', 'Eline', 'eline-j4p7m1',
    (SELECT id FROM public.cities WHERE slug = 'antwerp'), 'independent',
    'published', 'verified', true, true, false, 'available_this_week', now() - interval '6 hours',
    30000, 'EUR', '1h €300 / 2h €560',
    ARRAY['het-zuid','sint-andries']::text[],
    ARRAY['incall_fixed','outcall']::text[],
    ARRAY['nl','en']::text[],
    now() - interval '50 days', now() - interval '6 hours' ),

  ( 'bbbb7777-7777-4777-8777-777777777777', 'aaaa7777-7777-4777-8777-777777777777', 'Maya', 'maya-q8n3v6',
    (SELECT id FROM public.cities WHERE slug = 'antwerp'), 'independent',
    'published', 'verified', true, true, true, 'available_today', now() - interval '30 minutes',
    34000, 'EUR', '1h €340 / 2h €620 / Overnight €2,000',
    ARRAY['het-eilandje','zurenborg','historisch-centrum']::text[],
    ARRAY['incall_rotating']::text[],
    ARRAY['nl','fr','en']::text[],
    now() - interval '40 days', now() - interval '30 minutes' ),

  ( 'bbbb8888-8888-4888-8888-888888888888', 'aaaa8888-8888-4888-8888-888888888888', 'Lieke', 'lieke-s2c5b8',
    (SELECT id FROM public.cities WHERE slug = 'ghent'), 'independent',
    'published', 'verified', true, true, false, 'available_today', now() - interval '1 hour',
    26000, 'EUR', '1h €260 / 2h €480',
    ARRAY['patershol','citadelpark']::text[],
    ARRAY['outcall']::text[],
    ARRAY['nl','en']::text[],
    now() - interval '30 days', now() - interval '1 hour' ),

  ( 'bbbb9999-9999-4999-8999-999999999999', 'aaaa9999-9999-4999-8999-999999999999', 'Stella', 'stella-y9w4r2',
    (SELECT id FROM public.cities WHERE slug = 'ghent'), 'independent',
    'published', 'verified', true, true, false, 'available_this_week', now() - interval '8 hours',
    32000, 'EUR', '1h €320 / 2h €590',
    ARRAY['sint-pieters','patershol']::text[],
    ARRAY['incall_fixed']::text[],
    ARRAY['nl','fr','en']::text[],
    now() - interval '55 days', now() - interval '8 hours' ),

  ( 'bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Margaux', 'margaux-l3h6t1',
    (SELECT id FROM public.cities WHERE slug = 'liege'), 'independent',
    'published', 'verified', true, true, false, 'taking_enquiries', now() - interval '2 days',
    28000, 'EUR', '1h €280 / 2h €520',
    ARRAY['le-carre','outremeuse']::text[],
    ARRAY['incall_fixed','outcall']::text[],
    ARRAY['fr']::text[],
    now() - interval '85 days', now() - interval '2 days' ),

  ( 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'aaaabbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Romane', 'romane-z7g4d9',
    (SELECT id FROM public.cities WHERE slug = 'charleroi'), 'independent',
    'published', 'verified', true, true, false, 'taking_enquiries', now() - interval '3 days',
    25000, 'EUR', '1h €250 / 2h €450',
    ARRAY['charleroi-centre','ville-basse']::text[],
    ARRAY['outcall']::text[],
    ARRAY['fr']::text[],
    now() - interval '100 days', now() - interval '3 days' ),

  ( 'bbbbcccc-cccc-4ccc-8ccc-cccccccccccc', 'aaaacccc-cccc-4ccc-8ccc-cccccccccccc', 'Lotte', 'lotte-v8b1e5',
    (SELECT id FROM public.cities WHERE slug = 'bruges'), 'independent',
    'published', 'verified', true, true, false, 'available_this_week', now() - interval '5 hours',
    29000, 'EUR', '1h €290 / 2h €540',
    ARRAY['centrum','sint-anna']::text[],
    ARRAY['incall_fixed']::text[],
    ARRAY['nl','en']::text[],
    now() - interval '65 days', now() - interval '5 hours' )
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 3. Profile translations — EN for all, FR/NL for some
-- ============================================================
-- Tests the locale fallback rule: providers with no translation in the
-- visitor's language render their available locale with a subtle note.

INSERT INTO public.profile_translations (profile_id, locale, tagline, bio) VALUES
  -- Isabella — EN, FR, NL (full coverage, canonical persona)
  ('bbbb1111-1111-4111-8111-111111111111', 'en', 'Art history, architecture, and unhurried conversation in the Sablon.',
    'I''m an art historian by training and by inclination — I work freelance with smaller Belgian galleries and spend more time than I should in the Magritte and the Bozar.'),
  ('bbbb1111-1111-4111-8111-111111111111', 'fr', 'Histoire de l''art, architecture et conversations sans hâte au Sablon.',
    'Je suis historienne de l''art par formation et par goût — je travaille en freelance avec des galeries belges plus modestes et je passe plus de temps que je ne devrais au Magritte et au Bozar.'),
  ('bbbb1111-1111-4111-8111-111111111111', 'nl', 'Kunstgeschiedenis, architectuur en ongehaaste gesprekken in de Zavel.',
    'Ik ben kunsthistoricus van opleiding en uit interesse — ik werk freelance met kleinere Belgische galerijen en breng meer tijd door in het Magritte en het Bozar dan ik zou moeten.'),

  -- Sophia — EN, FR
  ('bbbb2222-2222-4222-8222-222222222222', 'en', 'Fashion eye, lazy mornings, dinner at small tables.',
    'I buy for an independent boutique in Saint-Gilles. I prefer slow conversations to small talk and the kind of restaurant that holds twenty people.'),
  ('bbbb2222-2222-4222-8222-222222222222', 'fr', 'Œil de mode, matinées paresseuses, dîners à petites tables.',
    'J''achète pour une boutique indépendante à Saint-Gilles. Je préfère les conversations lentes au small talk et le genre de restaurant qui accueille vingt personnes.'),

  -- Camille — FR only (test EN fallback)
  ('bbbb3333-3333-4333-8333-333333333333', 'fr', 'Architecte. Bonne table, longue conversation, retour calme.',
    'Architecte basée à Bruxelles depuis dix ans. Je préfère les rendez-vous structurés en début de soirée et la fin d''une bonne bouteille à l''heure du dessert.'),

  -- Anaïs — FR, NL
  ('bbbb4444-4444-4444-8444-444444444444', 'fr', 'Danseuse contemporaine. Soirées en ville, week-ends à la côte.',
    'Je danse, j''étudie, et je sors. Je préfère les rendez-vous qui se passent quelque part — pas chez moi.'),
  ('bbbb4444-4444-4444-8444-444444444444', 'nl', 'Hedendaagse danseres. Avonden in de stad, weekenden aan zee.',
    'Ik dans, ik studeer, en ik ga uit. Ik geef de voorkeur aan afspraken die ergens plaatsvinden — niet bij mij thuis.'),

  -- Charlotte — EN, FR
  ('bbbb5555-5555-4555-8555-555555555555', 'en', 'Art director. Found-light conversations and the right kind of silence.',
    'I direct art for a small Brussels publishing house. I''m not in a hurry, and I prefer evenings that don''t need an excuse.'),
  ('bbbb5555-5555-4555-8555-555555555555', 'fr', 'Directrice artistique. Conversations dans la lumière trouvée et le bon type de silence.',
    'Je dirige l''art pour une petite maison d''édition bruxelloise. Je ne suis pas pressée et je préfère les soirées qui n''ont besoin d''aucun prétexte.'),

  -- Eline — EN, NL
  ('bbbb6666-6666-4666-8666-666666666666', 'en', 'Designer in Antwerp South. Long walks, good shoes, low light.',
    'I work in product design — small studio off the Vlaamsekaai. Most of my evenings end at the same three restaurants, and I don''t feel bad about it.'),
  ('bbbb6666-6666-4666-8666-666666666666', 'nl', 'Ontwerpster in Het Zuid. Lange wandelingen, goede schoenen, gedempt licht.',
    'Ik werk in productontwerp — een kleine studio bij de Vlaamsekaai. De meeste van mijn avonden eindigen in dezelfde drie restaurants, en daar voel ik me niet schuldig over.'),

  -- Maya — NL only (test EN fallback)
  ('bbbb7777-7777-4777-8777-777777777777', 'nl', 'Schrijver. Zelden thuis, vaak aan een tafel met goede mensen.',
    'Ik schrijf voor een Vlaams literair tijdschrift en een handvol Engelse publicaties. Ik werk laat, slaap laat, en eet later.'),

  -- Lieke — EN, NL
  ('bbbb8888-8888-4888-8888-888888888888', 'en', 'Photographer in Ghent. Patershol cafés and the rhythm of a slow city.',
    'Documentary photography is what I do for work; portraiture is what I do for myself. I prefer outcall — your place, somewhere quiet, an honest evening.'),
  ('bbbb8888-8888-4888-8888-888888888888', 'nl', 'Fotografe in Gent. Caféleven in het Patershol en het ritme van een trage stad.',
    'Documentaire fotografie is mijn werk; portretkunst is wat ik voor mezelf doe. Ik geef de voorkeur aan outcall — bij jou, ergens rustigs, een eerlijke avond.'),

  -- Stella — NL, FR, EN
  ('bbbb9999-9999-4999-8999-999999999999', 'en', 'Cellist by training, freelance by necessity. I play at small venues and I read late.',
    'I''m a musician — classical training, jazz instincts, current projects in both. I keep my own hours.'),
  ('bbbb9999-9999-4999-8999-999999999999', 'nl', 'Celliste van opleiding, freelancer uit noodzaak. Ik speel in kleine zalen en lees laat.',
    'Ik ben muzikante — klassieke opleiding, jazz-instincten, lopende projecten in beide. Ik houd mijn eigen uren aan.'),
  ('bbbb9999-9999-4999-8999-999999999999', 'fr', 'Violoncelliste de formation, freelance par nécessité. Je joue dans de petites salles et je lis tard.',
    'Je suis musicienne — formation classique, instincts jazz, projets en cours dans les deux. Je garde mes propres horaires.'),

  -- Margaux — FR only
  ('bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'fr', 'Sommelière. Bonne table, bonne lumière, bonne nuit.',
    'Je travaille dans les vins depuis quinze ans. Je préfère les rendez-vous qui commencent par un repas — et qui ne sont pas pressés.'),

  -- Romane — FR only
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'fr', 'Illustratrice. Travaille tard, sort plus tard.',
    'J''illustre pour des magazines indépendants et j''aime les soirées qui commencent à dix heures du soir.'),

  -- Lotte — EN, NL
  ('bbbbcccc-cccc-4ccc-8ccc-cccccccccccc', 'en', 'Pastry chef in Bruges. Quiet city, quiet pace, no rush.',
    'I run a small bakery in the centre — early mornings, easy afternoons. I keep evenings open for the right kind of company.'),
  ('bbbbcccc-cccc-4ccc-8ccc-cccccccccccc', 'nl', 'Patissière in Brugge. Rustige stad, rustig tempo, geen haast.',
    'Ik run een kleine bakkerij in het centrum — vroege ochtenden, makkelijke namiddagen. Ik houd avonden open voor het juiste gezelschap.')
ON CONFLICT (profile_id, locale) DO NOTHING;

-- ============================================================
-- 4. Profile photos — 1 cover photo per provider (placeholder)
-- ============================================================
-- placehold.co URLs in Courtly palette (bronze on cream).
-- Real images go in Cloudflare R2 (or Supabase Storage) at production time.
-- All approved so they render publicly under RLS.

INSERT INTO public.profile_photos (id, profile_id, storage_path, sort_order, moderation_status, is_cover, alt_text)
SELECT
  gen_random_uuid(),
  p.id,
  'https://placehold.co/800x1200/A88B6E/F8F4ED/png?text=' || p.display_name,
  0,
  'approved',
  true,
  p.display_name || ' — placeholder portrait'
FROM public.profiles p
WHERE p.id IN (
  'bbbb1111-1111-4111-8111-111111111111',
  'bbbb2222-2222-4222-8222-222222222222',
  'bbbb3333-3333-4333-8333-333333333333',
  'bbbb4444-4444-4444-8444-444444444444',
  'bbbb5555-5555-4555-8555-555555555555',
  'bbbb6666-6666-4666-8666-666666666666',
  'bbbb7777-7777-4777-8777-777777777777',
  'bbbb8888-8888-4888-8888-888888888888',
  'bbbb9999-9999-4999-8999-999999999999',
  'bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'bbbbcccc-cccc-4ccc-8ccc-cccccccccccc'
)
AND NOT EXISTS (
  SELECT 1 FROM public.profile_photos pp
  WHERE pp.profile_id = p.id AND pp.is_cover = true
);

-- ============================================================
-- 5. Contact methods — 2 per provider (one primary)
-- ============================================================
-- Mix of channels per provider for filter testing.

INSERT INTO public.contact_methods (id, profile_id, method, value, is_public, is_primary, sort_order) VALUES
  -- Isabella: WhatsApp + Telegram + Email (3 channels)
  (gen_random_uuid(), 'bbbb1111-1111-4111-8111-111111111111', 'whatsapp', '+32 470 12 34 56',          true, true,  0),
  (gen_random_uuid(), 'bbbb1111-1111-4111-8111-111111111111', 'telegram', '@isabella_brx',             true, false, 1),
  (gen_random_uuid(), 'bbbb1111-1111-4111-8111-111111111111', 'email',    'isabella@privatemail.eu',   true, false, 2),

  -- Sophia: WhatsApp + Email
  (gen_random_uuid(), 'bbbb2222-2222-4222-8222-222222222222', 'whatsapp', '+32 471 23 45 67',          true, true,  0),
  (gen_random_uuid(), 'bbbb2222-2222-4222-8222-222222222222', 'email',    'sophia@privatemail.eu',     true, false, 1),

  -- Camille: Phone + Email
  (gen_random_uuid(), 'bbbb3333-3333-4333-8333-333333333333', 'phone',    '+32 472 34 56 78',          true, true,  0),
  (gen_random_uuid(), 'bbbb3333-3333-4333-8333-333333333333', 'email',    'camille@privatemail.eu',    true, false, 1),

  -- Anaïs: WhatsApp + Telegram
  (gen_random_uuid(), 'bbbb4444-4444-4444-8444-444444444444', 'whatsapp', '+32 473 45 67 89',          true, true,  0),
  (gen_random_uuid(), 'bbbb4444-4444-4444-8444-444444444444', 'telegram', '@anais_brx',                true, false, 1),

  -- Charlotte: WhatsApp + Email
  (gen_random_uuid(), 'bbbb5555-5555-4555-8555-555555555555', 'whatsapp', '+32 474 56 78 90',          true, true,  0),
  (gen_random_uuid(), 'bbbb5555-5555-4555-8555-555555555555', 'email',    'charlotte@privatemail.eu',  true, false, 1),

  -- Eline: WhatsApp + Email
  (gen_random_uuid(), 'bbbb6666-6666-4666-8666-666666666666', 'whatsapp', '+32 475 67 89 01',          true, true,  0),
  (gen_random_uuid(), 'bbbb6666-6666-4666-8666-666666666666', 'email',    'eline@privatemail.eu',      true, false, 1),

  -- Maya: WhatsApp + Telegram + Email
  (gen_random_uuid(), 'bbbb7777-7777-4777-8777-777777777777', 'whatsapp', '+32 476 78 90 12',          true, true,  0),
  (gen_random_uuid(), 'bbbb7777-7777-4777-8777-777777777777', 'telegram', '@maya_antw',                true, false, 1),
  (gen_random_uuid(), 'bbbb7777-7777-4777-8777-777777777777', 'email',    'maya@privatemail.eu',       true, false, 2),

  -- Lieke: Phone + Email
  (gen_random_uuid(), 'bbbb8888-8888-4888-8888-888888888888', 'phone',    '+32 477 89 01 23',          true, true,  0),
  (gen_random_uuid(), 'bbbb8888-8888-4888-8888-888888888888', 'email',    'lieke@privatemail.eu',      true, false, 1),

  -- Stella: WhatsApp + Email
  (gen_random_uuid(), 'bbbb9999-9999-4999-8999-999999999999', 'whatsapp', '+32 478 90 12 34',          true, true,  0),
  (gen_random_uuid(), 'bbbb9999-9999-4999-8999-999999999999', 'email',    'stella@privatemail.eu',     true, false, 1),

  -- Margaux: Phone + Email
  (gen_random_uuid(), 'bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'phone',    '+32 479 01 23 45',          true, true,  0),
  (gen_random_uuid(), 'bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'email',    'margaux@privatemail.eu',    true, false, 1),

  -- Romane: WhatsApp only
  (gen_random_uuid(), 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'whatsapp', '+32 480 12 34 56',          true, true,  0),

  -- Lotte: Phone + Email
  (gen_random_uuid(), 'bbbbcccc-cccc-4ccc-8ccc-cccccccccccc', 'phone',    '+32 481 23 45 67',          true, true,  0),
  (gen_random_uuid(), 'bbbbcccc-cccc-4ccc-8ccc-cccccccccccc', 'email',    'lotte@privatemail.eu',      true, false, 1)
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. Subscriptions — all on founding_free
-- ============================================================
-- 6-month founding window from script run time.

INSERT INTO public.subscriptions (id, profile_id, plan, status, founding_free_until)
SELECT
  gen_random_uuid(),
  p.id,
  'founding_free',
  'active',
  now() + interval '6 months'
FROM public.profiles p
WHERE p.id IN (
  'bbbb1111-1111-4111-8111-111111111111',
  'bbbb2222-2222-4222-8222-222222222222',
  'bbbb3333-3333-4333-8333-333333333333',
  'bbbb4444-4444-4444-8444-444444444444',
  'bbbb5555-5555-4555-8555-555555555555',
  'bbbb6666-6666-4666-8666-666666666666',
  'bbbb7777-7777-4777-8777-777777777777',
  'bbbb8888-8888-4888-8888-888888888888',
  'bbbb9999-9999-4999-8999-999999999999',
  'bbbbaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'bbbbcccc-cccc-4ccc-8ccc-cccccccccccc'
)
ON CONFLICT (profile_id) DO NOTHING;

COMMIT;

-- ============================================================
-- Sanity checks (uncomment to run after seeding)
-- ============================================================
-- SELECT count(*) AS profiles  FROM public.profiles;          -- expect 12
-- SELECT count(*) AS published FROM public.profiles WHERE status = 'published'; -- expect 12
-- SELECT count(*) AS featured  FROM public.profiles WHERE featured = true;      -- expect 3 (Isabella, Sophia, Maya)
-- SELECT c.name, count(p.id) AS providers
--   FROM public.cities c LEFT JOIN public.profiles p ON p.city_id = c.id AND p.status = 'published'
--   GROUP BY c.name ORDER BY providers DESC;
