# Runtime database access controls

## Identity separation

- Migration identity: schema changes only; never used by the application.
- Application identity: member of `osb_app`; no ownership, no DDL and no `BYPASSRLS`.
- Read-only identity: member of `osb_readonly`; no writes.

Login roles and credentials are provisioned by the deployment platform, not committed to this repository.

## Mandatory session handling

1. Start a transaction.
2. Set `app.tenant_id` from the verified authentication context using `SET LOCAL`.
3. Execute tenant-scoped statements.
4. Commit or roll back.
5. Reset or discard the pooled connection before reuse.

The client must never accept a tenant identifier directly from an unverified request field.

## Production gates

- TLS-enforced database connections.
- Secret-manager supplied credentials.
- Short credential rotation procedure tested.
- Negative cross-tenant tests pass using the real runtime role.
- Pool reset test proves tenant context cannot leak.
- Runtime roles remain non-owner and without elevated attributes.
