-- ===== ACoolSCHEMA — Step 2 of 7-field law remediation =====
-- Resolves the collision question left open in
-- docs/governance/ACoolSCHEMA_REGISTRY.md §3: `content` and `workforce`
-- already had their own `type`/`status` columns predating this law.
--
-- STANCE TAKEN (not deferred again):
--   - `entity` and `owner` collide nowhere -> added to all 9 tables.
--   - `status` already exists on `content` and `workforce` -> reused as-is,
--     NOT duplicated. Added to the other 7 tables, which had none.
--   - `type` already exists on `content` -> reused as-is, NOT duplicated.
--     Added to the other 8 tables (including `workforce`, which had a
--     `status` column but no `type` column), which had none.
--   - `name`/`title`/`task_name`/`project_name` inconsistency across tables
--     is explicitly OUT OF SCOPE here. Collapsing those into one column
--     name is a rename, not an additive column — that's a step-3,
--     API-boundary-first concern per the registry's remediation path, not
--     a blanket DDL pass.
--
-- Still non-destructive: every column is ADD COLUMN IF NOT EXISTS, nullable
-- or DEFAULT-only, no drops, no renames, no NOT NULL added retroactively.
--
-- Rights -> Disclosure -> Proof
-- Made with LOVE by ACoolNERD with ACoolAI

-- entity + owner: zero collisions anywhere, every table gets both
ALTER TABLE agencies        ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE talents         ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE managers        ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE producers       ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE content         ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE calendar_events ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE masters         ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE workforce       ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';
ALTER TABLE raci_matrix     ADD COLUMN IF NOT EXISTS entity VARCHAR(100) DEFAULT 'ACoolECOSYSTEM';

ALTER TABLE agencies        ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE talents         ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE managers        ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE producers       ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE content         ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE calendar_events ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE masters         ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE workforce       ADD COLUMN IF NOT EXISTS owner VARCHAR(255);
ALTER TABLE raci_matrix     ADD COLUMN IF NOT EXISTS owner VARCHAR(255);

-- status: content and workforce already have it — reused, not duplicated.
-- The other 7 get a new nullable status column.
ALTER TABLE agencies        ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE talents         ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE managers        ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE producers       ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE calendar_events ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE masters         ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
ALTER TABLE raci_matrix     ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active';
-- content.status and workforce.status: intentionally untouched, already exist

-- type: content already has it — reused, not duplicated. The other 8
-- (including workforce, which lacked `type` despite having `status`) get
-- a new nullable type column.
ALTER TABLE agencies        ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE talents         ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE managers        ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE producers       ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE calendar_events ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE masters         ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE workforce       ADD COLUMN IF NOT EXISTS type VARCHAR(50);
ALTER TABLE raci_matrix     ADD COLUMN IF NOT EXISTS type VARCHAR(50);
-- content.type: intentionally untouched, already exists
