#!/usr/bin/env sh
set -eu

for file in db/migrations/*.sql db/rollback/*.sql; do
  [ -f "$file" ] || { echo "Missing SQL files"; exit 1; }
  grep -Eq 'BEGIN;|BEGIN TRANSACTION;' "$file" || { echo "$file must start a transaction"; exit 1; }
  grep -Eq 'COMMIT;' "$file" || { echo "$file must commit"; exit 1; }
done

if grep -RniE '(password|secret|token)[[:space:]]*=[[:space:]]*[^$]' db scripts docs 2>/dev/null; then
  echo "Potential hard-coded secret detected"
  exit 1
fi

echo "Migration structure validation passed"
