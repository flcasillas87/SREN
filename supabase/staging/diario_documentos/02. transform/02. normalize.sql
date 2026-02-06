-- =========================================================
-- Script: 02. Transform / normalize.sql
-- Objetivo: Limpiar texto y preparar tipos de datos
-- =========================================================

CREATE OR REPLACE VIEW staging.vw_normalize_diario_documentos AS
SELECT 
    import_id,
    -- Limpieza de Cadenas
    UPPER(TRIM(sociedad_sap)) AS sociedad_sap,
    UPPER(TRIM(proveedor)) AS proveedor,
    UPPER(TRIM(rfc_proveedor)) AS rfc_proveedor,
    UPPER(TRIM(lugar_servicio_nombre)) AS pais_busqueda,
    
    -- Limpieza de Números (Quitar comas, signos de pesos y espacios)
    REPLACE(REPLACE(REPLACE(importe_moneda_original, ',', ''), '$', ''), ' ', '') AS importe_clean,
    REPLACE(REPLACE(REPLACE(tc_contable_pasivo, ',', ''), '$', ''), ' ', '') AS tc_clean,
    
    -- Normalización de Bools
    CASE 
        WHEN UPPER(TRIM(estimado)) IN ('SI', 'S', 'TRUE', 'T', '1') THEN 'TRUE'
        ELSE 'FALSE'
    END AS estimado_clean,
    
    -- Fechas (Nullif para evitar errores con strings vacíos)
    NULLIF(TRIM(fecha_factura), '') AS fecha_factura_clean,
    NULLIF(TRIM(periodo_contable), '') AS periodo_clean
FROM staging.stg_diario_documentos;