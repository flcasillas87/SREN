-- =========================================================
-- PROCESO: Carga de Precios Vinculantes
-- Origen  : staging.stg_precios_vinculantes_combustibles
-- Destino : datos_maestros.precios_vinculantes
-- =========================================================

INSERT INTO public.precios_vinculantes_combustibles (
    id_central_generacion,
    id_combustible,
    id_unidad_medida,
    fecha,
    precio_vinculante_combustibles,
    fuente
)
SELECT 
    c.id_central_generacion,
    cb.id_combustible,
    u.id_unidad_medida,
    TO_DATE(s.fecha, 'YYYY-MM-DD'),
    REPLACE(s.precio_vinculante_combustibles, ',', '')::NUMERIC,
    'Carga_Manual_' || CURRENT_DATE as fuente
FROM staging.stg_precios_vinculantes_combustibles s
JOIN datos_maestros.cat_centrales_generacion c 
    ON REGEXP_REPLACE(UPPER(TRIM(s.nombre_central)), '\s+', ' ', 'g') = 
       REGEXP_REPLACE(UPPER(TRIM(c.nombre_central)), '\s+', ' ', 'g')
JOIN datos_maestros.cat_combustibles cb 
    ON UPPER(TRIM(s.nombre_combustible)) = UPPER(TRIM(cb.nombre_combustible))
JOIN datos_maestros.cat_unidades_medida u 
    ON UPPER(TRIM(s.nombre_unidad_medida)) = UPPER(TRIM(u.codigo))
WHERE 

    s.precio_vinculante_combustibles ~ '^[0-9,]+(\.[0-9]+)?$'
    AND s.fecha ~ '^\d{4}-\d{2}-\d{2}$'
ON CONFLICT (id_central_generacion, id_combustible, fecha) 
DO UPDATE SET 
    precio_vinculante_combustibles = EXCLUDED.precio_vinculante_combustibles,
    updated_at = (now() AT TIME ZONE 'America/Monterrey');