from decimal import Decimal, InvalidOperation, getcontext
from pathlib import Path
import csv

# Set precision high enough to preserve source values
getcontext().prec = 30

p = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
assert p.exists(), p

# First scan the column to infer decimal places
counts = {}
rows = []
with p.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    fieldnames = reader.fieldnames
    for row in reader:
        v = row['precio_vinculante_combustibles'].strip()
        try:
            d = Decimal(v)
        except InvalidOperation:
            raise ValueError(f'Invalid price value: {v}')
        # count fractional digits precisely
        if d == d.to_integral():
            digits = 0
        else:
            digits = -d.as_tuple().exponent
        counts[digits] = counts.get(digits, 0) + 1
        rows.append((row, d))

# Use fixed 2-decimal formatting for all prices to avoid Excel float artifacts
precision = 2
print(f'Using fixed display precision: {precision} decimals')

# Normalize values using fixed-point formatting with exactly two decimals.

def normalize_decimal(d: Decimal) -> str:
    quant = Decimal('1.' + '0' * precision)
    nd = d.quantize(quant)
    s = format(nd, f'.{precision}f')
    return s

import os

temp_path = p.with_name(p.stem + '_normalized' + p.suffix)
with temp_path.open('w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    for row, d in rows:
        row['precio_vinculante_combustibles'] = normalize_decimal(d)
        writer.writerow(row)

try:
    os.replace(temp_path, p)
    print('Normalization complete. Output rows:', len(rows))
    print('Replaced original file with normalized CSV.')
except PermissionError:
    print('Normalization complete, but could not replace original file due to permission issue.')
    print('Normalized file written to:', temp_path)
