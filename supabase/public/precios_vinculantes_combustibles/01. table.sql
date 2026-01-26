-- =============================================================================
-- TABLA DE PRECIOS VINCULANTES
-- =============================================================================
drop table if exists public.audit_precios_vinculantes_combustibles cascade;
drop table if exists public.precios_vinculantes_combustibles cascade;

create table public.precios_vinculantes_combustibles (
    id_precio_vinculante_combustible bigint generated always as identity not null,
    fecha date not null,
    id_combustible integer not null references datos_maestros.cat_combustibles(id_combustible) on delete restrict,
    id_unidad_medida integer not null references datos_maestros.cat_unidades_medida(id_unidad_medida) on delete restrict,
    id_central_generacion integer not null references datos_maestros.cat_centrales_generacion(id_central_generacion) on delete restrict,
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
    id_precio_vinculante_combustible bigint not null,
    precio_anterior numeric(15, 4),
    precio_nuevo numeric(15, 4),
    usuario_cambio uuid,
    fecha_cambio timestamp default (now() at time zone 'America/Monterrey'),
    constraint audit_pv_id_precio_fkey
      foreign key (id_precio_vinculante_combustible)
      references public.precios_vinculantes_combustibles(id_precio_vinculante_combustible)
      on delete restrict    
);
