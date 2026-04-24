# Pipeline: precios_vinculantes_combustibles

Flujo homologado con los pipelines estandar del repo:

1. `staging.precios_vinculantes_combustibles_raw`
2. `staging.stg_precios_vinculantes_combustibles`
3. `etl.pr_load_precios_vinculantes_combustibles()`
4. `public.precios_vinculantes_combustibles`

Nota:

- `01. staging/02. load_csv.sql` ya ejecuta la orquestacion automaticamente al final de la carga.
- Los scripts en `03. load` quedaron como compatibilidad documental.

Reglas principales:

- Acepta fechas `YYYY-MM-DD` y `DD/MM/YYYY`
- Rechaza precios no numericos o menores o iguales a cero
- Valida mapeo de combustible, unidad y central contra `datos_maestros`
- La unidad debe corresponder al combustible
- No permite duplicados dentro del archivo para `fecha + combustible + central`
- La carga final hace `upsert` por `fecha + id_combustible + id_central_generacion`
