# ADR 0001: Server-authoritative data governance

## Decision
Tenant scope, dataset identity, classification, schema, lineage, retention, deletion, export and legal-hold state are enforced by trusted server-side controls. Client-supplied tenant, role, classification or deletion claims are never authoritative.

## Consequences
All policy and schema changes are versioned and audited. Restricted exports and retention overrides require approval. Lower environments use masked or synthetic data.
