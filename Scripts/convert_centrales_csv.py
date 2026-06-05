from pathlib import Path
import csv
import uuid

p = Path(r"e:\SREN\supabase\datos_maestros\cat_centrales_generacion\cat_centrales_generacion_rows.csv")
rows = []
with p.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    orig_fields = reader.fieldnames
    for r in reader:
        rows.append(r)

# Build new header preserving order and inserting new columns after updated_at
new_fields = list(orig_fields)
if 'updated_at' in new_fields:
    idx = new_fields.index('updated_at')
    for col in ['observaciones','archivo_origen','fecha_carga','usuario_carga']:
        if col not in new_fields:
            idx += 1
            new_fields.insert(idx, col)
else:
    for col in ['observaciones','archivo_origen','fecha_carga','usuario_carga']:
        if col not in new_fields:
            new_fields.append(col)

# Update rows
for r in rows:
    r['id_central_generacion'] = str(uuid.uuid4())
    r['observaciones'] = ''
    r['archivo_origen'] = ''
    r['fecha_carga'] = r.get('created_at','')
    r['usuario_carga'] = ''

# Write back
with p.open('w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=new_fields, extrasaction='ignore')
    writer.writeheader()
    for r in rows:
        writer.writerow(r)

print(f"Updated {p} rows={len(rows)}")
