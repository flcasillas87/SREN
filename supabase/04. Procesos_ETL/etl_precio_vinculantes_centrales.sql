-- =============================================================================
-- TABLA DE STAGING 
-- =============================================================================
drop table if exists staging.stg_precios_vinculantes_combustibles cascade;
create table staging.stg_precios_vinculantes_combustibles (
    fecha text,
    nombre_combustible text,
    nombre_unidad text,
    nombre_central_generacion text,
    precio_vinculante_combustibles text,
    fuente text,
    observaciones text
);
-- =============================================================================
-- FUNCIÓN ETL CON CONVERSIÓN DE TIPOS
-- =============================================================================
create or replace function public.etl_precios_vinculantes_combustibles() returns void as $$ begin
insert into public.precios_vinculantes_combustibles (
        fecha,
        id_combustible,
        id_unidad,
        id_central_generacion,
        precio_vinculante_combustibles,
        fuente,
        observaciones
    )
select s.fecha::date,
    c.id_combustible,
    u.id_unidad,
    cen.id_central_generacion,
    s.precio_vinculante_combustibles::numeric(15, 4),
    s.fuente,
    s.observaciones
from public.stg_precios_vinculantes_combustibles s
    join public.cat_combustibles c on lower(trim(s.nombre)) = lower(c.nombre)
    join public.cat_unidades u on upper(trim(s.nombre_unidad)) = upper(u.codigo)
    join public.cat_centrales_generacion cen on lower(trim(s.nombre_central_generacion)) = lower(cen.nombre_central);
-- Limpiamos staging después del éxito de la operación
-- truncate table public.stg_precios_vinculantes_combustibles;
exception
when others then raise exception 'Error en el proceso ETL: %',
sqlerrm;
end;
$$ language plpgsql;