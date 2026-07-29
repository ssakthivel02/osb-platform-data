BEGIN;
DROP TRIGGER IF EXISTS trg_content_items_updated_at ON content_items;
DROP FUNCTION IF EXISTS set_updated_at();
DROP TABLE IF EXISTS source_references;
DROP TABLE IF EXISTS content_versions;
DROP TABLE IF EXISTS content_items;
COMMIT;
