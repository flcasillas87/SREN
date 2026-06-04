-- =============================================================================
-- TABLA DE PRECIOS VINCULANTES
-- =============================================================================
drop table if exists public.audit_precios_vinculantes_combustibles cascade;
drop table if exists public.precios_vinculantes_combustibles cascade;

create table public.precios_vinculantes_combustibles (
    id_precio_vinculante_combustible bigint generated always as identity not null,
    fecha date not null,
    id_combustible integer not null,
    id_unidad_medida integer not null,
    id_central_generacion integer not null,
    precio_vinculante_combustibles numeric(15, 4) not null,
    fuente text null,
    observaciones text null,
    es_activo boolean default true,
    created_at timestamp default (now() at time zone 'America/Monterrey'),
    updated_at timestamp default (now() at time zone 'America/Monterrey'),
    created_by uuid default auth.uid(),
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
) tablespace pg_default;
-- =============================================================================
-- TABLA DE AUDITORÍA
-- =============================================================================
create table public.audit_precios_vinculantes_combustibles (
    id_audit_precio_vinculante_combustible bigint generated always as identity primary key,
    id_precio_vinculante_combustible bigint not null,
    precio_anterior numeric(15, 4),
    precio_nuevo numeric(15, 4),
    usuario_cambio uuid,
    fecha_cambio timestamp default (now() at time zone 'America/Monterrey'),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);
