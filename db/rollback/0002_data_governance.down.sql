BEGIN;
DROP TABLE IF EXISTS preservation_events;
DROP TABLE IF EXISTS privacy_records;
DROP TABLE IF EXISTS retention_rules;
ALTER TABLE audit_events DROP COLUMN IF EXISTS tenant_id;
ALTER TABLE rights_records DROP COLUMN IF EXISTS tenant_id;
ALTER TABLE content_items DROP COLUMN IF EXISTS tenant_id;
DROP TABLE IF EXISTS tenants;
COMMIT;
