drop table if exists public.cat_combustibles cascade;

create table public.cat_combustibles (
    id_combustible serial not null,
    nombre character varying(50) not null,
    codigo_corto character varying(10) null, -- Ej: 'GN', 'DSL', 'CBO'
    descripcion text null,
    tipo text null, -- Ej: 'Fósil', 'Renovable'
    es_activo boolean null default true,
    created_at timestamp with time zone null default now(),
    updated_at timestamp with time zone null default now(),
    
    constraint cat_combustibles_pkey primary key (id_combustible),
    constraint cat_combustibles_nombre_key unique (nombre),
    constraint cat_combustibles_codigo_key unique (codigo_corto)
) tablespace pg_default;

comment on table public.cat_combustibles is 'Catálogo maestro de tipos de combustibles para generación eléctrica.';