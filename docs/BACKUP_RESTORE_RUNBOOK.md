# PostgreSQL Backup and Restore Runbook

## Scope
This runbook covers logical backup and restore evidence for the OSB PostgreSQL MVP. It does not replace managed-service snapshots, point-in-time recovery or disaster-recovery procedures.

## Preconditions
- Approved source and target environments.
- Database owner approval.
- Encryption at rest and in transit.
- No credentials committed to the repository.
- Backup location access restricted and logged.

## Backup
1. Record environment, database version, migration level, operator and timestamp.
2. Run `pg_dump --format=custom --no-owner --no-privileges` using credentials supplied at runtime.
3. Calculate SHA-256 for the resulting archive.
4. Store the archive and checksum in the approved encrypted location.
5. Record size, duration and exit status.

## Restore drill
1. Provision an isolated empty PostgreSQL instance of the supported version.
2. Verify the archive checksum before restoration.
3. Run `pg_restore --clean --if-exists --no-owner --no-privileges`.
4. Execute migration and governance verification scripts.
5. Compare table counts, constraints, indexes and representative records.
6. Record recovery time and any manual intervention.
7. Destroy the temporary environment securely.

## Acceptance evidence
- Backup command exit code 0.
- Checksum match.
- Restore command exit code 0.
- All verification scripts pass.
- Measured recovery time recorded.
- Exceptions and residual risks approved.

## Stop conditions
Do not approve production if restore has not been tested, checksum evidence is missing, the restored schema differs, or credentials appear in logs or artefacts.
