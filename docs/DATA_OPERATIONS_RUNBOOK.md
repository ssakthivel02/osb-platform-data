# Data Platform Operations Runbook

1. Confirm tenant, dataset, classification, owner and processing purpose.
2. Validate authentication, authorisation and server-derived tenant scope.
3. Check schema version, lineage, freshness, quality thresholds and encryption.
4. Quarantine malformed, unclassified or suspicious ingestion.
5. Escalate cross-tenant exposure, secret leakage, safeguarding or payment-data incidents immediately.
6. Permit exports, retention overrides and legal holds only through approved audited workflows.
7. Record impact, mitigation, rollback and recovery evidence.
8. Close only after integrity, access, lineage and downstream processing are verified.

Never place production credentials or unmasked restricted data in tickets or test fixtures.
