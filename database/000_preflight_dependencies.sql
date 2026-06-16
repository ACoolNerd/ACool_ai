-- Docker Postgres init only executes SQL files at the root of
-- /docker-entrypoint-initdb.d. Keep the canonical preflight migration in
-- database/migrations and load it first from this root-level entrypoint.
\i /docker-entrypoint-initdb.d/migrations/000_preflight_dependencies.sql
