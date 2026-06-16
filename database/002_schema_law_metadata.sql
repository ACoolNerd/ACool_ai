-- Docker Postgres init only executes SQL files at the root of
-- /docker-entrypoint-initdb.d. Keep the canonical migration in
-- database/migrations and load it from this root-level entrypoint, same
-- pattern as 000_preflight_dependencies.sql.
\i /docker-entrypoint-initdb.d/migrations/002_schema_law_metadata.sql
