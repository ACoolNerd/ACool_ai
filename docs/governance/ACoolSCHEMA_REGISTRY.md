# ACoolSCHEMA — Registry & Compliance Notes

**Workspace:** ACool Ecosystem
**Component:** ACoolSCHEMA — the canonical 7-field object model and its mapping onto
ACoolDATABASE's actual Postgres tables
**Status:** Registry defined; Step 1 of remediation complete, tables **partially**
conformant (see §3)
**Last Updated:** 2026-06-16 (later same-day pass — `metadata` columns added)
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

| Table | `metadata` column? | Full 7-field (entity/type/status/owner)? | Notes |
|---|---|---|---|
| `agencies` | ✅ Yes | ❌ No | Native columns unchanged; `metadata jsonb default '{}'` added |
| `talents` | ✅ Yes | ❌ No | `agency_id` FK kept as-is — not collapsed into `metadata.agencyId` |
| `managers`, `producers`, `calendar_events`, `masters`, `raci_matrix` | ✅ Yes | ❌ No | Same — additive column only |
| `content` | ✅ Yes | ⚠️ Partial | Already had its own `type`/`status` columns pre-dating this law; not remapped to avoid semantic collision |
| `workforce` | ✅ Yes | ⚠️ Partial | Already had its own `status` column; not remapped |

**Step 1 of the remediation path below is now done and verified:**
[`database/migrations/002_schema_law_metadata.sql`](../../database/migrations/002_schema_law_metadata.sql)
ran via `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` against the live database — applied
manually once, then verified to run automatically on a full cold
`down -v --remove-orphans` → `up -d --build` cycle via the same root-entrypoint
pattern as `000_preflight_dependencies.sql`. Zero rows altered, zero drops, zero FK
or index changes — confirmed via `\d talents` and a full `prod-smoke-test.sh` pass
(9/9) both before and after.

`entity`, `type`, `status`, and `owner` were **deliberately not added as new columns**
in this pass: `content` already has its own `type`/`status` and `workforce` already
has `status`, so a blanket column add would either collide or create two
sources of truth for the same concept on those two tables. Steps 2–4 below remain
open.

## 4. Remediation Path

1. ~~Add a **non-destructive** `metadata JSONB` column to each existing table~~ —
   **done**, see above
2. Backfill `entity`, `type`, `status`, `owner` as new columns or computed view fields
   — still open; needs a per-table decision on `content`/`workforce` to avoid the
   collision noted above (do not execute without explicit approval)
3. Expose the 7-field shape at the **API boundary** (`acool-ecosystem-api`) before
   touching table DDL further, so consumers get the contract without a risky in-place
   migration
4. Only after the API-boundary mapping is proven: consider collapsing native columns
   into `metadata` for new tables going forward — never retroactively rewrite
   production tables without a tested backup/restore cycle

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
