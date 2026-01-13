-- =============================================================================
-- LIMPIEZA DE OBJETOS (ORDENADOS POR DEPENDENCIAS)
-- =============================================================================
drop view if exists public.v_dashboard_precios;
drop table if exists public.audit_precios_vinculantes cascade;
drop table if exists public.precios_vinculantes_combustibles cascade;


-- =============================================================================
-- FUNCIONES DE APOYO (AUDITORÍA Y VALIDACIÓN)
-- =============================================================================

-- Función para actualizar el timestamp 'updated_at'
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

-- Función para bloquear edición de precios antiguos (más de 7 días)
create or replace function public.check_fecha_vinculante()
returns trigger as $$
begin
    if (old.fecha < current_date - interval '7 days') then
        raise exception 'No se pueden modificar precios vinculantes con más de 7 días de antigüedad.';
    end if;
    return new;
end;
$$ language plpgsql;


-- =============================================================================
-- TABLA DE PRECIOS VINCULANTES
-- =============================================================================

create table public.precios_vinculantes_combustibles (
    id_precio_vinculante bigint generated always as identity,
    fecha date not null,
    id_combustible integer not null references public.cat_combustibles(id_combustible) on delete restrict,
    id_unidad integer not null references public.cat_unidades(id_unidad) on delete restrict,
    precio_vinculante numeric(15, 4) not null,
    fuente text null,
    observaciones text null,
    es_activo boolean default true,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now(),
    created_by uuid references auth.users(id) default auth.uid(),
    
    constraint precios_vinculantes_combustibles_pkey primary key (id_precio_vinculante),
    constraint uq_precio_fecha_combustible unique(fecha, id_combustible)
) tablespace pg_default;

-- =============================================================================
-- TABLA DE AUDITORÍA
-- =============================================================================

create table public.audit_precios_vinculantes (
    id_audit bigint generated always as identity primary key,
    id_precio_vinculante bigint,
    precio_anterior numeric(15, 4),
    precio_nuevo numeric(15, 4),
    usuario_cambio uuid,
    fecha_cambio timestamp with time zone default now()
);

-- =============================================================================
-- TRIGGERS
-- =============================================================================
-- Limpieza de triggers existentes
drop trigger if exists tr_precios_vinculantes_updated on public.precios_vinculantes_combustibles;
drop trigger if exists tr_audit_precios on public.precios_vinculantes_combustibles;
drop trigger if exists tr_bloqueo_precios_antiguos on public.precios_vinculantes_combustibles;

-- Actualización de fechas
create trigger tr_precios_vinculantes_updated before update on public.precios_vinculantes_combustibles for each row execute function public.handle_updated_at();

-- Auditoría de precios
create or replace function public.log_cambios_precios()
returns trigger as $$
begin
    insert into public.audit_precios_vinculantes (id_precio_vinculante, precio_anterior, precio_nuevo, usuario_cambio)
    values (old.id_precio_vinculante, old.precio_vinculante, new.precio_vinculante, auth.uid());
    return new;
end;
$$ language plpgsql;

create trigger tr_audit_precios after update on public.precios_vinculantes_combustibles for each row execute function public.log_cambios_precios();

-- Bloqueo de fechas antiguas
create trigger tr_bloqueo_precios_antiguos before update or delete on public.precios_vinculantes_combustibles for each row execute function public.check_fecha_vinculante();

-- =============================================================================
-- ÍNDICES, VISTAS Y SEGURIDAD (RLS)
-- =============================================================================

create index idx_precios_vinculantes_fecha_combustible on public.precios_vinculantes_combustibles (fecha desc, id_combustible);

create or replace view public.v_dashboard_precios as
select 
    p.fecha,
    c.nombre as combustible,
    p.precio_vinculante as precio_nominal,
    u.codigo as unidad,
    round((p.precio_vinculante * u.factor_conversion_mbtu), 4) as costo_mbtu,
    p.fuente
from public.precios_vinculantes_combustibles p
join public.cat_combustibles c on p.id_combustible = c.id_combustible
join public.cat_unidades u on p.id_unidad = u.id_unidad
where p.es_activo = true;

-- Seguridad RLS

