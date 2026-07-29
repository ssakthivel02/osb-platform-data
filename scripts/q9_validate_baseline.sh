#!/usr/bin/env sh
set -eu

: "${DATABASE_URL:?DATABASE_URL is required}"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/001_initial.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f tests/q9_assert_baseline.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/001_initial.down.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/001_initial.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f tests/q9_assert_baseline.sql
