-- =============================================================================
-- LIMPIEZA DE OBJETOS (ORDENADOS POR DEPENDENCIAS)
-- =============================================================================
drop view if exists public.v_dashboard_precios_vinculantes_combustibles;
drop trigger if exists tr_precios_vinculantes_combustibles_updated on public.precios_vinculantes_combustibles;
drop trigger if exists tr_audit_precios_vinculantes_combustibles on public.precios_vinculantes_combustibles;
drop trigger if exists tr_bloqueo_precios_vinculantes_combustibles_antiguos on public.precios_vinculantes_combustibles;
drop table if exists public.audit_precios_vinculantes_combustibles cascade;
drop table if exists public.precios_vinculantes_combustibles cascade;
-- =============================================================================
-- TABLA DE PRECIOS VINCULANTES
-- =============================================================================
create table public.precios_vinculantes_combustibles (
    id_precio_vinculante_combustible bigint generated always as identity,
    fecha date not null,
    id_combustible integer not null references public.cat_combustibles(id_combustible) on delete restrict,
    id_unidad integer not null references public.cat_unidades(id_unidad) on delete restrict,
    id_central_generacion integer not null references public.cat_centrales_generacion(id_central_generacion) on delete restrict,
    precio_vinculante_combustibles numeric(15, 4) not null,
    fuente text null,
    observaciones text null,
    es_activo boolean default true,
    created_at timestamp default (now() at time zone 'America/Monterrey'),
    updated_at timestamp default (now() at time zone 'America/Monterrey'),
    created_by uuid references auth.users(id) default auth.uid(),
    -- Llaves y restricciones    
    constraint precios_vinculantes_combustibles_pkey primary key (id_precio_vinculante_combustible),
    constraint uq_precio_fecha_combustible_central unique(fecha, id_combustible, id_central_generacion)
) tablespace pg_default;
-- =============================================================================
-- TABLA DE AUDITORÍA
-- =============================================================================
create table public.audit_precios_vinculantes_combustibles (
    id_audit_precio_vinculante_combustible bigint generated always as identity primary key,
    id_precio_vinculante_combustible bigint,
    precio_anterior numeric(15, 4),
    precio_nuevo numeric(15, 4),
    usuario_cambio uuid,
    fecha_cambio timestamp default (now() at time zone 'America/Monterrey')
);
-- =============================================================================
-- ÍNDICES
-- =============================================================================
create index idx_precios_vinculantes_fecha_combustible on public.precios_vinculantes_combustibles (fecha desc, id_combustible);
create index idx_precios_vinculantes_central_fecha on public.precios_vinculantes_combustibles (id_central_generacion, fecha desc);
create index idx_precios_vinculantes_activo on public.precios_vinculantes_combustibles (es_activo)
where es_activo = true;
create index idx_precios_vinculantes_lookup on public.precios_vinculantes_combustibles (
    id_combustible,
    id_central_generacion,
    fecha desc
);
-- =============================================================================
-- TRIGGERS
-- =============================================================================
-- Actualización de fechas (updated_at)
create trigger tr_precios_vinculantes_combustibles_updated before
update on public.precios_vinculantes_combustibles for each row execute function public.set_updated_at_mx();
-- Auditoría de cambios de precios
create trigger tr_audit_precios_vinculantes_combustibles
after
update on public.precios_vinculantes_combustibles for each row
    when (
        old.precio_vinculante_combustibles is distinct
        from new.precio_vinculante_combustibles
    ) execute function public.log_cambios_precios();
-- Bloqueo de fechas antiguas
create trigger tr_bloqueo_precios_vinculantes_combustibles_antiguos before
update
    or delete on public.precios_vinculantes_combustibles for each row execute function public.check_fecha_vinculante();
-- =============================================================================
-- VISTA PARA DASHBOARD DE PRECIOS
-- =============================================================================
create or replace view public.v_dashboard_precios_vinculantes_combustibles as
select p.fecha,
    c.nombre as combustible,
    p.precio_vinculante_combustibles as precio_nominal,
    u.codigo as unidad,
    round(
        (
            p.precio_vinculante_combustibles * u.factor_conversion_mbtu
        ),
        4
    ) as costo_mbtu,
    p.fuente
from public.precios_vinculantes_combustibles p
    join public.cat_combustibles c on p.id_combustible = c.id_combustible
    join public.cat_unidades u on p.id_unidad = u.id_unidad
where p.es_activo = true;