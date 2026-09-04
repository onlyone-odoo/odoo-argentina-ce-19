#!/usr/bin/env bash
# Drop the local arce19_dev database. Never drop production / demo VPS DBs.
set -euo pipefail

DB_NAME="${DB_NAME:-arce19_dev}"
PG_USER="${PG_USER:-odoo}"

service postgresql start >/dev/null 2>&1 || true

echo "==> Dropping database '$DB_NAME'"
su - postgres -c "psql -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$DB_NAME';\"" || true
su - postgres -c "dropdb --if-exists $DB_NAME" || su - postgres -c "psql -c \"DROP DATABASE IF EXISTS $DB_NAME;\""
echo "==> Dropped $DB_NAME"
