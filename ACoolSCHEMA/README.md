# ACoolSCHEMA

## Purpose

ACoolSCHEMA governs object definitions, registry records, database migration order, and schema validation for ACoolECOSYSTEM.

## 7-Field Schema Law

Every top-level ACool object model must use:

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

## Current Schema Registry

- Object registry: `ACoolSCHEMA/acool_object_registry.json`
- Production SQL source: `database/001_talent_schema.sql`
- Preflight dependency SQL: `database/migrations/000_preflight_dependencies.sql`

## Dependency Rule

Parent tables must exist before child foreign keys. For the current production stack, `agencies` is a parent table for `talents`, `masters`, and any future agency-linked object records.

## Validation Targets

- `docker compose -f docker-compose.prod.yml --env-file .env config`
- `docker logs acool-postgres --tail 80`
- `bash scripts/prod-smoke-test.sh`

## Governance

Rights → Disclosure → Proof
