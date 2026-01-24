-- =========================================================
-- Esquema: 
-- Tabla: Catálogo de Contratos de Transport
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_contratos_transporte CASCADE;

CREATE TABLE datos_maestros.cat_contratos_transporte (
    id_contrato uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    id_proveedor uuid NOT NULL,
    
    -- Relación con cat_monedas (debe coincidir con VARCHAR(5))
    moneda_tarifa VARCHAR(5) NOT NULL, 
    
    id_unidad_medida int4,
    plurianual text, 
    nombre_contrato text NOT NULL,
    sistema_transporte text,
    capacidad_reservada_diaria numeric(18,4), 
    tarifa_reservacion numeric(18,6),
    tarifa_uso numeric(18,6) DEFAULT 0,
    fecha_inicio date,
    fecha_fin date,
    activo bool DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT cat_contratos_transporte_pkey PRIMARY KEY (id_contrato),
    CONSTRAINT cat_contratos_transporte_nombre_key UNIQUE (nombre_contrato),
    
    -- Llave Foránea hacia Proveedores
    CONSTRAINT fk_contrato_proveedor 
        FOREIGN KEY (id_proveedor) 
        REFERENCES datos_maestros.cat_proveedores(id_proveedor),
        
    -- Llave Foránea hacia Monedas
    CONSTRAINT fk_contrato_moneda 
        FOREIGN KEY (moneda_tarifa) 
        REFERENCES datos_maestros.cat_monedas(codigo)
);

