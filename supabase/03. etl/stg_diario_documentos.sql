DROP TABLE IF EXISTS staging.stg_diario_documentos CASCADE;

CREATE TABLE
    staging.stg_diario_documentos (
        -- Identificadores y Trazabilidad
        import_id SERIAL PRIMARY KEY,
        import_date TIMESTAMP DEFAULT NOW(),
        -- Estructura Organizativa SAP
        sociedad_sap TEXT,
        fondo_sap TEXT,
        centro_gestor_sap TEXT,
        pospre_sap TEXT,
        cuenta_sap TEXT,
        acreedor_sap TEXT,
        contrato_sap TEXT,
        -- Datos del Proveedor y Contrato
        proveedor TEXT,
        rfc_proveedor TEXT,
        lugar_servicio_nombre TEXT, -- Nombre para buscar el ID después
        numero_contrato TEXT,
        nombre_contrato TEXT,
        plurianual TEXT,
        tipo_entrega TEXT,
        moneda_documento TEXT,
        -- Datos del Documento (Origen)
        numero_oficio_tramite TEXT,
        fecha_oficio_tramite TEXT,
        numero_factura TEXT,
        fecha_factura TEXT,
        periodo_contable TEXT,
        estimado TEXT,
        concepto TEXT,
        importe_moneda_original TEXT, -- Monto tal cual viene en USD o MXN
        iva_moneda_original TEXT,
        total_moneda_original TEXT,
        -- Registro Contable del Pasivo (Reconocimiento de deuda en Pesos)
        numero_documento_pasivo TEXT,
        fecha_contable_pasivo TEXT,
        tc_contable_pasivo TEXT, -- TC a la fecha del registro contable
        importe_pasivo_mxn TEXT, -- Valor de la deuda en MXN al registrarse
        iva_pasivo_mxn TEXT, -- Impuesto en pesos
        total_pasivo_mxn TEXT, -- Total de la deuda
        -- Control
        reviso TEXT,
        comentarios TEXT
    );

COMMENT ON TABLE staging.stg_diario_documentos IS 'Tabla staging para carga inicial y validaciones antes de mover a la tabla final en public.diario_documentos.';