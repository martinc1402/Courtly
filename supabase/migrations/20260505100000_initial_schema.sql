-- Courtly initial schema — v1 MVP
-- Reference: architecture memory project_courtly_architecture.md
--
-- Run via Supabase Studio SQL Editor against the courtly project.
-- Wrapped in BEGIN/COMMIT so the whole thing is atomic.

BEGIN;

-- ============================================================
-- Extensions
-- ============================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;        -- gen_random_uuid()

-- ============================================================
-- Enums
-- ============================================================

CREATE TYPE public.profile_status AS ENUM (
  'draft',
  'pending_review',
  'approved',
  'published',
  'paused_by_provider',
  'suspended',
  'rejected',
  'deleted'
);

CREATE TYPE public.availability_status AS ENUM (
  'available_today',
  'available_this_week',
  'taking_enquiries',
  'unavailable',
  'touring'
);

CREATE TYPE public.verification_status AS ENUM (
  'unverified',
  'pending',
  'verified',
  'failed',
  'expired'
);

CREATE TYPE public.photo_moderation_status AS ENUM (
  'pending',
  'approved',
  'rejected'
);

-- Architecture memory: MVP is independents-only but the agency framing
-- is documented; keep the enum value so future expansion needs no migration.
CREATE TYPE public.provider_type AS ENUM (
  'independent',
  'agency'
);

CREATE TYPE public.application_status AS ENUM (
  'submitted',
  'in_review',
  'requested_clarification',
  'approved',
  'rejected'
);

CREATE TYPE public.contact_method_type AS ENUM (
  'whatsapp',
  'telegram',
  'phone',
  'email',
  'website'
);

CREATE TYPE public.subscription_plan AS ENUM (
  'founding_free',  -- 6-month launch tier
  'starter',        -- €29/mo
  'pro'             -- €69/mo
);

CREATE TYPE public.subscription_status AS ENUM (
  'active',
  'past_due',
  'cancelled',
  'expired'
);

CREATE TYPE public.report_status AS ENUM (
  'open',
  'in_review',
  'resolved',
  'dismissed'
);

-- ============================================================
-- Helper functions
-- ============================================================

-- Auto-set updated_at on row update
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Check if current user has admin role.
-- Admin is set via auth.users.raw_app_meta_data->>'role' = 'admin'.
-- See README for how to grant.
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin',
    false
  );
$$;

-- ============================================================
-- cities — admin-managed reference data
-- ============================================================

CREATE TABLE public.cities (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         text NOT NULL UNIQUE,
  name         text NOT NULL,
  country_code text NOT NULL DEFAULT 'BE' CHECK (length(country_code) = 2),
  intro_copy   text,
  active       boolean NOT NULL DEFAULT true,
  sort_order   integer NOT NULL DEFAULT 100,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER cities_set_updated_at
  BEFORE UPDATE ON public.cities
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_cities_active_sort ON public.cities(active, sort_order);

-- Seed Belgian launch cities
INSERT INTO public.cities (slug, name, country_code, sort_order, intro_copy) VALUES
  ('brussels',  'Brussels',  'BE', 10, NULL),
  ('antwerp',   'Antwerp',   'BE', 20, NULL),
  ('ghent',     'Ghent',     'BE', 30, NULL),
  ('liege',     'Liège',     'BE', 40, NULL),
  ('charleroi', 'Charleroi', 'BE', 50, NULL),
  ('bruges',    'Bruges',    'BE', 60, NULL);

-- ============================================================
-- profiles — one row per provider
-- 1:1 with auth.users via user_id
-- ============================================================

CREATE TABLE public.profiles (
  id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                  uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name             text NOT NULL,
  slug                     text NOT NULL UNIQUE,
  city_id                  uuid NOT NULL REFERENCES public.cities(id) ON DELETE RESTRICT,
  provider_type            public.provider_type NOT NULL DEFAULT 'independent',
  status                   public.profile_status NOT NULL DEFAULT 'draft',
  verification_status      public.verification_status NOT NULL DEFAULT 'unverified',
  age_verified             boolean NOT NULL DEFAULT false,
  photo_verified           boolean NOT NULL DEFAULT false,
  featured                 boolean NOT NULL DEFAULT false,
  availability_status      public.availability_status NOT NULL DEFAULT 'taking_enquiries',
  last_active_at           timestamptz,
  rates_from_minor_units   integer CHECK (rates_from_minor_units IS NULL OR rates_from_minor_units >= 0),
  rates_currency           text NOT NULL DEFAULT 'EUR' CHECK (length(rates_currency) = 3),
  rates_text               text,
  -- Multi-select fields stored as text[] (canonical lists hardcoded app-side).
  -- See project_courtly_provider_location_model.md.
  service_areas            text[] NOT NULL DEFAULT '{}',
  modalities               text[] NOT NULL DEFAULT '{}',
  languages                text[] NOT NULL DEFAULT '{}',
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_max_5_service_areas
    CHECK (cardinality(service_areas) <= 5),
  CONSTRAINT chk_modalities_subset
    CHECK (modalities <@ ARRAY['incall_fixed', 'incall_rotating', 'outcall']::text[]),
  CONSTRAINT chk_languages_subset
    CHECK (languages <@ ARRAY['en', 'fr', 'nl', 'de', 'it', 'es', 'pt', 'pl', 'ru', 'tr', 'ar']::text[])
);

CREATE TRIGGER profiles_set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profiles_city_published
  ON public.profiles(city_id) WHERE status = 'published';
CREATE INDEX idx_profiles_featured_published
  ON public.profiles(featured) WHERE featured = true AND status = 'published';
CREATE INDEX idx_profiles_availability_published
  ON public.profiles(availability_status) WHERE status = 'published';
CREATE INDEX idx_profiles_last_active_published
  ON public.profiles(last_active_at DESC) WHERE status = 'published';
CREATE INDEX idx_profiles_service_areas_gin
  ON public.profiles USING GIN (service_areas);
CREATE INDEX idx_profiles_modalities_gin
  ON public.profiles USING GIN (modalities);
CREATE INDEX idx_profiles_languages_gin
  ON public.profiles USING GIN (languages);

-- ============================================================
-- profile_translations — per-locale tagline/bio/notes
-- ============================================================

CREATE TABLE public.profile_translations (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id          uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  locale              text NOT NULL CHECK (locale IN ('en', 'fr', 'nl', 'de')),
  tagline             text,
  bio                 text,
  availability_notes  text,
  rates_notes         text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  UNIQUE (profile_id, locale)
);

CREATE TRIGGER profile_translations_set_updated_at
  BEFORE UPDATE ON public.profile_translations
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profile_translations_profile ON public.profile_translations(profile_id);

-- ============================================================
-- profile_photos
-- ============================================================

CREATE TABLE public.profile_photos (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id         uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  storage_path       text NOT NULL,
  sort_order         integer NOT NULL DEFAULT 0,
  moderation_status  public.photo_moderation_status NOT NULL DEFAULT 'pending',
  is_cover           boolean NOT NULL DEFAULT false,
  width              integer,
  height             integer,
  blur_data_url      text,
  alt_text           text,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER profile_photos_set_updated_at
  BEFORE UPDATE ON public.profile_photos
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profile_photos_profile_sort
  ON public.profile_photos(profile_id, sort_order);
CREATE INDEX idx_profile_photos_pending
  ON public.profile_photos(moderation_status) WHERE moderation_status = 'pending';
-- Only one cover photo per profile (partial unique index)
CREATE UNIQUE INDEX idx_profile_photos_one_cover
  ON public.profile_photos(profile_id) WHERE is_cover = true;

-- ============================================================
-- contact_methods
-- ============================================================

CREATE TABLE public.contact_methods (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id  uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  method      public.contact_method_type NOT NULL,
  value       text NOT NULL,
  is_public   boolean NOT NULL DEFAULT true,
  is_primary  boolean NOT NULL DEFAULT false,
  sort_order  integer NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER contact_methods_set_updated_at
  BEFORE UPDATE ON public.contact_methods
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_contact_methods_profile_sort
  ON public.contact_methods(profile_id, sort_order);
-- Only one primary contact per profile
CREATE UNIQUE INDEX idx_contact_methods_one_primary
  ON public.contact_methods(profile_id) WHERE is_primary = true;

-- ============================================================
-- provider_applications — submission funnel before profile is created
-- ============================================================

CREATE TABLE public.provider_applications (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  applicant_email        text NOT NULL,
  applicant_name         text,
  city_id                uuid REFERENCES public.cities(id) ON DELETE SET NULL,
  status                 public.application_status NOT NULL DEFAULT 'submitted',
  -- The unstructured form payload from the 7-step apply flow.
  -- Once approved, fields are extracted into profile + related tables.
  payload                jsonb NOT NULL DEFAULT '{}'::jsonb,
  age_confirmed          boolean NOT NULL DEFAULT false,
  consent_terms_at       timestamptz,
  consent_privacy_at     timestamptz,
  consent_safety_at      timestamptz,
  reviewed_by            uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at            timestamptz,
  review_notes           text,
  resulting_profile_id   uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER provider_applications_set_updated_at
  BEFORE UPDATE ON public.provider_applications
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_provider_applications_status
  ON public.provider_applications(status, created_at DESC);
CREATE INDEX idx_provider_applications_email
  ON public.provider_applications(applicant_email);

-- ============================================================
-- verification_checks — manual ID + selfie at MVP
-- IMPORTANT: document_path must be cleared after review (not retained long-term).
-- ============================================================

CREATE TABLE public.verification_checks (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id   uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  method       text NOT NULL CHECK (method IN ('manual_id_selfie', 'third_party')),
  status       public.verification_status NOT NULL DEFAULT 'pending',
  reviewed_by  uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at  timestamptz,
  notes        text,
  -- Storage path to the uploaded document. MUST be nulled after review per
  -- the data minimisation rule in project_courtly_compliance.md.
  document_path text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER verification_checks_set_updated_at
  BEFORE UPDATE ON public.verification_checks
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_verification_checks_profile
  ON public.verification_checks(profile_id, created_at DESC);
CREATE INDEX idx_verification_checks_pending
  ON public.verification_checks(status, created_at) WHERE status = 'pending';

-- ============================================================
-- profile_reports
-- ============================================================

CREATE TABLE public.profile_reports (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id      uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  reported_url    text,
  reason          text NOT NULL,
  details         text,
  reporter_email  text,
  status          public.report_status NOT NULL DEFAULT 'open',
  admin_notes     text,
  resolved_by     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  resolved_at     timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_report_target
    CHECK (profile_id IS NOT NULL OR reported_url IS NOT NULL)
);

CREATE TRIGGER profile_reports_set_updated_at
  BEFORE UPDATE ON public.profile_reports
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profile_reports_open
  ON public.profile_reports(status, created_at DESC) WHERE status = 'open';

-- ============================================================
-- subscriptions — one per profile
-- ============================================================

CREATE TABLE public.subscriptions (
  id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id               uuid NOT NULL UNIQUE REFERENCES public.profiles(id) ON DELETE CASCADE,
  plan                     public.subscription_plan NOT NULL DEFAULT 'founding_free',
  status                   public.subscription_status NOT NULL DEFAULT 'active',
  -- Processor placeholder until CCBill / Segpay is selected.
  -- See project_courtly_pricing_payments.md.
  processor                text,
  processor_subscription_id text,
  founding_free_until      timestamptz,
  current_period_start     timestamptz,
  current_period_end       timestamptz,
  cancel_at_period_end     boolean NOT NULL DEFAULT false,
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER subscriptions_set_updated_at
  BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_subscriptions_status_plan
  ON public.subscriptions(status, plan);

-- ============================================================
-- profile_events — analytics, insert-mostly
-- bigserial id since this can become high-volume
-- ============================================================

CREATE TABLE public.profile_events (
  id                  bigserial PRIMARY KEY,
  profile_id          uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  event_type          text NOT NULL CHECK (event_type IN (
    'profile_view',
    'listing_impression',
    'contact_reveal',
    'contact_click',
    'report_submitted'
  )),
  metadata            jsonb,
  -- Coarse, ephemeral session identifier — not a long-term tracking ID
  visitor_session_id  text,
  occurred_at         timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_profile_events_profile_time
  ON public.profile_events(profile_id, occurred_at DESC);
CREATE INDEX idx_profile_events_type_time
  ON public.profile_events(event_type, occurred_at DESC);

-- ============================================================
-- Enable RLS on every table.
-- Policies are defined in 20260505100001_rls_policies.sql.
-- RLS-without-policies = no access, which is the safe default.
-- ============================================================

ALTER TABLE public.cities                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_translations  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_photos        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_methods       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.provider_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.verification_checks   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_reports       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_events        ENABLE ROW LEVEL SECURITY;

COMMIT;
