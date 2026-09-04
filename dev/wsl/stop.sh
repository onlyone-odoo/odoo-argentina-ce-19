#!/usr/bin/env bash
# Stop local Odoo 19 process started by start.sh (does not touch CajaOne 18).
set -euo pipefail

PIDFILE="${PIDFILE:-$HOME/arce19.pid}"

if [[ -f "$PIDFILE" ]]; then
  pid="$(cat "$PIDFILE")"
  if kill -0 "$pid" 2>/dev/null; then
    echo "Stopping Odoo 19 pid $pid"
    kill "$pid" || true
    sleep 1
    kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f "$PIDFILE"
fi

pkill -f "odoo-bin -c .*odoo-argentina-ce-fork/dev/wsl/odoo.conf" 2>/dev/null || true
echo "Stopped Odoo 19 (CajaOne 18 on :8069 is left running if present)."
