-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================


-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================


CREATE TABLE datos_maestros.cat_sociedades (
    id_sociedad uuid not null default extensions.uuid_generate_v4(),
    codigo_sociedad TEXT NOT NULL,
    nombre_sociedad TEXT NOT NULL,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    constraint cat_sociedades_pkey primary key (id_sociedad),
    constraint cat_sociedades_codigo_key unique (codigo_sociedad)
);
