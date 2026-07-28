DO $$
DECLARE
  role_name text;
BEGIN
  FOREACH role_name IN ARRAY ARRAY['osb_app','osb_readonly'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role_name) THEN
      RAISE EXCEPTION 'Required role missing: %', role_name;
    END IF;
    IF EXISTS (
      SELECT 1 FROM pg_roles
      WHERE rolname = role_name
        AND (rolsuper OR rolcreatedb OR rolcreaterole OR rolbypassrls)
    ) THEN
      RAISE EXCEPTION 'Role % has prohibited elevated privileges', role_name;
    END IF;
  END LOOP;

  IF has_table_privilege('osb_readonly', 'content_items', 'INSERT') THEN
    RAISE EXCEPTION 'osb_readonly must not have INSERT on content_items';
  END IF;

  IF NOT has_table_privilege('osb_app', 'content_items', 'SELECT') THEN
    RAISE EXCEPTION 'osb_app requires SELECT on content_items';
  END IF;
END $$;
