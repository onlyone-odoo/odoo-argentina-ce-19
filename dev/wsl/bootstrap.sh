#!/usr/bin/env bash
# Bootstrap Odoo 19 CE + Argentina CE fork inside WSL Ubuntu-24.04.
# Parallel to any local CajaOne 18 stack (different venv, port, database).
set -euo pipefail

ODOO_SRC="${ODOO_SRC:-$HOME/src/odoo19}"
FORK_ROOT="${FORK_ROOT:-/mnt/c/Users/Matias/Desktop/github/odoo-argentina-ce-fork}"
VENV_DIR="${VENV_DIR:-$HOME/arce19-venv}"
PG_USER="${PG_USER:-odoo}"
PG_PASS="${PG_PASS:-odoo}"
ODOO_REMOTE="${ODOO_REMOTE:-https://github.com/odoo/odoo.git}"
ODOO_BRANCH="${ODOO_BRANCH:-19.0}"

echo "==> Argentina CE 19 / Odoo 19 CE bootstrap (WSL)"
echo "    Distro tip: Ubuntu-24.04 (Python 3.12)."
echo "    ODOO_SRC=$ODOO_SRC"
echo "    FORK_ROOT=$FORK_ROOT"
echo "    VENV_DIR=$VENV_DIR"
echo "    Python=$(python3 --version 2>&1)"

PY_MAJOR_MINOR="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
case "$PY_MAJOR_MINOR" in
  3.12|3.13) ;;
  *)
    echo "ERROR: Python $PY_MAJOR_MINOR is not recommended for Odoo 19 CE." >&2
    echo "       Prefer 3.12 (Ubuntu-24.04)." >&2
    exit 1
    ;;
esac

export DEBIAN_FRONTEND=noninteractive

echo "==> apt update + system packages"
apt-get update -y
apt-get install -y --no-install-recommends \
  build-essential \
  git \
  curl \
  ca-certificates \
  python3 \
  python3-venv \
  python3-dev \
  python3-pip \
  libxml2-dev \
  libxslt1-dev \
  libldap2-dev \
  libsasl2-dev \
  libpq-dev \
  libjpeg-dev \
  zlib1g-dev \
  libffi-dev \
  libssl-dev \
  swig \
  postgresql \
  postgresql-client \
  libpq5 \
  fonts-dejavu-core

echo "==> Ensure PostgreSQL is running"
service postgresql start || systemctl start postgresql || true
for i in $(seq 1 30); do
  if su - postgres -c "psql -c 'SELECT 1'" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "==> Create PostgreSQL role/db owner '$PG_USER'"
su - postgres -c "psql -tAc \"SELECT 1 FROM pg_roles WHERE rolname='$PG_USER'\"" | grep -q 1 \
  || su - postgres -c "psql -c \"CREATE ROLE $PG_USER LOGIN CREATEDB PASSWORD '$PG_PASS';\""
su - postgres -c "psql -c \"ALTER ROLE $PG_USER WITH LOGIN CREATEDB PASSWORD '$PG_PASS';\""

if [[ ! -x "$ODOO_SRC/odoo-bin" ]]; then
  echo "==> Cloning Odoo $ODOO_BRANCH into $ODOO_SRC"
  mkdir -p "$(dirname "$ODOO_SRC")"
  git clone --depth 1 --branch "$ODOO_BRANCH" "$ODOO_REMOTE" "$ODOO_SRC"
fi

echo "==> Python venv at $VENV_DIR"
python3 -m venv "$VENV_DIR"
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
pip install --upgrade pip wheel setuptools

echo "==> Install Odoo 19 Python requirements (this can take several minutes)"
pip install -r "$ODOO_SRC/requirements.txt"

echo "==> Install Argentina CE / pyafipws requirements"
pip install -r "$FORK_ROOT/requirements.txt"

echo "==> Done."
echo "    Next: $FORK_ROOT/dev/wsl/init-db.sh"
echo "          $FORK_ROOT/dev/wsl/start.sh"
echo "    Verify: python -c \"from pyafipws.wsaa import WSAA; from pyafipws.wsfev1 import WSFEv1\""
