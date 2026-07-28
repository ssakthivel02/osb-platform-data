BEGIN;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM osb_app, osb_readonly;
REVOKE USAGE ON SCHEMA public FROM osb_app, osb_readonly;
DROP ROLE IF EXISTS osb_readonly;
DROP ROLE IF EXISTS osb_app;
COMMIT;
