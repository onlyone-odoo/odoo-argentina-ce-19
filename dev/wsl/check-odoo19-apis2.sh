#!/usr/bin/env bash
set -uo pipefail
O="${ODOO_SRC:-$HOME/src/odoo19}"
echo "== group_account_invoice =="
grep -n "group_account_invoice" "$O/addons/account/security/account_security.xml" | head || true
echo "== ensure_vat =="
grep -rn "def ensure_vat" "$O/addons/l10n_ar" || true
echo "== validate_move =="
grep -n "def validate_move" "$O/addons/account/wizard/account_validate_account_move.py" || true
echo "== pos account_move field =="
grep -n "account_move = fields" "$O/addons/point_of_sale/models/pos_order.py" || true
echo "== company_ri xmlid =="
grep -rn "id=.company_ri" "$O/addons/l10n_ar" | head || true
echo "== ports =="
ss -ltn | grep -E "8069|8079" || echo "ports 8069/8079 free"
echo "== python =="
python3 --version
