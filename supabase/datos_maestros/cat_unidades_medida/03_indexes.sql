-- =========================================================
-- ÍNDICES
-- =========================================================
-- Índice para acelerar los JOINs con combustibles
CREATE INDEX idx_cat_unidades_medida_id_combustible ON datos_maestros.cat_unidades_medida (id_combustible);
-- Índice funcional para acelerar el ETL (Búsquedas exactas sin importar espacios/mayúsculas)
CREATE INDEX idx_cat_unidades_medida_codigo_normalizado ON datos_maestros.cat_unidades_medida (upper(trim(codigo)));
-- Índice para el estado activo (Útil si tienes miles de unidades y solo buscas las vigentes)
CREATE INDEX idx_cat_unidades_medida_es_activo ON datos_maestros.cat_unidades_medida (es_activo)
WHERE es_activo = true;