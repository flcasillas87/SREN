-- =========================================================
-- Transform / validate.sql
-- Objetivo: Identificar registros en STG que fallarán al normalizar
-- =========================================================

CREATE OR REPLACE VIEW staging.vw_validate_diario_documentos AS
SELECT 
    import_id,
    -- Validación de Lugar de Servicio (Debe existir en nuestro catálogo)
    CASE 
        WHEN l.id IS NULL THEN 'ERROR: Lugar de servicio (país) no reconocido'
        ELSE 'OK'
    END AS v_lugar_servicio,
    
    -- Validación de Fechas (Verifica si son convertibles a DATE)
    CASE 
        WHEN fecha_factura IS NOT NULL AND NOT fecha_factura ~ '^\d{4}-\d{2}-\d{2}$' 
        THEN 'WARNING: Formato de fecha factura inválido (esperado YYYY-MM-DD)'
        ELSE 'OK'
    END AS v_fecha_factura,
    
    -- Validación de Montos (Verifica si son numéricos después de quitar basura)
    CASE 
        WHEN importe_moneda_original IS NOT NULL 
             AND REPLACE(REPLACE(importe_moneda_original, ',', ''), '$', '') !~ '^-?\d*\.?\d*$' 
        THEN 'ERROR: Importe moneda original no es numérico'
        ELSE 'OK'
    END AS v_importe,

    -- Validación de tipos de entrega y moneda (Debe coincidir con ENUMS de public)
    CASE 
        WHEN moneda_documento NOT IN ('USD', 'MXN') THEN 'ERROR: Moneda no soportada'
        ELSE 'OK'
    END AS v_moneda
    
FROM staging.stg_diario_documentos s
LEFT JOIN datos_maestros.cat_lugares_servicio l 
    ON l.pais = UPPER(TRIM(s.lugar_servicio_nombre));