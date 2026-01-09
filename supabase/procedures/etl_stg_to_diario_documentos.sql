INSERT INTO public.diario_documentos (
    sociedad_sap, fondo_sap, centro_gestor_sap, pospre_sap, cuenta_sap, acreedor_sap, contrato_sap, -- 1-7
    proveedor, rfc_proveedor, lugar_servicio_id, numero_contrato, nombre_contrato,                -- 8-12
    plurianual, tipo_entrega, moneda_documento,                                                   -- 13-15
    numero_oficio_tramite, fecha_oficio_tramite,                                                  -- 16-17
    numero_factura, fecha_factura, periodo_contable, estimado, concepto,                          -- 18-22
    importe_moneda_original, iva_moneda_original, total_moneda_original,                          -- 23-25
    numero_documento_pasivo, fecha_contable_pasivo, tc_contable_pasivo,                           -- 26-28
    importe_pasivo_mxn, iva_pasivo_mxn, total_pasivo_mxn,                                         -- 29-31
    reviso, comentarios                                                                           -- 32-33
)
SELECT 
    sociedad_sap,         -- 1
    fondo_sap,           -- 2
    centro_gestor_sap,    -- 3
    pospre_sap,           -- 4
    cuenta_sap,           -- 5
    acreedor_sap,         -- 6
    contrato_sap,         -- 7
    proveedor,            -- 8
    rfc_proveedor,        -- 9
    (SELECT id FROM public.cat_lugares_servicio WHERE nombre = stg.lugar_servicio_nombre LIMIT 1), -- 10
    numero_contrato,      -- 11
    nombre_contrato,      -- 12
    plurianual,           -- 13
    TRIM(LOWER(tipo_entrega))::public.tipo_entrega,   -- 14
    TRIM(UPPER(moneda_documento))::public.tipo_moneda, -- 15
    numero_oficio_tramite, -- 16
    NULLIF(fecha_oficio_tramite, '')::DATE,           -- 17 (Aquí caía el "1" antes)
    numero_factura,       -- 18
    NULLIF(fecha_factura, '')::DATE,                  -- 19
    NULLIF(periodo_contable, '')::DATE,               -- 20
    CASE 
        WHEN TRIM(LOWER(estimado)) IN ('1', 'true', 't', 'si', 'sí') THEN TRUE 
        ELSE FALSE 
    END,                  -- 21 (Convertimos el "1" a booleano real)
    concepto,             -- 22
    NULLIF(REPLACE(importe_moneda_original, ',', ''), '')::NUMERIC, -- 23
    NULLIF(REPLACE(iva_moneda_original, ',', ''), '')::NUMERIC,     -- 24
    NULLIF(REPLACE(total_moneda_original, ',', ''), '')::NUMERIC,   -- 25
    numero_documento_pasivo, -- 26
    NULLIF(fecha_contable_pasivo, '')::DATE,          -- 27
    NULLIF(REPLACE(tc_contable_pasivo, ',', ''), '')::NUMERIC,      -- 28
    NULLIF(REPLACE(importe_pasivo_mxn, ',', ''), '')::NUMERIC,      -- 29
    NULLIF(REPLACE(iva_pasivo_mxn, ',', ''), '')::NUMERIC,          -- 30
    NULLIF(REPLACE(total_pasivo_mxn, ',', ''), '')::NUMERIC,        -- 31
    reviso,               -- 32
    comentarios           -- 33
FROM staging.stg_diario_documentos stg;