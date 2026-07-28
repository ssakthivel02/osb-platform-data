BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS content_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  canonical_key text NOT NULL UNIQUE,
  content_type text NOT NULL CHECK (content_type IN ('article','verse','temple','deity','story','quiz','audio','guidance')),
  language_code varchar(16) NOT NULL,
  title text NOT NULL,
  summary text,
  body jsonb NOT NULL DEFAULT '{}'::jsonb,
  editorial_status text NOT NULL DEFAULT 'draft' CHECK (editorial_status IN ('draft','review','approved','published','archived')),
  provenance jsonb NOT NULL DEFAULT '{}'::jsonb,
  rights_status text NOT NULL DEFAULT 'needs_review' CHECK (rights_status IN ('cleared','licensed','public_domain','needs_review','restricted')),
  published_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CONSTRAINT published_requires_date CHECK (editorial_status <> 'published' OR published_at IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS content_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_item_id uuid NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  version_number integer NOT NULL CHECK (version_number > 0),
  snapshot jsonb NOT NULL,
  change_reason text NOT NULL,
  changed_by text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(content_item_id, version_number)
);

CREATE TABLE IF NOT EXISTS source_references (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_item_id uuid NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  source_type text NOT NULL,
  citation text NOT NULL,
  source_uri text,
  verification_status text NOT NULL DEFAULT 'unverified' CHECK (verification_status IN ('unverified','verified','disputed')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_content_items_type_status ON content_items(content_type, editorial_status) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_content_items_language ON content_items(language_code) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_content_items_body_gin ON content_items USING gin(body);
CREATE INDEX IF NOT EXISTS idx_content_versions_item ON content_versions(content_item_id, version_number DESC);
CREATE INDEX IF NOT EXISTS idx_source_references_item ON source_references(content_item_id);

CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_content_items_updated_at ON content_items;
CREATE TRIGGER trg_content_items_updated_at BEFORE UPDATE ON content_items
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMIT;
