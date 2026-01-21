CREATE TABLE IF NOT EXISTS datos_maestros.flujo_mensual_transporte (
    id_flujo serial4 PRIMARY KEY,
    id_contrato int4 REFERENCES datos_maestros.cat_contratos_transporte(id_contrato),
    periodo_mes date NOT NULL, -- Guardar como YYYY-MM-01
    
    -- Tipo: 1 = Estimado (Proyección), 2 = Real (Facturado)
    tipo_registro varchar(20) CHECK (tipo_registro IN ('Estimado', 'Real')),
    
    -- Snapshot de valores al momento del cálculo
    capacidad_snapshot numeric(18,4),
    tarifa_snapshot numeric(18,6),
    
    monto_usd numeric(18,2) NOT NULL,
    tipo_cambio_proyectado numeric(12,4),
    monto_mxn numeric(18,2),
    
    created_at timestamp DEFAULT (now() AT TIME ZONE 'America/Monterrey')
);