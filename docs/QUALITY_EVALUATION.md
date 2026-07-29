# Data Platform Quality Evaluation

Required evidence:
- Every dataset has an owner, classification, schema and processing purpose.
- Tenant-scoped reads and writes cannot cross tenant boundaries.
- Lineage covers ingestion, transformation, serving and export.
- Quality checks measure completeness, validity, uniqueness, consistency, timeliness and referential integrity.
- Restricted fields are encrypted, minimised and masked outside production.
- Consent, retention, deletion and legal-hold workflows are exercised.
- English and Tamil metadata is reviewed where exposed to users.
- Backup, restore, failover, load and incident-response tests pass.

A green policy validator is necessary but is not production evidence.
