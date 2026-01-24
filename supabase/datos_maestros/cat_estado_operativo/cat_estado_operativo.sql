-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_estado_operativo
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_estado_operativo;
CREATE TABLE IF NOT EXISTS datos_maestros.cat_estado_operativo (
    id_estado serial4 NOT NULL,
    estado varchar(50) NOT NULL,
    descripcion text NULL,
    es_activo bool DEFAULT true NULL,
    
    -- Auditoría Monterrey
    created_at timestamp NULL DEFAULT (now() AT TIME ZONE 'America/Monterrey'),
    updated_at timestamp NULL DEFAULT (now() AT TIME ZONE 'America/Monterrey'),

    CONSTRAINT cat_estado_operativo_estado_key UNIQUE (estado),
    CONSTRAINT cat_estado_operativo_pkey PRIMARY KEY (id_estado)
);

-- =========================================================
-- ÍNDICES
-- =========================================================
-- Índice para búsquedas rápidas y normalizadas
CREATE INDEX IF NOT EXISTS idx_cat_estado_operativo_normalizado 
ON datos_maestros.cat_estado_operativo (lower(trim(estado)));

-- =========================================================
-- TRIGGERS
-- =========================================================
CREATE TRIGGER trg_set_updated_at_mx_estado_operativo 
BEFORE UPDATE ON datos_maestros.cat_estado_operativo 
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_mx();

-- =========================================================
-- DATOS SEMILLA (SEEDING)
-- =========================================================
CREATE OR REPLACE FUNCTION datos_maestros.seed_cat_estado_operativo()
RETURNS void AS $$
BEGIN
    INSERT INTO datos_maestros.cat_estado_operativo (estado, descripcion)
    VALUES 
        ('Operativo', 'La central se encuentra en operación normal inyectando a la red.'),
        ('En Mantenimiento', 'La central está en periodo de pruebas de puesta en servicio.'),
        ('Fuera de Servicio', 'La central no está disponible para generar por mantenimiento o falla.'),
        ('En Pruebas', 'La central está en periodo de pruebas de puesta en servicio.'),
        ('Desconocido', 'El estado operativo de la central no está definido o es desconocido.')
    ON CONFLICT (estado) DO UPDATE SET
        descripcion = EXCLUDED.descripcion,
        updated_at = (now() AT TIME ZONE 'America/Monterrey');

    RAISE NOTICE 'Semillas de cat_estado_operativo cargadas correctamente.';
END;
$$ LANGUAGE plpgsql;

-- Ejecución inicial
SELECT datos_maestros.seed_cat_estado_operativo();
