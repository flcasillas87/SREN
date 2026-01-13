-- =============================================================================
-- TABLA: cat_combustibles
-- =============================================================================
drop table if exists public.cat_combustibles cascade;
create table public.cat_combustibles (
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
update on public.cat_combustibles for each row execute function public.set_updated_at_mx();
-- =============================================================================
-- DATOS SEMILLA (SEEDING)
-- =============================================================================
insert into public.cat_combustibles (nombre, codigo_corto, tipo, descripcion)
values (
        'Gas Natural',
        'GN',
        'Fósil',
        'Gas natural seco para turbogeneración'
    ),
    (
        'Diesel',
        'DSL',
        'Fósil',
        'Combustible líquido destilado'
    ),
    (
        'Fuel Oil',
        'FO',
        'Fósil',
        'Combustible líquido residual (Combustóleo)'
    ),
    (
        'Carbón',
        'CBO',
        'Fósil',
        'Carbón mineral para centrales térmicas'
    ) on conflict (nombre) do
update
set codigo_corto = excluded.codigo_corto,
    tipo = excluded.tipo,
    descripcion = excluded.descripcion,
    updated_at = now();
comment on table public.cat_combustibles is 'Catálogo maestro de tipos de combustibles para generación eléctrica.';