DROP TABLE IF EXISTS public.diario_documentos CASCADE;

CREATE TABLE
    public.diario_documentos (
        -- Identificadores y Trazabilidad
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        archivo_origen TEXT,
        -- Estructura Organizativa SAP
        sociedad_sap TEXT,
        fondo_sap TEXT,
        centro_gestor_sap TEXT,
        pospre_sap TEXT,
        cuenta_sap TEXT,
        acreedor_sap TEXT,
        contrato_sap TEXT,
        -- Datos del Proveedor y Contrato
        proveedor TEXT NOT NULL,
        rfc_proveedor TEXT,
        lugar_servicio_id UUID REFERENCES datos_maestros.cat_lugares_servicio (id),
        numero_contrato TEXT,
        nombre_contrato TEXT,
        plurianual TEXT,
        tipo_entrega public.tipo_entrega NOT NULL,
        moneda_documento public.tipo_moneda DEFAULT 'USD',
        -- Datos del Documento (Origen)
        numero_oficio_tramite TEXT,
        fecha_oficio_tramite DATE,
        numero_factura TEXT,
        fecha_factura DATE,
        periodo_contable DATE,
        estimado BOOLEAN DEFAULT FALSE,
        concepto TEXT,
        importe_moneda_original NUMERIC(18, 2), -- Monto tal cual viene en USD o MXN
        iva_moneda_original NUMERIC(18, 2),
        total_moneda_original NUMERIC(18, 2),
        -- Registro Contable del Pasivo (Reconocimiento de deuda en Pesos)
        numero_documento_pasivo TEXT,
        fecha_contable_pasivo DATE,
        tc_contable_pasivo NUMERIC(12, 6), -- TC a la fecha del registro contable
        importe_pasivo_mxn NUMERIC(18, 2), -- Valor de la deuda en MXN al registrarse
        iva_pasivo_mxn NUMERIC(18, 2), -- Impuesto en pesos
        total_pasivo_mxn NUMERIC(18, 2), -- Total de la deuda
        -- Control
        reviso TEXT,
        comentarios TEXT
    );


COMMENT ON TABLE public.diario_documentos IS 'Tabla maestra consolidada: Maneja trazabilidad de moneda original vs liquidación en pesos.';