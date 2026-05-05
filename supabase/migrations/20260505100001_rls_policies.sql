-- Courtly RLS policies — v1 MVP
-- Reference: architecture memory project_courtly_architecture.md (RLS principles section).
-- Run AFTER 20260505100000_initial_schema.sql.
--
-- Principles encoded here:
--   - Public can only read published profiles + approved photos + active cities.
--   - Providers can read/edit their own row (any status).
--   - Providers cannot self-elevate verification, featured, or status to approved/published.
--   - Admins can do everything (admin role set on auth.users.raw_app_meta_data->>'role').
--   - Applications, reports, events: anon-insertable, admin-readable.
--   - Verification: provider can read own, admin manages.

BEGIN;

-- ============================================================
-- cities — public read of active cities; admin-only writes
-- ============================================================

CREATE POLICY cities_select_public ON public.cities
  FOR SELECT USING (active = true);

CREATE POLICY cities_select_admin ON public.cities
  FOR SELECT USING (public.is_admin());

CREATE POLICY cities_admin_write ON public.cities
  FOR INSERT WITH CHECK (public.is_admin());
CREATE POLICY cities_admin_update ON public.cities
  FOR UPDATE USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY cities_admin_delete ON public.cities
  FOR DELETE USING (public.is_admin());

-- ============================================================
-- profiles
-- ============================================================

-- Public can read only published profiles
CREATE POLICY profiles_select_published ON public.profiles
  FOR SELECT USING (status = 'published');

-- Providers can read their own profile in any status
CREATE POLICY profiles_select_own ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);

-- Admins can read any profile
CREATE POLICY profiles_select_admin ON public.profiles
  FOR SELECT USING (public.is_admin());

-- Providers can insert their own profile, but only as a clean draft.
-- Verification + featured + non-draft status are blocked at WITH CHECK time.
CREATE POLICY profiles_insert_own ON public.profiles
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND status = 'draft'
    AND verification_status = 'unverified'
    AND age_verified = false
    AND photo_verified = false
    AND featured = false
  );

-- Admin can insert any profile (e.g., admin-created provider after offline approval)
CREATE POLICY profiles_insert_admin ON public.profiles
  FOR INSERT WITH CHECK (public.is_admin());

-- Providers can update their own row.
-- Column-level safety (no self-elevation) is enforced by a BEFORE UPDATE trigger
-- defined below — RLS only scopes access to the row.
CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Admin can update any
CREATE POLICY profiles_update_admin ON public.profiles
  FOR UPDATE USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Hard delete is admin-only. Soft delete is via status='deleted' which goes
-- through profiles_update_own (provider can self-delete their account).
CREATE POLICY profiles_delete_admin ON public.profiles
  FOR DELETE USING (public.is_admin());

-- Self-elevation guard: prevent providers from changing verification, featured,
-- or status to admin-only values, or modifying immutable fields.
CREATE OR REPLACE FUNCTION public.profiles_prevent_self_elevation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Admins bypass these checks
  IF public.is_admin() THEN
    RETURN NEW;
  END IF;

  IF NEW.verification_status IS DISTINCT FROM OLD.verification_status THEN
    RAISE EXCEPTION 'verification_status is admin-managed';
  END IF;

  IF NEW.age_verified IS DISTINCT FROM OLD.age_verified THEN
    RAISE EXCEPTION 'age_verified is admin-managed';
  END IF;

  IF NEW.photo_verified IS DISTINCT FROM OLD.photo_verified THEN
    RAISE EXCEPTION 'photo_verified is admin-managed';
  END IF;

  IF NEW.featured IS DISTINCT FROM OLD.featured THEN
    RAISE EXCEPTION 'featured flag is admin-managed';
  END IF;

  -- Provider can move status only between draft / pending_review /
  -- paused_by_provider / deleted. Cannot self-publish or self-approve.
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    IF NEW.status NOT IN ('draft', 'pending_review', 'paused_by_provider', 'deleted') THEN
      RAISE EXCEPTION 'Cannot self-elevate status to %', NEW.status;
    END IF;
  END IF;

  -- Immutable fields
  IF NEW.user_id IS DISTINCT FROM OLD.user_id THEN
    RAISE EXCEPTION 'user_id is immutable';
  END IF;

  IF NEW.slug IS DISTINCT FROM OLD.slug THEN
    RAISE EXCEPTION 'slug is immutable';
  END IF;

  IF NEW.id IS DISTINCT FROM OLD.id THEN
    RAISE EXCEPTION 'id is immutable';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER profiles_prevent_self_elevation_trigger
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.profiles_prevent_self_elevation();

-- ============================================================
-- profile_translations — gated by parent profile visibility/ownership
-- ============================================================

CREATE POLICY profile_translations_select_public ON public.profile_translations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_translations.profile_id AND p.status = 'published'
    )
  );

CREATE POLICY profile_translations_select_own ON public.profile_translations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_translations.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_translations_select_admin ON public.profile_translations
  FOR SELECT USING (public.is_admin());

CREATE POLICY profile_translations_modify_own ON public.profile_translations
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_translations.profile_id AND p.user_id = auth.uid()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_translations.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_translations_admin_all ON public.profile_translations
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ============================================================
-- profile_photos — public sees ONLY approved photos on published profiles
-- ============================================================

CREATE POLICY profile_photos_select_public ON public.profile_photos
  FOR SELECT USING (
    moderation_status = 'approved'
    AND EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.status = 'published'
    )
  );

CREATE POLICY profile_photos_select_own ON public.profile_photos
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_photos_select_admin ON public.profile_photos
  FOR SELECT USING (public.is_admin());

-- Provider can insert/update photos on their own profile, but moderation_status
-- must remain 'pending' on insert and they cannot self-approve.
CREATE POLICY profile_photos_insert_own ON public.profile_photos
  FOR INSERT WITH CHECK (
    moderation_status = 'pending'
    AND EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_photos_update_own ON public.profile_photos
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.user_id = auth.uid()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_photos_delete_own ON public.profile_photos
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = profile_photos.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY profile_photos_admin_all ON public.profile_photos
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Self-approval guard for photos
CREATE OR REPLACE FUNCTION public.profile_photos_prevent_self_approval()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF public.is_admin() THEN
    RETURN NEW;
  END IF;
  IF NEW.moderation_status IS DISTINCT FROM OLD.moderation_status THEN
    RAISE EXCEPTION 'photo moderation_status is admin-managed';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER profile_photos_prevent_self_approval_trigger
  BEFORE UPDATE ON public.profile_photos
  FOR EACH ROW EXECUTE FUNCTION public.profile_photos_prevent_self_approval();

-- ============================================================
-- contact_methods — gated by parent profile
-- ============================================================

CREATE POLICY contact_methods_select_public ON public.contact_methods
  FOR SELECT USING (
    is_public = true
    AND EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = contact_methods.profile_id AND p.status = 'published'
    )
  );

CREATE POLICY contact_methods_select_own ON public.contact_methods
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = contact_methods.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY contact_methods_select_admin ON public.contact_methods
  FOR SELECT USING (public.is_admin());

CREATE POLICY contact_methods_modify_own ON public.contact_methods
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = contact_methods.profile_id AND p.user_id = auth.uid()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = contact_methods.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY contact_methods_admin_all ON public.contact_methods
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ============================================================
-- provider_applications — anon insert, admin-only read
-- ============================================================

-- Anyone (including unauthenticated) can submit an application
CREATE POLICY provider_applications_insert_public ON public.provider_applications
  FOR INSERT WITH CHECK (true);

-- Only admins can read or update applications
CREATE POLICY provider_applications_select_admin ON public.provider_applications
  FOR SELECT USING (public.is_admin());

CREATE POLICY provider_applications_update_admin ON public.provider_applications
  FOR UPDATE USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY provider_applications_delete_admin ON public.provider_applications
  FOR DELETE USING (public.is_admin());

-- ============================================================
-- verification_checks — provider read-own, admin manages
-- ============================================================

CREATE POLICY verification_checks_select_own ON public.verification_checks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = verification_checks.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY verification_checks_admin_all ON public.verification_checks
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ============================================================
-- profile_reports — anon insert, admin-only read
-- ============================================================

CREATE POLICY profile_reports_insert_public ON public.profile_reports
  FOR INSERT WITH CHECK (true);

CREATE POLICY profile_reports_select_admin ON public.profile_reports
  FOR SELECT USING (public.is_admin());

CREATE POLICY profile_reports_update_admin ON public.profile_reports
  FOR UPDATE USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY profile_reports_delete_admin ON public.profile_reports
  FOR DELETE USING (public.is_admin());

-- ============================================================
-- subscriptions — provider read-own, admin manages
-- (Provider doesn't change their plan directly — that goes via the billing flow.)
-- ============================================================

CREATE POLICY subscriptions_select_own ON public.subscriptions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = subscriptions.profile_id AND p.user_id = auth.uid()
    )
  );

CREATE POLICY subscriptions_admin_all ON public.subscriptions
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ============================================================
-- profile_events — anon insert, admin-only read
-- ============================================================

CREATE POLICY profile_events_insert_public ON public.profile_events
  FOR INSERT WITH CHECK (true);

CREATE POLICY profile_events_select_admin ON public.profile_events
  FOR SELECT USING (public.is_admin());

COMMIT;
