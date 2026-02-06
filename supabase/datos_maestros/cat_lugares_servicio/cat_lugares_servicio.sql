-- =========================================================
-- Esquema: datos_maestros
-- Tabla: datos_maestros.cat_lugares_servicio
-- Objetivo: Catálogo de lugares de servicio (México, USA) 
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_lugares_servicio;
CREATE TABLE datos_maestros.cat_lugares_servicio (
id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre text NOT NULL, -- Aquí pondrías 'MÉXICO' y 'USA'
    pais varchar(3) NULL,  -- El código ISO
    created_at timestamptz DEFAULT now() NULL,
    
    CONSTRAINT cat_lugares_servicio_pkey PRIMARY KEY (id),
    CONSTRAINT cat_lugares_servicio_nombre_key UNIQUE (nombre),
    -- Validación simplificada
    CONSTRAINT cat_lugares_servicio_pais_check CHECK (pais IN ('MX', 'USA'))
);

