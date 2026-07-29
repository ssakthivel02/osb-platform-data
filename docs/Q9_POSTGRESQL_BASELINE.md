# Q9 PostgreSQL Baseline

## Objective

Provide a small, reversible and testable PostgreSQL foundation for OSB canonical content before introducing additional databases or managed services.

## Delivered controls

1. PostgreSQL 16 baseline.
2. UUID primary keys using `pgcrypto`.
3. Unique canonical content keys.
4. Controlled content-type values.
5. BCP 47-compatible language storage.
6. Tamil Unicode fixture validation.
7. Editorial lifecycle constraints.
8. Published-date integrity rule.
9. Rights-status classification.
10. Structured provenance storage.
11. Soft-delete timestamp.
12. Immutable content-version snapshots.
13. Version-number uniqueness.
14. Source-reference records.
15. Source verification status.
16. Foreign-key enforcement.
17. Cascade cleanup for dependent evidence.
18. Targeted relational indexes.
19. JSONB GIN indexing.
20. Automatic `updated_at` maintenance.
21. Transactional forward migration.
22. Transactional rollback migration.
23. Apply/assert/rollback/reapply validation.
24. Clean PostgreSQL service in CI.
25. Least-privilege workflow permissions.
26. CI timeout protection.
27. Concurrency cancellation.
28. No paid infrastructure provisioning.
29. Explicit database connection through `DATABASE_URL`.
30. Honest production-readiness boundary.

## Local validation

```sh
docker compose -f compose.postgres.yml up -d
export DATABASE_URL='postgresql://osb:osb_local_only@localhost:5432/osb'
sh scripts/q9_validate_baseline.sh
```

Do not use the local demonstration password outside a developer machine.

## Production stop conditions

The data platform remains NO-GO for production until all applicable items are evidenced:

- Managed secret injection; no repository credentials.
- Encrypted connections and certificate validation.
- Least-privilege application and migration roles.
- Backup schedule and retention policy.
- Successful restore rehearsal with recorded recovery time.
- Row-level or service-level authorisation design.
- Data retention and deletion workflows.
- Privacy impact review for personal and children's data.
- Migration compatibility testing with consuming services.
- Monitoring for availability, storage, connections, locks and slow queries.
- Tested production rollback or forward-fix procedure.

## Next implementation wave

1. Create separate runtime, migration and read-only roles.
2. Add tenant and user boundaries only after the auth contract is confirmed.
3. Add rights and provenance validation aligned with engineering standards.
4. Add backup/restore scripts for an ephemeral test environment.
5. Add query-performance budgets and representative fixtures.
6. Publish a repository production certificate after CI and restore evidence exist.
