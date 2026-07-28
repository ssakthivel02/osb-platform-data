# PostgreSQL MVP Baseline

## Scope

This release establishes the first executable relational-data baseline for OSB. It intentionally excludes graph, vector and analytics engines until the core PostgreSQL controls are proven.

## Included controls

- PostgreSQL 17 baseline
- Transactional forward migration
- Transactional rollback migration
- UUID primary keys
- UTC-aware timestamps
- Referential integrity
- Controlled editorial states
- Controlled audit outcomes
- JSONB for canonical payloads and evidence details
- GIN and B-tree indexes for initial access patterns
- Local container health check
- CI database service
- Migration application test
- Schema-object verification
- Rollback test
- Least-privilege workflow permissions
- Workflow concurrency and timeout

## Data rules

1. Production credentials must never be committed.
2. Every migration must have a corresponding rollback or an approved irreversible-change record.
3. All timestamps must use `timestamptz`.
4. Application services must not bypass database constraints.
5. Rights status must be known before public publication; `unknown` is permitted only during controlled editorial review.
6. Audit events are append-only at the application layer.
7. Destructive production changes require backup, restore and rollback evidence.

## Verification

The GitHub Actions workflow starts a clean PostgreSQL instance, applies all migrations, verifies mandatory objects and executes the rollback scripts. A successful workflow is implementation evidence, not by itself a production approval.

## Deferred items

- Row-level security
- Tenant model
- Privacy-record tables
- Preservation-event tables
- Full-text search strategy
- pgvector
- Knowledge graph integration
- Partitioning and archival
- Backup automation and restore drill
- Performance benchmark with representative data
