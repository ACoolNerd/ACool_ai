-- ===== ACoolSCHEMA — Step 1 of 7-field law remediation =====
-- Non-destructive only: adds a `metadata JSONB` column to every existing
-- table. No renames, no drops, no NOT NULL constraints, no data touched.
-- This is intentionally the smallest possible step toward
-- docs/governance/ACoolSCHEMA_REGISTRY.md compliance — entity/type/status/
-- owner columns are NOT added here because `content` and `workforce`
-- already have their own `status` column and `content` already has `type`;
-- mapping those onto the canonical 7-field shape belongs at the API
-- boundary (acool-ecosystem-api), not as a second collision-prone DDL pass.
--
-- Rights -> Disclosure -> Proof
-- Made with LOVE by ACoolNERD with ACoolAI

ALTER TABLE agencies        ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE talents         ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE managers        ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE producers       ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE content         ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE calendar_events ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE masters         ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE workforce       ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE raci_matrix     ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
