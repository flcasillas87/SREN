from pathlib import Path
import csv
from decimal import Decimal, InvalidOperation
from collections import Counter

p = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
if not p.exists():
    raise FileNotFoundError(p)

rows = []
with p.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    fieldnames = reader.fieldnames
    for row in reader:
        rows.append(row)

print('Columns:', fieldnames)
print('Row count:', len(rows))

# Missing/blank counts per column
missing = {col: 0 for col in fieldnames}
for row in rows:
    for col in fieldnames:
        if row[col] is None or row[col].strip() == '':
            missing[col] += 1
print('Missing counts:')
for col, cnt in missing.items():
    print(f'  {col}: {cnt}')

# Price validation
invalid_prices = []
price_values = []
for i, row in enumerate(rows, 1):
    v = row['precio_vinculante_combustibles'].strip()
    try:
        d = Decimal(v)
        price_values.append(d)
    except InvalidOperation:
        invalid_prices.append((i, v))

print('Invalid price rows:', len(invalid_prices))
if invalid_prices:
    print('  Sample invalid:', invalid_prices[:10])

# Price stats
if price_values:
    mn = min(price_values)
    mx = max(price_values)
    avg = sum(price_values) / Decimal(len(price_values))
    unique_prices = len(set(price_values))
    print('Price stats:')
    print('  min:', mn)
    print('  max:', mx)
    print('  avg:', round(avg, 6))
    print('  unique values:', unique_prices)
    print('  sample normalized values:', [str(price_values[i]) for i in range(min(10, len(price_values)))])

# Unique counts for key fields
for key in ['fecha', 'nombre_combustible', 'nombre_unidad_medida', 'catalogo_match', 'nombre_central']:
    if key in fieldnames:
        vals = Counter(row[key].strip() for row in rows)
        print(f'Unique {key}:', len(vals), 'top 10:', vals.most_common(10))

# Sample first/last rows
print('\nFirst 5 rows:')
for r in rows[:5]:
    print(r)
print('\nLast 5 rows:')
for r in rows[-5:]:
    print(r)
