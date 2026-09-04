#!/usr/bin/env bash
# Create / update a clean database with l10n_ar + AFIP WS modules.
set -euo pipefail

ODOO_SRC="${ODOO_SRC:-$HOME/src/odoo19}"
FORK_ROOT="${FORK_ROOT:-/mnt/c/Users/Matias/Desktop/github/odoo-argentina-ce-fork}"
VENV_DIR="${VENV_DIR:-$HOME/arce19-venv}"
CONF="${CONF:-$FORK_ROOT/dev/wsl/odoo.conf}"
DB_NAME="${DB_NAME:-arce19_dev}"
MODULES="${MODULES:-l10n_ar,l10n_ar_afipws,l10n_ar_afipws_fe}"

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
service postgresql start >/dev/null 2>&1 || true

echo "==> Initializing database '$DB_NAME' with modules: $MODULES"
cd "$ODOO_SRC"
python odoo-bin \
  -c "$CONF" \
  -d "$DB_NAME" \
  -i "$MODULES" \
  --stop-after-init \
  --without-demo=False

echo "==> Database ready: $DB_NAME"
echo "    Start server with: $FORK_ROOT/dev/wsl/start.sh"
