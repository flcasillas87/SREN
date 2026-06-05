-- =============================================================================
-- TABLA DE PRECIOS VINCULANTES DE SUMINISTRO DE COMBUSTIBLES
-- =============================================================================

drop table if exists public.fact_precio_vinculante cascade;

create table public.fact_precio_vinculante (
    id_precio_vinculante uuid not null default gen_random_uuid(),
    id_combustible uuid not null,
    id_region uuid not null,
    fecha_inicio_vigencia date not null,
    fecha_fin_vigencia date not null,
    precio_vinculante numeric(14,6) not null,
    moneda text default 'MXN',
    fuente text not null,
    documento_referencia text null,
    activo boolean default true,
    created_at timestamptz default now(),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamptz null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
) tablespace pg_default;
