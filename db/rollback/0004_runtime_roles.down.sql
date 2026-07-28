BEGIN;

-- Remove explicit privileges from existing objects.
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM osb_app, osb_readonly;
REVOKE USAGE ON SCHEMA public FROM osb_app, osb_readonly;

-- Remove default ACL dependencies before dropping the roles. PostgreSQL records
-- these grants separately from privileges on existing tables.
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM osb_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM osb_readonly;

DROP ROLE IF EXISTS osb_readonly;
DROP ROLE IF EXISTS osb_app;

COMMIT;
