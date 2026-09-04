#!/usr/bin/env bash
# Start Odoo 19 CE for Argentina CE local testing (WSL). Port 8079.
set -euo pipefail

ODOO_SRC="${ODOO_SRC:-$HOME/src/odoo19}"
FORK_ROOT="${FORK_ROOT:-/mnt/c/Users/Matias/Desktop/github/odoo-argentina-ce-fork}"
VENV_DIR="${VENV_DIR:-$HOME/arce19-venv}"
CONF="${CONF:-$FORK_ROOT/dev/wsl/odoo.conf}"
DB_NAME="${DB_NAME:-arce19_dev}"
PIDFILE="${PIDFILE:-$HOME/arce19.pid}"
LOGFILE="${LOGFILE:-$HOME/arce19.log}"

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
service postgresql start >/dev/null 2>&1 || true

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "Odoo 19 already running (pid $(cat "$PIDFILE"))."
  echo "URL: http://127.0.0.1:8079  DB: $DB_NAME"
  exit 0
fi

cd "$ODOO_SRC"
echo "==> Starting Odoo 19 on :8079 (db=$DB_NAME)"
echo "    log: $LOGFILE"
nohup python odoo-bin -c "$CONF" -d "$DB_NAME" >>"$LOGFILE" 2>&1 &
echo $! >"$PIDFILE"
sleep 2
if kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "==> Odoo started (pid $(cat "$PIDFILE"))"
  echo "    Open http://127.0.0.1:8079"
  echo "    Master password (create DB): arce19_dev_master"
  echo "    User admin / admin (CLI-created database)"
else
  echo "ERROR: Odoo failed to start. See $LOGFILE" >&2
  tail -n 80 "$LOGFILE" >&2 || true
  exit 1
fi
