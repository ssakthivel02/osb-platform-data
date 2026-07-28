BEGIN;

CREATE TABLE tenants (
  tenant_id uuid PRIMARY KEY,
  tenant_key text NOT NULL UNIQUE,
  display_name text NOT NULL,
  status text NOT NULL CHECK (status IN ('active','suspended','retired')),
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE content_items ADD COLUMN tenant_id uuid REFERENCES tenants(tenant_id);
ALTER TABLE rights_records ADD COLUMN tenant_id uuid REFERENCES tenants(tenant_id);
ALTER TABLE audit_events ADD COLUMN tenant_id uuid REFERENCES tenants(tenant_id);

CREATE TABLE privacy_records (
  privacy_id uuid PRIMARY KEY,
  tenant_id uuid REFERENCES tenants(tenant_id),
  content_id uuid REFERENCES content_items(content_id) ON DELETE CASCADE,
  data_subject_category text NOT NULL CHECK (data_subject_category IN ('none','adult','child','mixed','unknown')),
  lawful_basis text,
  special_category boolean NOT NULL DEFAULT false,
  international_transfer boolean NOT NULL DEFAULT false,
  retention_class text NOT NULL,
  legal_hold boolean NOT NULL DEFAULT false,
  reviewed_at timestamptz,
  reviewed_by text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE preservation_events (
  preservation_event_id uuid PRIMARY KEY,
  tenant_id uuid REFERENCES tenants(tenant_id),
  content_id uuid REFERENCES content_items(content_id) ON DELETE CASCADE,
  event_type text NOT NULL CHECK (event_type IN ('ingestion','validation','malware_scan','hashing','migration','fixity_check','recovery','deletion','legal_hold')),
  event_time timestamptz NOT NULL,
  source_hash text,
  output_hash text,
  tool_name text,
  tool_version text,
  evidence_uri text,
  details jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE retention_rules (
  retention_class text PRIMARY KEY,
  minimum_days integer CHECK (minimum_days IS NULL OR minimum_days >= 0),
  disposal_action text NOT NULL CHECK (disposal_action IN ('review','delete','archive','anonymise')),
  legal_basis text,
  owner text NOT NULL,
  active boolean NOT NULL DEFAULT true
);

CREATE INDEX idx_privacy_content ON privacy_records(content_id);
CREATE INDEX idx_privacy_tenant ON privacy_records(tenant_id);
CREATE INDEX idx_preservation_content_time ON preservation_events(content_id, event_time DESC);
CREATE INDEX idx_preservation_details_gin ON preservation_events USING gin(details);

COMMIT;
