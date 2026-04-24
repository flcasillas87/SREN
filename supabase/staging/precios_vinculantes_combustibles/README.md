# Pipeline: precios_vinculantes_combustibles

Flujo homologado con los pipelines estandar del repo:

1. `staging.stg_precios_vinculantes_combustibles`
2. `staging.vw_precios_vinculantes_combustibles_validation_errors`
3. `staging.precios_vinculantes_combustibles_normalized`
4. `staging.precios_vinculantes_combustibles_ready`
5. `public.precios_vinculantes_combustibles`

Reglas principales:

- Acepta fechas `YYYY-MM-DD` y `DD/MM/YYYY`
- Rechaza precios no numericos o menores o iguales a cero
- Valida mapeo de combustible, unidad y central contra `datos_maestros`
- La unidad debe corresponder al combustible
- No permite duplicados dentro del archivo para `fecha + combustible + central`
- El merge final hace `upsert` por `fecha + id_combustible + id_central_generacion`
