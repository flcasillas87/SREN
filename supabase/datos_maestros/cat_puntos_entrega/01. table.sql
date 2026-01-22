-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_puntos_entrega
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_puntos_entrega CASCADE;
CREATE TABLE datos_maestros.cat_puntos_entrega (
    id_punto uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    nombre_punto text NOT NULL,
    codigo text,
    sistema_transporte text,
    capacidad_tecnica_mmscfd numeric,
    activo bool DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT cat_puntos_entrega_pkey PRIMARY KEY (id_punto),
    CONSTRAINT cat_puntos_entrega_nombre_key UNIQUE (nombre_punto)
);