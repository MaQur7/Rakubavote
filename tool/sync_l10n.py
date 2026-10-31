"""Keep translation files in step with app_en.arb.

- app_din.arb (placeholder local language): every key not yet translated is
  copied from English, so translators see exactly what is left to do.
- Prints keys missing from app_ar.arb.

Run: python3 tool/sync_l10n.py
"""
import json, pathlib

root = pathlib.Path(__file__).resolve().parent.parent / 'lib' / 'l10n'
en = json.loads((root / 'app_en.arb').read_text())
keys = [k for k in en if not k.startswith('@')]

din_path = root / 'app_din.arb'
din = json.loads(din_path.read_text())
for k in keys:
    din.setdefault(k, en[k])
din['languageName'] = din.get('languageName', '[Local language]')
din_path.write_text(json.dumps(din, ensure_ascii=False, indent=2) + '\n')

ar = json.loads((root / 'app_ar.arb').read_text())
missing = [k for k in keys if k not in ar]
print('Missing in app_ar.arb:', ', '.join(missing) if missing else 'none')
