BEGIN;

INSERT INTO tenants (tenant_key, display_name, status)
VALUES ('ci-tenant-a', 'CI Tenant A', 'active'), ('ci-tenant-b', 'CI Tenant B', 'active')
ON CONFLICT (tenant_key) DO NOTHING;

DO $$
DECLARE
  tenant_a uuid;
  tenant_b uuid;
  visible_count integer;
BEGIN
  SELECT tenant_id INTO tenant_a FROM tenants WHERE tenant_key = 'ci-tenant-a';
  SELECT tenant_id INTO tenant_b FROM tenants WHERE tenant_key = 'ci-tenant-b';

  INSERT INTO content_items (tenant_id, canonical_key, content_type, title, language_code, body, editorial_status, provenance)
  VALUES
    (tenant_a, 'ci-a-content', 'test', 'Tenant A content', 'en', '{}'::jsonb, 'draft', '{}'::jsonb),
    (tenant_b, 'ci-b-content', 'test', 'Tenant B content', 'en', '{}'::jsonb, 'draft', '{}'::jsonb)
  ON CONFLICT (canonical_key) DO NOTHING;

  PERFORM set_config('app.tenant_id', tenant_a::text, true);
  SET LOCAL ROLE osb_app;
  SELECT count(*) INTO visible_count
  FROM content_items
  WHERE canonical_key IN ('ci-a-content', 'ci-b-content');
  RESET ROLE;

  IF visible_count <> 1 THEN
    RAISE EXCEPTION 'Tenant isolation failed: expected 1 visible row, found %', visible_count;
  END IF;
END $$;

ROLLBACK;
