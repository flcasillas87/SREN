-- =========================================================
-- Esquema: 
-- Tabla: Catálogo de Proveedores
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_proveedores CASCADE;
CREATE TABLE IF NOT EXISTS datos_maestros.cat_proveedores (
    id_proveedor uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    razon_social text NOT NULL, 
    rfc text,
    email text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    CONSTRAINT cat_proveedores_pkey PRIMARY KEY (id_proveedor),
    CONSTRAINT cat_proveedores_rfc_key UNIQUE (rfc),
    CONSTRAINT cat_proveedores_razon_social_key UNIQUE (razon_social)
);
