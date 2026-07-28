\set ON_ERROR_STOP on

DO $$
BEGIN
  IF to_regclass('public.tenants') IS NULL THEN RAISE EXCEPTION 'tenants table missing'; END IF;
  IF to_regclass('public.privacy_records') IS NULL THEN RAISE EXCEPTION 'privacy_records table missing'; END IF;
  IF to_regclass('public.preservation_events') IS NULL THEN RAISE EXCEPTION 'preservation_events table missing'; END IF;
  IF to_regclass('public.retention_rules') IS NULL THEN RAISE EXCEPTION 'retention_rules table missing'; END IF;
END $$;

DO $$
DECLARE enabled_count integer;
BEGIN
  SELECT count(*) INTO enabled_count
  FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
  WHERE n.nspname='public' AND c.relname IN ('content_items','rights_records','audit_events','privacy_records','preservation_events') AND c.relrowsecurity;
  IF enabled_count <> 5 THEN RAISE EXCEPTION 'RLS not enabled on all tenant tables: %', enabled_count; END IF;
END $$;

DO $$
DECLARE policy_count integer;
BEGIN
  SELECT count(*) INTO policy_count FROM pg_policies
  WHERE schemaname='public' AND policyname LIKE '%tenant_isolation';
  IF policy_count <> 5 THEN RAISE EXCEPTION 'Expected 5 tenant isolation policies, found %', policy_count; END IF;
END $$;
