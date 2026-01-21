-- Índice para búsquedas rápidas por nombre (muy usado en autocompletado de UI)
CREATE INDEX IF NOT EXISTS idx_cat_proveedores_razon_social 
ON datos_maestros.cat_proveedores USING gin (razon_social gin_trgm_ops); -- Requiere extensión pg_trgm

-- Índice para validación de RFC
CREATE INDEX IF NOT EXISTS idx_cat_proveedores_rfc 
ON datos_maestros.cat_proveedores (rfc) 
WHERE rfc IS NOT NULL;