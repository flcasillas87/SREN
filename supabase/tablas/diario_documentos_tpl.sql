-- Creación de la tabla principal de Gestión de Pagos
CREATE TABLE gestion_pagos (
    -- Identificadores únicos y auditoría
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Datos del Proveedor y Contrato
    proveedor TEXT NOT NULL,
    acreedor_sa TEXT,
    contrato_sa TEXT,
    plurianual BOOLEAN DEFAULT FALSE,
    lugar_del_servicio TEXT,
    numero_contrato TEXT,
    
    -- Detalles Operativos y Tarifas
    servicio_bien TEXT,
    tipo_de_reserva TEXT,
    reserva_de_c TEXT,
    reserva_diar TEXT,
    flujo_promedio NUMERIC(15, 2),
    volumen_mensual NUMERIC(15, 2),
    tarifa NUMERIC(15, 4),
    usppio NUMERIC(15, 4),
    uspplm NUMERIC(15, 4),
    participacion_porcentaje NUMERIC(5, 2),
    
    -- Periodos y Tiempos
    ano_del_pago INTEGER,
    ano_del_servicio INTEGER,
    periodo_del_inicio DATE,
    periodo_del_fin DATE,
    mes TEXT,
    
    -- Facturación y Documentación
    numero_de_factura TEXT,
    fecha_de_factura DATE,
    oficio_de_pago TEXT,
    clave TEXT,
    moneda VARCHAR(5) DEFAULT 'MXN',
    estimado BOOLEAN DEFAULT FALSE,
    validacion TEXT,
    
    -- Montos Financieros
    importe NUMERIC(18, 2),
    iva NUMERIC(18, 2),
    total NUMERIC(18, 2),
    
    -- Datos Contables (ERP)
    sociedad TEXT,
    pos_pre TEXT,
    cuenta_contable TEXT,
    fondo TEXT,
    centro_gestor TEXT,
    nombre_del_costo TEXT,
    numero_documento_aux TEXT,
    
    -- Pasivos y Pagos
    numero_documento_pasivo TEXT,
    fecha_pasivo DATE,
    importe_pasivo NUMERIC(18, 2),
    iva_pasivo NUMERIC(18, 2),
    total_pasivo NUMERIC(18, 2),
    tc_pasivo NUMERIC(10, 4), -- Tipo de Cambio
    
    fecha_de_pago DATE,
    importe_de_pago NUMERIC(18, 2),
    iva_de_pago NUMERIC(18, 2),
    total_de_pago NUMERIC(18, 2),
    tc_pago NUMERIC(10, 4),
    
    -- Control y Revisión
    reviso TEXT,
    porcentaje_impuestos NUMERIC(5, 2),
    documento_de_pago TEXT,
    pagadero_en_dolares BOOLEAN DEFAULT FALSE,
    pago_en_pesos NUMERIC(18, 2)
);

-- Comentarios para documentación de la tabla
COMMENT ON TABLE gestion_pagos IS 'Tabla para el seguimiento de contratos, facturación y pagos a proveedores.';