-- =========================================================
-- Esquema: staging
-- Tabla: stg_precios_vinculantes_combustibles
-- Archivo: 01.validate.sql
-- Descripcion: Identifica errores de calidad antes de normalizar
-- =========================================================

drop view if exists staging.vw_precios_vinculantes_combustibles_validation_errors;

create view staging.vw_precios_vinculantes_combustibles_validation_errors as
with src as (
    select
        id_stg_precio_vinculante_combustible as source_row,
        batch_id,
        fecha,
        nombre_combustible,
        nombre_unidad_medida,
        nombre_central,
        precio_vinculante_combustibles
    from staging.stg_precios_vinculantes_combustibles
),
norm as (
    select
        s.*,
        case
            when nullif(btrim(s.fecha), '') is null then null
            when btrim(s.fecha) ~ '^\d{4}-\d{2}-\d{2}$' then to_date(btrim(s.fecha), 'YYYY-MM-DD')
            when btrim(s.fecha) ~ '^\d{2}/\d{2}/\d{4}$' then to_date(btrim(s.fecha), 'DD/MM/YYYY')
            else null
        end as fecha_normalizada,
        upper(btrim(s.nombre_combustible)) as combustible_key,
        upper(btrim(s.nombre_unidad_medida)) as unidad_key,
        regexp_replace(upper(btrim(s.nombre_central)), '\s+', ' ', 'g') as central_key,
        nullif(
            replace(replace(replace(btrim(s.precio_vinculante_combustibles), ',', ''), '$', ''), ' ', ''),
            ''
        ) as precio_clean
    from src s
),
duplicados as (
    select
        fecha_normalizada,
        combustible_key,
        central_key
    from norm
    where fecha_normalizada is not null
      and nullif(combustible_key, '') is not null
      and nullif(central_key, '') is not null
    group by fecha_normalizada, combustible_key, central_key
    having count(*) > 1
)
select
    n.source_row,
    'fecha' as columna,
    'La fecha es obligatoria y debe venir con formato YYYY-MM-DD o DD/MM/YYYY.' as error_detalle
from norm n
where n.fecha_normalizada is null

union all

select
    n.source_row,
    'fecha' as columna,
    'La fecha debe estar entre 2000-01-01 y la fecha actual.' as error_detalle
from norm n
where n.fecha_normalizada is not null
  and (
        n.fecha_normalizada < date '2000-01-01'
        or n.fecha_normalizada > current_date
      )

union all

select
    n.source_row,
    'nombre_combustible' as columna,
    'El combustible es obligatorio.' as error_detalle
from norm n
where nullif(n.combustible_key, '') is null

union all

select
    n.source_row,
    'nombre_unidad_medida' as columna,
    'La unidad de medida es obligatoria.' as error_detalle
from norm n
where nullif(n.unidad_key, '') is null

union all

select
    n.source_row,
    'nombre_central' as columna,
    'La central de generacion es obligatoria.' as error_detalle
from norm n
where nullif(n.central_key, '') is null

union all

select
    n.source_row,
    'precio_vinculante_combustibles' as columna,
    'El precio es obligatorio y debe ser numerico.' as error_detalle
from norm n
where n.precio_clean is null
   or n.precio_clean !~ '^-?\d+(\.\d+)?$'

union all

select
    n.source_row,
    'precio_vinculante_combustibles' as columna,
    'El precio debe ser mayor a cero.' as error_detalle
from norm n
where n.precio_clean ~ '^-?\d+(\.\d+)?$'
  and n.precio_clean::numeric <= 0

union all

select
    n.source_row,
    'nombre_combustible' as columna,
    'El combustible no existe en datos_maestros.cat_combustibles.' as error_detalle
from norm n
where nullif(n.combustible_key, '') is not null
  and not exists (
        select 1
        from datos_maestros.cat_combustibles c
        where upper(btrim(c.nombre_combustible)) = n.combustible_key
    )

union all

select
    n.source_row,
    'nombre_central' as columna,
    'La central no existe en datos_maestros.cat_centrales_generacion.' as error_detalle
from norm n
where nullif(n.central_key, '') is not null
  and not exists (
        select 1
        from datos_maestros.cat_centrales_generacion cg
        where regexp_replace(upper(btrim(cg.nombre_central)), '\s+', ' ', 'g') = n.central_key
    )

union all

select
    n.source_row,
    'nombre_unidad_medida' as columna,
    'La unidad de medida no existe para el combustible indicado.' as error_detalle
from norm n
where nullif(n.unidad_key, '') is not null
  and nullif(n.combustible_key, '') is not null
  and not exists (
        select 1
        from datos_maestros.cat_unidades_medida u
        join datos_maestros.cat_combustibles c
          on c.id_combustible = u.id_combustible
        where upper(btrim(u.codigo)) = n.unidad_key
          and upper(btrim(c.nombre_combustible)) = n.combustible_key
    )

union all

select
    n.source_row,
    'fecha,nombre_combustible,nombre_central' as columna,
    'La combinacion fecha + combustible + central esta duplicada dentro del archivo.' as error_detalle
from norm n
join duplicados d
  on d.fecha_normalizada = n.fecha_normalizada
 and d.combustible_key = n.combustible_key
 and d.central_key = n.central_key;
