-- =============================================================================
-- TABLA: reporte_operativo_combustibles
-- =============================================================================
-- Modelo de hechos para el reporte operativo por tipo de combustible
-- entregado a cada central generadora.
-- =============================================================================

drop table if exists public.reporte_operativo_combustibles cascade;

create table public.reporte_operativo_combustibles (
    id_reporte_operativo_combustibles uuid not null default extensions.uuid_generate_v4(),
    fecha_entrega date not null,
    id_central_generacion uuid not null,
    id_combustible uuid not null,
    id_unidad_medida uuid not null,
    volumen numeric(18, 4) not null,
    fuente text null,
    observaciones text null,
    archivo_origen text null,
    es_activo boolean default true,
    created_at timestamp default (now() at time zone 'America/Monterrey'),
    updated_at timestamp default (now() at time zone 'America/Monterrey'),
    created_by uuid default auth.uid(),
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
) tablespace pg_default;
