# Database standards

Fill in the `<...>` placeholders for your project, then delete this line.

- Database: `<PostgreSQL / MySQL / ...>`. Access: `<Prisma / SQLAlchemy / JPA / raw SQL>`. Migration tool: `<...>`.

## Keep the database replaceable

- All database access lives in repositories behind an interface. Services never see SQL strings or ORM types.
- Prefer standard SQL. When a vendor-specific feature is truly needed (JSONB, full-text search, upsert syntax), keep it inside one repository method and mark it with a `DB-SPECIFIC:` comment, so a migration to another database can find it.
- No business logic in triggers, stored procedures, or views.
- Store money as integer minor units (cents) or an exact decimal, and timestamps in UTC.
- Generate identifiers in the app (UUID or ULID) so they do not depend on one database's sequence behavior.
- Migrations run from an empty database to the current schema with no manual steps. Repository tests run against the same kind of database as production.

## Migrations

- Schema changes go through migrations only. Never edit a migration that has been merged.
- Make each migration safe for the code that is currently running: **expand, migrate, contract**. First add the new column or table (nullable or with a default), then deploy code that uses it and backfill, and drop the old one in a later migration.
- Keep migrations small, and put the index for a new query in the same migration as the feature.

## Avoid N+1 queries

An N+1 is one query to load a list, then one more query for each row in it. It is fast on a laptop and slow in production.

- Never run a query inside a loop, a `map`, or a per-item callback.
- Load related data in bulk: a join, a `WHERE id IN (...)` query, or the ORM's eager loading (`include`, `joinedload`, `select_related`, `@EntityGraph`).
- Across modules, call batch methods (`getUsersByIds(ids)`), never `getUser(id)` in a loop.
- Select only the columns you need. No `SELECT *` on hot paths.
- Paginate every list. Prefer keyset (cursor) pagination over `OFFSET` for large tables.
- Every list endpoint gets a test that asserts the query count stays constant as the number of rows grows.

## Indexing

- Index every foreign key, and every column used often in `WHERE`, `JOIN`, or `ORDER BY`.
- For a composite index, put equality columns first, then the range or sort column, and match the order the query uses. An index on `(a, b)` helps filters on `a` and on `a, b`, but not on `b` alone.
- Enforce business uniqueness with a unique constraint in the database, not only in code.
- Use partial indexes for a frequently filtered subset (for example `WHERE deleted_at IS NULL`) where the database supports them.
- Do not index everything. Each index slows writes and uses space, so drop unused ones. A column with only a few distinct values (like a boolean) is rarely worth an index on its own.
- Create indexes without locking writes on large tables (for example `CREATE INDEX CONCURRENTLY` in PostgreSQL).

## Optimization

- Before merging a new or changed query, run `EXPLAIN` (or `EXPLAIN ANALYZE`) on realistic data volume. A full table scan on a large table in a hot path is a bug.
- Keep transactions short. Never call a network service inside a transaction.
- Insert and update in batches, not row by row.
- Avoid `COUNT(*)` over large tables on hot paths; use an approximate or cached value.
- Cache only after measuring a real problem. A cache needs an explicit expiry and invalidation rule, and sits behind an interface.
- Size the connection pool deliberately, and log queries slower than `<200 ms>`.
