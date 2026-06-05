from pathlib import Path
import csv
from decimal import Decimal, InvalidOperation
from openpyxl import Workbook
from openpyxl.styles import numbers

src = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo_normalized.csv')
if not src.exists():
    src = Path(r'e:\SREN\supabase\public\precios_vinculantes_combustibles\stg_precios_vinculantes_combustibles_rows_con_catalogo.csv')
    if not src.exists():
        raise FileNotFoundError(src)

wb = Workbook()
ws = wb.active
ws.title = 'precios'

with src.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    headers = reader.fieldnames
    if headers is None:
        raise ValueError('CSV has no headers')
    ws.append(headers)
    price_col = 'precio_vinculante_combustibles'
    for row in reader:
        values = []
        for h in headers:
            value = row[h]
            if h == price_col:
                try:
                    dec = Decimal(value.strip())
                    # Convert to float for numeric Excel cell
                    value = float(dec)
                except (InvalidOperation, ValueError):
                    pass
            values.append(value)
        ws.append(values)

# Set number format for the price column
price_index = headers.index(price_col) + 1
fmt = '0.################'
for row in ws.iter_rows(min_row=2, min_col=price_index, max_col=price_index):
    cell = row[0]
    if isinstance(cell.value, float):
        cell.number_format = fmt

out = src.with_suffix('.xlsx')
wb.save(out)
print('Created Excel file:', out)
