# Odoo Argentina CE 19.0 (OnlyOne fork)

Fork of [ingadhoc/odoo-argentina-ce](https://github.com/ingadhoc/odoo-argentina-ce) **18.0**, migrated to **Odoo 19 Community** and published as [onlyone-odoo/odoo-argentina-ce-19](https://github.com/onlyone-odoo/odoo-argentina-ce-19).

Electronic invoicing still uses **pyafipws** (WSAA / WSFE / WSFEX / WSBFE). This is **not** the Adhoc `19.0-mig-MAQ` rewrite (`l10n_ar_fiscal_ws*`, `arcaws_*`, zeep). Canonical technical names stay `l10n_ar_afipws`, `l10n_ar_afipws_fe`, fields `afip_ws`, `afip_ws_env_type`, `afip_auth_*`.

`l10n_ar_edi` is Enterprise and is **not** a dependency.

Upstream Adhoc 19.0 currently ships these modules with `installable: False` and version `18.0.*`. This fork is installable on 19.0.

## Modules

| Module | Status |
| --- | --- |
| `l10n_ar_afipws` | Installable — WSAA, certificates, padrones |
| `l10n_ar_afipws_fe` | Installable — CAE on `_post` (WSFE) |
| `l10n_ar_pos_afipws_fe` | Installable — POS credit notes; optional |
| `l10n_ar_reports` | `installable: False` (needs `report_xlsx`; out of scope) |

Original localization work: **Adhoc SA** — https://github.com/ingadhoc/odoo-argentina-ce

## Python / pyafipws

See `requirements.txt`. First attempt: `ingadhoc/pyafipws@odoo18` on Python 3.12. If WSAA fails, fall back to `filoquin/pyafipws@py3k` and document the traceback (M2Crypto vs AFIP).
