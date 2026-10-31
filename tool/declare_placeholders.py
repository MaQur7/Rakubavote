"""Declare ARB placeholders in the order they appear in each English message.

Flutter's gen-l10n otherwise orders inferred placeholders alphabetically, which
silently swaps arguments such as "Raised by {name} on {date}". Run after
adding strings to app_en.arb (tool/sync_l10n.py runs it too).
"""
import json, pathlib, re

path = pathlib.Path(__file__).resolve().parent.parent / 'lib' / 'l10n' / 'app_en.arb'
arb = json.loads(path.read_text())
out = {}
for key, value in arb.items():
    out[key] = value
    if key.startswith('@') or not isinstance(value, str):
        continue
    # Top-level placeholders only: {name} or the variable of {count, plural, ...}.
    names = []
    depth = 0
    i = 0
    while i < len(value):
        ch = value[i]
        if ch == '{':
            if depth == 0:
                m = re.match(r'\{\s*(\w+)\s*[,}]', value[i:])
                if m and m.group(1) not in names:
                    names.append(m.group(1))
            depth += 1
        elif ch == '}':
            depth -= 1
        i += 1
    if not names:
        continue
    meta = dict(arb.get('@' + key, {}))
    existing = meta.get('placeholders', {})
    meta['placeholders'] = {n: existing.get(n, {}) for n in names}
    out['@' + key] = meta
path.write_text(json.dumps(out, ensure_ascii=False, indent=2) + '\n')
print('placeholders declared')
