# Data Platform Threat Model

## Protected assets
Tenant datasets, schemas, lineage, consent records, audit evidence, backups and encryption material.

## Principal threats
- Cross-tenant disclosure or modification
- Unauthorised export or bulk extraction
- Schema poisoning and lineage tampering
- Credentials, payment data or sensitive child data entering datasets
- Retention bypass, deletion failure or legal-hold conflict
- Backup exposure and restore corruption
- Unmasked production data copied into lower environments

## Required controls
Authentication, server-side tenant scoping, least privilege, encryption, classification, masking, immutable audit, schema validation, lineage, approved exports, retention enforcement and tested recovery.
