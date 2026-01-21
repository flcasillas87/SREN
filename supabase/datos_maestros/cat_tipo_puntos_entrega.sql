-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================
CREATE TABLE datos_maestros.cat_puntos_entrega (
    id_punto uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    nombre_punto text NOT NULL,
    codigo_cre text, -- Opcional: Código de la CRE
    sistema_pertenece text, -- Ej: Sistrangas, Mayakan
    activo bool DEFAULT true,
    CONSTRAINT cat_puntos_entrega_pkey PRIMARY KEY (id_punto),
    CONSTRAINT cat_puntos_entrega_nombre_key UNIQUE (nombre_punto)
);

-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================