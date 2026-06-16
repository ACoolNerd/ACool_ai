# ACoolDATABASE — Governance Manifest

**Workspace:** ACool Ecosystem (ACoolECOSYSTEM / ACoolNERD / ACoolAI umbrella)
**Component:** ACoolDATABASE — the governed Postgres data layer behind `acool-docker-universal-v5`
**Operator:** Keith Z. C. McPherson (ACoolNERD)
**Status:** Production-validated
**Last Updated:** 2026-06-16
**Governance Principle:** Rights → Disclosure → Proof

---

## 1. Purpose

ACoolDATABASE is the named governance boundary around the `postgres` service and its
schema in `docker-compose.prod.yml`. It exists so the database layer has the same
RBAC, audit, and lifecycle controls as any other ACoolECOSYSTEM component, instead of
being treated as an undocumented implementation detail.

## 2. Scope

- Engine: `postgres:16-alpine`, container `acool-postgres`
- Schema source of truth: [`database/`](../../database) (mounted read-only at
  `/docker-entrypoint-initdb.d`)
- Migration ordering: `000_preflight_dependencies.sql` → `001_talent_schema.sql`
- Canonical migration: [`database/migrations/000_preflight_dependencies.sql`](../../database/migrations/000_preflight_dependencies.sql)

## 3. RBAC Roles

| Role | Capability | Notes |
|---|---|---|
| **Requester** | Proposes schema changes via PR | Any contributor |
| **Approver** | Reviews migration ordering, FK integrity, data-loss risk | Keith McPherson (ACoolNERD) |
| **Deployer** | Runs `docker compose ... up -d --build` against `.env` | Operator only; never via CI with prod secrets in plaintext |
| **Auditor** | Reviews `docker logs acool-postgres` and migration history post-deploy | Operator or designated reviewer |

## 4. Audit Events

The following events MUST be captured (currently via container logs; promote to a
durable audit table or shipped log sink before multi-operator use):

- `migration.create` — new `.sql` file added under `database/`
- `migration.apply` — Postgres init sequence runs at container first-boot
- `schema.alter` — any `ALTER TABLE` outside the migration path
- `data.delete` — any `DROP TABLE` / `TRUNCATE` (none should occur outside an explicit,
  operator-approved local reset)
- `backup.create` / `restore.execute` — not yet automated; see §6

## 5. Dependency / Ordering Rule

Postgres executes root-level `*.sql` files under `/docker-entrypoint-initdb.d` in
lexical order. This is why the dependency fix lives at `database/000_preflight_dependencies.sql`
(loads the canonical file via `\i`) — it must sort before `001_talent_schema.sql` so
that parent tables referenced by foreign keys (`agencies` ← `talents.agency_id`) exist
first. Any new migration that introduces a new FK relationship must be numbered to run
after its parent table's migration, or must itself use `CREATE TABLE IF NOT EXISTS` for
the parent.

## 6. Backup & Retention (remaining production step)

Not yet implemented in this local/dev validation pass. Required before go-live:

- Scheduled `pg_dump` to MinIO/S3-compatible storage (cadence: **Daily**, owner:
  Operator, escalation: alert on failed backup job, audit event: `backup.create`)
- Point-in-time recovery story documented before first real customer/talent data is loaded
- Retention and deletion policy aligned with entity firewall rules (no cross-entity data)

## 7. Validation Evidence (2026-06-16)

- Cold `down -v --remove-orphans` → `up -d --build` cycle completed with zero
  `relation ... does not exist` errors
- `\dt` confirms 9 tables present: `agencies`, `talents`, `managers`, `producers`,
  `content`, `calendar_events`, `masters`, `workforce`, `raci_matrix`
- No secrets present in logs or this manifest

Made with LOVE by ACoolNERD with ACoolAI
