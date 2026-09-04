#!/usr/bin/env bash
# Inspect Odoo 19 CE APIs that this fork inherits from.
set -uo pipefail
O="${ODOO_SRC:-$HOME/src/odoo19}"

echo "== odoo release =="
grep -E '^version' "$O/odoo/release.py" | head -n 5
python3 --version

echo "== invoicing_settings =="
grep -n "invoicing_settings" "$O/addons/account/views/res_config_settings_views.xml" | head || true

echo "== partner views files =="
ls "$O/addons/account/views/" | grep -i partner || true

echo "== partner accounting_entries =="
grep -n "accounting_entries" "$O"/addons/account/views/*.xml | head || true

echo "== l10n_ar view_move_form / concept =="
ls "$O/addons/l10n_ar/views/"
grep -n "l10n_ar_afip_concept\|id=\"view_move_form\"" "$O/addons/l10n_ar/views/"*.xml | head || true

echo "== invoice_currency_rate =="
grep -n "invoice_currency_rate" "$O/addons/account/models/account_move.py" | head || true

echo "== validate.account.move =="
ls "$O/addons/account/wizard/" | grep -i validate || true
grep -n "force_post\|_name = .validate.account.move" "$O/addons/account/wizard/"*.py | head || true

echo "== ir.cron sample =="
head -n 25 "$O/addons/account/data/service_cron.xml" || true

echo "== POS refunded_order_id =="
grep -n "refunded_order_id\|_prepare_invoice_vals" "$O/addons/point_of_sale/models/pos_order.py" | head || true

echo "== l10n_ar RAW_MAW =="
grep -rn "RAW_MAW" "$O/addons/l10n_ar" | head || true

echo "== l10n_ar_edi in CE? =="
ls -d "$O/addons/l10n_ar_edi" 2>/dev/null || echo "no l10n_ar_edi in CE addons"

echo "== journal form sheet =="
grep -n "<sheet\|view_account_journal_form" "$O/addons/account/views/account_journal_views.xml" | head -n 30 || true

echo "== done =="
