BEGIN;
DROP TABLE IF EXISTS audit_events;
ALTER TABLE IF EXISTS content_items DROP CONSTRAINT IF EXISTS content_items_rights_fk;
DROP TABLE IF EXISTS content_items;
DROP TABLE IF EXISTS rights_records;
COMMIT;
