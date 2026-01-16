INSERT INTO public.diario_documentos (
    sociedad_sap, fondo_sap, centro_gestor_sap, pospre_sap, cuenta_sap, acreedor_sap, contrato_sap,
    proveedor, rfc_proveedor, lugar_servicio_id, numero_contrato, nombre_contrato,
    plurianual, tipo_entrega, moneda_documento,
    numero_oficio_tramite, fecha_oficio_tramite,
    numero_factura, fecha_factura, periodo_contable, estimado, concepto,
    importe_moneda_original, iva_moneda_original, total_moneda_original,
    numero_documento_pasivo, fecha_contable_pasivo, tc_contable_pasivo,
    importe_pasivo_mxn, iva_pasivo_mxn, total_pasivo_mxn,
    reviso, comentarios
)
SELECT 
    sociedad_sap, fondo_sap, centro_gestor_sap, pospre_sap, cuenta_sap, acreedor_sap, contrato_sap,
    proveedor, rfc_proveedor,
    (SELECT id FROM public.cat_lugares_servicio WHERE nombre = stg.lugar_servicio_nombre LIMIT 1),
    numero_contrato, nombre_contrato, plurianual,
    TRIM(LOWER(tipo_entrega))::public.tipo_entrega,
    TRIM(UPPER(moneda_documento))::public.tipo_moneda,
    numero_oficio_tramite,
    TO_DATE(NULLIF(REGEXP_REPLACE(fecha_oficio_tramite, '[^0-9/]', '', 'g'), ''), 'DD/MM/YYYY'),
    numero_factura,
    TO_DATE(NULLIF(REGEXP_REPLACE(fecha_factura, '[^0-9/]', '', 'g'), ''), 'DD/MM/YYYY'),
    TO_DATE(NULLIF(REGEXP_REPLACE(periodo_contable, '[^0-9/]', '', 'g'), ''), 'DD/MM/YYYY'),
    CASE WHEN TRIM(LOWER(estimado)) IN ('1', 'true', 'si', 'sí') THEN TRUE ELSE FALSE END,
    concepto,
    -- LIMPIEZA DE IMPORTES: Maneja $, comas, espacios y el guion solitario "-"
    NULLIF(NULLIF(REGEXP_REPLACE(importe_moneda_original, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC, -- 23
    NULLIF(NULLIF(REGEXP_REPLACE(iva_moneda_original, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,     -- 24
    NULLIF(NULLIF(REGEXP_REPLACE(total_moneda_original, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,   -- 25
    numero_documento_pasivo,
    TO_DATE(NULLIF(REGEXP_REPLACE(fecha_contable_pasivo, '[^0-9/]', '', 'g'), ''), 'DD/MM/YYYY'),
    NULLIF(NULLIF(REGEXP_REPLACE(tc_contable_pasivo, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,      -- 28
    NULLIF(NULLIF(REGEXP_REPLACE(importe_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,      -- 29
    NULLIF(NULLIF(REGEXP_REPLACE(iva_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,          -- 30
    NULLIF(NULLIF(REGEXP_REPLACE(total_pasivo_mxn, '[^0-9.-]', '', 'g'), ''), '-')::NUMERIC,        -- 31
    reviso, comentarios
FROM staging.stg_diario_documentos stg;