from decimal import Decimal, InvalidOperation
from pathlib import Path
import csv

p = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
assert p.exists(), p
bad = []
weird = []
with p.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for i, row in enumerate(reader, 1):
        v = row['precio_vinculante_combustibles'].strip()
        try:
            d = Decimal(v)
        except InvalidOperation:
            bad.append((i, v))
            continue
        s = format(d, 'f')
        if v != s:
            weird.append((i, v, s))
        if i >= 1000000:
            break

print('rows', i)
print('bad', len(bad), bad[:20])
print('weird', len(weird), weird[:20])
