# ACoolSCHEMA — Registry & Compliance Notes

**Workspace:** ACool Ecosystem
**Component:** ACoolSCHEMA — the canonical 7-field object model and its mapping onto
ACoolDATABASE's actual Postgres tables
**Status:** Registry defined; Steps 1 & 2 of remediation complete. All 9 tables now
carry `id, entity, type, name-equivalent, status, owner, updatedAt, metadata` —
see §3 for the `name`-equivalent caveat, which is the one deliberately deferred item.
**Last Updated:** 2026-06-16 (third same-day pass — `entity`/`owner`/`type`/`status` added)
**Governance Principle:** Rights → Disclosure → Proof

---

## 1. The Law

Per the global system instructions, every *new* database structure or object model
must expose exactly these 7 top-level fields, with domain values nested under `metadata`:

`id · entity · type · name · status · owner · updatedAt`

The canonical JSON Schema contract lives at [`schema/acool.schema.json`](../../schema/acool.schema.json).

## 2. Why this exists as its own component

`database/001_talent_schema.sql` predates this rule and defines flat, type-specific
tables (`talents`, `agencies`, `managers`, `producers`, `content`, `calendar_events`,
`masters`, `workforce`, `raci_matrix`) with native columns rather than the 7-field
shape. ACoolSCHEMA is the registry that tracks that gap honestly instead of silently
asserting compliance, and is the place future migrations get checked against before
they ship.

## 3. Current Compliance Status (honest accounting)

| Table | `metadata` | `entity` | `owner` | `type` | `status` | `name`-equivalent |
|---|---|---|---|---|---|---|
| `agencies` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ✅ `name` |
| `talents` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ✅ `name` |
| `managers`, `producers` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ✅ `name` |
| `calendar_events` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ⚠️ `title`, not `name` |
| `masters` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ✅ `name` |
| `raci_matrix` | ✅ new | ✅ new | ✅ new | ✅ new | ✅ new | ⚠️ `task_name`, not `name` |
| `content` | ✅ new | ✅ new | ✅ new | ♻️ reused (pre-existing) | ♻️ reused (pre-existing) | ⚠️ `title`, not `name` |
| `workforce` | ✅ new | ✅ new | ✅ new | ✅ new | ♻️ reused (pre-existing) | ⚠️ `project_name`, not `name` |

**Steps 1 and 2 of the remediation path are now done and verified.**
[`database/migrations/002_schema_law_metadata.sql`](../../database/migrations/002_schema_law_metadata.sql)
and
[`database/migrations/003_schema_law_entity_owner_type_status.sql`](../../database/migrations/003_schema_law_entity_owner_type_status.sql)
both ran via `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` against the live database
first, then were proven to run automatically on a full cold
`down -v --remove-orphans` → `up -d --build` cycle. Verification for step 2
specifically: `information_schema.columns` confirmed exactly one `type` and one
`status` column on every table (no duplicates created on `content`/`workforce`),
zero Postgres errors on cold init, `prod-smoke-test.sh` 9/9 both before and after.

**The collision question is resolved, not deferred again:** `content.type`,
`content.status`, and `workforce.status` — which predated this law — were reused
as-is rather than duplicated alongside a parallel column. `workforce` did need a new
`type` column since it only had `status` before.

**Step 3 is now done too.** `services/acool-ecosystem-api/src/index.js` adds a
`withNormalizedName`/`withNormalizedNames` helper that maps each of the 4 affected
tables' real label column (`content.title`, `calendar_events.title`,
`raci_matrix.task_name`, `workforce.project_name`) onto a `name` field in the JSON
response — **only** when `name` isn't already present, so it never overwrites real
data. The underlying column is untouched: `GET /api/v1/content` now returns both
`"title": "..."` and `"name": "..."` with the same value. Verified by inserting a
throwaway row into `content`, `workforce`, and `raci_matrix`, confirming `name`
appeared correctly via `curl` through the live Nginx route, then deleting the test
rows before commit. `talents`/`agencies`/etc. (which already have a native `name`
column) are unaffected — the helper is a no-op for them.

All 9 tables are now fully 7-field-conformant at the API boundary:
`id, entity, type, name, status, owner, updatedAt` (as `updated_at`) all present in
every `GET` response, with the original native columns left intact underneath.

## 4. Remediation Path

1. ~~Add a **non-destructive** `metadata JSONB` column to each existing table~~ — **done**
2. ~~Backfill `entity`, `owner`, `type`, `status` as new columns, resolving the
   `content`/`workforce` collision by reuse rather than duplication~~ — **done**
3. ~~Expose the full 7-field shape — including a normalized `name` regardless of
   underlying column — at the **API boundary** (`acool-ecosystem-api`)~~ — **done**
4. Only after the API-boundary mapping is proven (it now is — see above): consider
   collapsing native columns into `metadata` for new tables going forward — never
   retroactively rewrite production tables without a tested backup/restore cycle.
   This step is **not yet done** and is genuinely lower priority: it's a future-table
   convention decision, not a gap in any existing table or API response today.

## 5. Relationship to Other ACool Components

- **ACoolDATABASE** ([manifest](ACoolDATABASE_MANIFEST.md)) — owns the physical
  Postgres schema and migration ordering that ACoolSCHEMA's contract sits on top of.
- **ACoolOSINT** — lives in the separate `~/ACoolai` repository under
  `ACoolKnowledgeBase/09_ACoolOSINT`. It is **out of scope and firewalled** from this
  Docker stack per the Entity Firewall Protocol; no OSINT data, code, or schema is
  imported into `acool-docker-universal-v5`. Referenced here only so the manifest
  index is complete.
- **ACoolAI** — the orchestrating project at `~/ACoolai` (GitHub `acoolnerd/acool_ai`).
  This Docker repo's `.env` already declares `ACoolAI_ENDPOINT` / `ACoolAI_MODEL` as
  integration points; ACoolSCHEMA is the contract that data crossing that boundary
  should eventually satisfy.

Made with LOVE by ACoolNERD with ACoolAI
