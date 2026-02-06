-- =========================================================
-- Script: 02. Transform / prepare_merge.sql
-- Objetivo: Ensamble final con IDs de catálogos listo para LOAD
-- =========================================================

CREATE OR REPLACE VIEW staging.vw_prepare_merge_diario AS
SELECT 
    n.*,
    cat.id AS lugar_servicio_id  -- Aquí ya tenemos el UUID
FROM staging.vw_normalize_diario_documentos n
INNER JOIN datos_maestros.cat_lugares_servicio cat 
    ON cat.pais = n.pais_busqueda;