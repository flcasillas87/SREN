-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_contratos_transporte CASCADE;
CREATE TABLE IF NOT EXISTS datos_maestros.cat_contratos_transporte (
    id_contrato serial4 PRIMARY KEY,
    id_proveedor int4 NOT NULL REFERENCES datos_maestros.cat_proveedores(id_proveedor),
    id_moneda int4 NOT NULL REFERENCES datos_maestros.cat_monedas(id_moneda),
    id_unidad_medida int4 REFERENCES datos_maestros.cat_unidades_medida(id_unidad_medida),
    id_plurianual varchar(50),
    nombre_contrato varchar(100) NOT NULL,
    sistema_transporte varchar(100),
    capacidad_reservada_diaria numeric(18, 4),
    tarifa_reservacion numeric(18, 6),
    tarifa_uso numeric(18, 6) DEFAULT 0,
    fecha_inicio date,
    fecha_fin date,
    activo bool DEFAULT true,
    created_at timestamp DEFAULT (now() AT TIME ZONE 'America/Monterrey'),
    updated_at timestamp DEFAULT (now() AT TIME ZONE 'America/Monterrey')
);