-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_combustibles
-- =========================================================
drop table if exists datos_maestros.cat_combustibles cascade;
create table datos_maestros.cat_combustibles (
    id_combustible serial not null,
    nombre character varying(50) not null,
    codigo_corto character varying(10) null,
    -- Ej: 'GN', 'DSL', 'CBO'
    descripcion text null,
    tipo text null,
    -- Ej: 'Fósil', 'Renovable'
    es_activo boolean null default true,
    created_at timestamp null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp null default (now() at time zone 'America/Monterrey'),
    constraint cat_combustibles_pkey primary key (id_combustible),
    constraint cat_combustibles_nombre_key unique (nombre),
    constraint cat_combustibles_codigo_key unique (codigo_corto)
) tablespace pg_default;
-- =============================================================================
-- TRIGGER DE ACTUALIZACIÓN
-- =============================================================================
create trigger tr_cat_combustibles_updated before
update on datos_maestros.cat_combustibles for each row execute function public.set_updated_at_mx();
comment on table datos_maestros.cat_combustibles is 'Catálogo maestro de tipos de combustibles para generación eléctrica.';