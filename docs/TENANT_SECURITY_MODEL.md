# Tenant Security Model

## Boundary
`tenant_id` is the primary data-isolation boundary for tenant-scoped OSB records. Application requests must set `app.tenant_id` within the database session or transaction before accessing tenant tables.

## Rules
- The tenant identifier must come from verified authentication and authorisation context, never directly from an untrusted request field.
- Connection pools must reset session state before reuse.
- Service roles must not have `BYPASSRLS`.
- Database-owner or migration roles must not be used by runtime services.
- Background jobs must set one explicit tenant per transaction.
- Cross-tenant reporting requires a separately approved role and audited pathway.
- New tenant-scoped tables must enable RLS and include both `USING` and `WITH CHECK` policies.

## Verification
- Confirm RLS is enabled on every tenant table.
- Confirm the expected policy count.
- Test that Tenant A cannot read, update or delete Tenant B records.
- Test that inserts with a mismatched tenant are rejected.
- Test pooled connections for tenant-context leakage.
- Record role attributes and grants as release evidence.

## Known limitation
The initial migration permits null tenant identifiers for compatibility with the existing scaffold. Production certification requires a controlled backfill and `NOT NULL` enforcement after all existing records are assigned to a tenant.
