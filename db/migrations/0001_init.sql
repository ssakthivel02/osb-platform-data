BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE content_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  canonical_key text NOT NULL UNIQUE,
  content_type text NOT NULL,
  title text NOT NULL,
  language_code text NOT NULL,
  body jsonb NOT NULL,
  editorial_status text NOT NULL DEFAULT 'draft'
    CHECK (editorial_status IN ('draft','review','approved','published','archived')),
  provenance jsonb NOT NULL,
  rights_record_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE rights_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rights_status text NOT NULL
    CHECK (rights_status IN ('public-domain','licensed','osb-owned','restricted','unknown','expired')),
  source_uri text,
  licence_uri text,
  permissions jsonb NOT NULL DEFAULT '{}'::jsonb,
  restrictions jsonb NOT NULL DEFAULT '{}'::jsonb,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE content_items
  ADD CONSTRAINT content_items_rights_fk
  FOREIGN KEY (rights_record_id) REFERENCES rights_records(id);

CREATE TABLE audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  occurred_at timestamptz NOT NULL,
  actor_id text NOT NULL,
  event_name text NOT NULL,
  resource_type text NOT NULL,
  resource_id text NOT NULL,
  action text NOT NULL,
  outcome text NOT NULL CHECK (outcome IN ('success','failure','denied','unknown')),
  correlation_id uuid NOT NULL,
  details jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_content_items_language_status ON content_items(language_code, editorial_status);
CREATE INDEX idx_content_items_body_gin ON content_items USING gin(body);
CREATE INDEX idx_audit_events_occurred_at ON audit_events(occurred_at DESC);
CREATE INDEX idx_audit_events_correlation_id ON audit_events(correlation_id);

COMMIT;
