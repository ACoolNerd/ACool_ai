# ACoolSCHEMA — Registry & Compliance Notes

**Workspace:** ACool Ecosystem
**Component:** ACoolSCHEMA — the canonical 7-field object model and its mapping onto
ACoolDATABASE's actual Postgres tables
**Status:** Registry defined; underlying tables **not yet conformant** (see §3)
**Last Updated:** 2026-06-16
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

| Table | 7-field conformant? | Notes |
|---|---|---|
| `agencies` | ❌ No | Native columns (`name`, `email`, `phone`, `location`, `website`, `notes`, `is_active`, timestamps) |
| `talents` | ❌ No | Native columns; `agency_id` FK instead of `metadata.agencyId` |
| `managers`, `producers`, `content`, `calendar_events`, `masters`, `workforce`, `raci_matrix` | ❌ No | Same pattern — predate this schema law |

**This is a known, documented gap — not a regression introduced by today's fix.**
Today's work (migration ordering, healthchecks, cold-start) did not touch column
shapes and intentionally avoided destructive `ALTER`/`DROP` on live data.

## 4. Remediation Path (do not execute without explicit approval — schema changes
   on a live table are exactly the kind of judgment call that needs a human, not an
   agent, to authorize)

1. Add a **non-destructive** `metadata JSONB` column to each existing table
   (`ALTER TABLE ... ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb`)
2. Backfill `entity`, `type`, `status`, `owner` as new columns or computed view fields
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
