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
  SELECT id INTO tenant_a FROM tenants WHERE tenant_key = 'ci-tenant-a';
  SELECT id INTO tenant_b FROM tenants WHERE tenant_key = 'ci-tenant-b';

  INSERT INTO content_items (tenant_id, slug, title, language_code, editorial_status, payload)
  VALUES
    (tenant_a, 'ci-a-content', 'Tenant A content', 'en', 'draft', '{}'::jsonb),
    (tenant_b, 'ci-b-content', 'Tenant B content', 'en', 'draft', '{}'::jsonb)
  ON CONFLICT DO NOTHING;

  PERFORM set_config('app.tenant_id', tenant_a::text, true);
  SET LOCAL ROLE osb_app;
  SELECT count(*) INTO visible_count
  FROM content_items
  WHERE slug IN ('ci-a-content', 'ci-b-content');
  RESET ROLE;

  IF visible_count <> 1 THEN
    RAISE EXCEPTION 'Tenant isolation failed: expected 1 visible row, found %', visible_count;
  END IF;
END $$;

ROLLBACK;
