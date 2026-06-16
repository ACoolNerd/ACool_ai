# ACoolDATABASE

## Purpose

ACoolDATABASE governs persistent data, local production database setup, and evidence-backed reset rules for the ACoolECOSYSTEM Docker stack.

## Current Database Assets

- Postgres service: `acool-postgres`
- Init mount: `./database:/docker-entrypoint-initdb.d:ro`
- Preflight loader: `database/000_preflight_dependencies.sql`
- Canonical preflight migration: `database/migrations/000_preflight_dependencies.sql`
- Main schema: `database/001_talent_schema.sql`

## Guardrails

- Do not drop tables as a migration-order fix.
- Do not run `docker system prune --volumes` without explicit approval.
- Use `scripts/acool-prod-local-reset.sh` for scoped local reset only.
- Keep `.env`, `.env.prod`, backups, passwords, tokens, and API keys out of commits and published docs.

## Production Health

The database dependency issue was fixed by creating parent table dependencies before child-table foreign keys. `agencies` now exists before `talents.agency_id REFERENCES agencies(id)` is evaluated.

## 7-Field Database Object Record

Every governed data asset should map to:

```text
id
entity
type
name
status
owner
updatedAt
metadata
```

Domain-specific fields belong inside `metadata` unless a production table has a clear runtime need for first-class columns.
