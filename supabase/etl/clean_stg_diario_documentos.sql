UPDATE staging.stg_diario_documentos 
SET 
    -- 1. NORMALIZACIÓN DE TEXTO Y ENUMS
    tipo_entrega = TRIM(LOWER(NULLIF(tipo_entrega, ''))),
    moneda_documento = TRIM(UPPER(NULLIF(moneda_documento, ''))),
    proveedor = TRIM(proveedor),

    -- 2. LIMPIEZA NUMÉRICA AVANZADA (Maneja $, comas, espacios y guiones "-")
    importe_moneda_original = NULLIF(NULLIF(REGEXP_REPLACE(importe_moneda_original, '[^0-9.-]', '', 'g'), ''), '-'),
    iva_moneda_original = NULLIF(NULLIF(REGEXP_REPLACE(iva_moneda_original, '[^0-9.-]', '', 'g'), ''), '-'),
    total_moneda_original = NULLIF(NULLIF(REGEXP_REPLACE(total_moneda_original, '[^0-9.-]', '', 'g'), ''), '-'),
    tc_contable_pasivo = NULLIF(NULLIF(REGEXP_REPLACE(tc_contable_pasivo, '[^0-9.-]', '', 'g'), ''), '-'),
    importe_pasivo_mxn = NULLIF(NULLIF(REGEXP_REPLACE(importe_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-'),
    iva_pasivo_mxn = NULLIF(NULLIF(REGEXP_REPLACE(iva_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-'),
    total_pasivo_mxn = NULLIF(NULLIF(REGEXP_REPLACE(total_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-'),

    -- 3. VALIDACIÓN DE FECHAS (Evita el error "out of range" y basura como "1")
    fecha_oficio_tramite = CASE 
        WHEN fecha_oficio_tramite ~ '^\d{1,2}/\d{1,2}/\d{2,4}$' THEN fecha_oficio_tramite 
        WHEN fecha_oficio_tramite ~ '^\d{4}-\d{2}-\d{2}$' THEN fecha_oficio_tramite 
        ELSE NULL 
    END,
    fecha_factura = CASE 
        WHEN fecha_factura ~ '^\d{1,2}/\d{1,2}/\d{2,4}$' THEN fecha_factura 
        WHEN fecha_factura ~ '^\d{4}-\d{2}-\d{2}$' THEN fecha_factura 
        ELSE NULL 
    END,
    periodo_contable = CASE 
        WHEN periodo_contable ~ '^\d{1,2}/\d{1,2}/\d{2,4}$' THEN periodo_contable 
        WHEN periodo_contable ~ '^\d{4}-\d{2}-\d{2}$' THEN periodo_contable 
        ELSE NULL 
    END,
    fecha_contable_pasivo = CASE 
        WHEN fecha_contable_pasivo ~ '^\d{1,2}/\d{1,2}/\d{2,4}$' THEN fecha_contable_pasivo 
        WHEN fecha_contable_pasivo ~ '^\d{4}-\d{2}-\d{2}$' THEN fecha_contable_pasivo 
        ELSE NULL 
    END;

-- 4. ELIMINACIÓN DE FILAS INVÁLIDAS (Para evitar violación de NOT NULL en proveedor)
DELETE FROM staging.stg_diario_documentos 
WHERE proveedor IS NULL OR TRIM(proveedor) = '';