-- =========================================================
-- Esquema: 
-- Tabla: Catálogo de Proveedores
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_proveedores CASCADE;
CREATE TABLE IF NOT EXISTS datos_maestros.cat_proveedores (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    razon_social text NOT NULL, 
    rfc text,
    email text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    
    CONSTRAINT cat_proveedores_pkey PRIMARY KEY (id),
    CONSTRAINT cat_proveedores_rfc_key UNIQUE (rfc),
    CONSTRAINT cat_proveedores_razon_social_key UNIQUE (razon_social)
);