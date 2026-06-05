from pathlib import Path
import csv

p = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo_normalized.csv')
if not p.exists():
    p = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
print('Using file', p)
with p.open('r', encoding='utf-8', newline='') as f:
    reader = csv.DictReader(f)
    price_bad = []
    for i, row in enumerate(reader, 1):
        v = row['precio_vinculante_combustibles']
        if v.startswith("'") or v.startswith('"') or v.strip() != v:
            price_bad.append((i, repr(v)))
        if i <= 20:
            print(i, repr(v))
    print('bad count', len(price_bad))
    if price_bad:
        print(price_bad[:20])

with p.open('r', encoding='utf-8', newline='') as f:
    for i, line in enumerate(f, 1):
        if "'27.705920000000003" in line or '27.705920000000003' in line:
            print('line', i, repr(line))
            break
