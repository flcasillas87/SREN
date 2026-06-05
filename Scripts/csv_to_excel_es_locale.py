from pathlib import Path
import csv
from decimal import Decimal, InvalidOperation

src = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
if not src.exists():
    src = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo_normalized.csv')
    if not src.exists():
        raise FileNotFoundError(src)

out = src.with_name(src.stem + '_es.csv')

with src.open(newline='', encoding='utf-8') as f_in:
    reader = csv.reader(f_in)
    rows = list(reader)

# normalize header if BOM present
if rows and rows[0] and rows[0][0].startswith('\ufeff'):
    rows[0][0] = rows[0][0].lstrip('\ufeff')

headers = rows[0]
price_index = None
for idx, h in enumerate(headers):
    if h == 'precio_vinculante_combustibles':
        price_index = idx
        break
if price_index is None:
    raise ValueError('Column precio_vinculante_combustibles not found')

with out.open('w', newline='', encoding='utf-8') as f_out:
    writer = csv.writer(f_out, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(headers)
    for row in rows[1:]:
        if len(row) <= price_index:
            writer.writerow(row)
            continue
        price_value = row[price_index].strip()
        if price_value:
            try:
                dec = Decimal(price_value)
                row[price_index] = str(dec).replace('.', ',')
            except InvalidOperation:
                # preserve original if not parseable
                pass
        writer.writerow(row)

print('Created Spanish-locale CSV:', out)
