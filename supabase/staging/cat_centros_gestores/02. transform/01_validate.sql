-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 01_validate.sql
-- Descripción: Valida datos cargados desde CSV
-- =========================================================

drop view if exists staging.vw_cat_centros_gestores_validation_errors;

create view staging.vw_cat_centros_gestores_validation_errors as
with src as (
  select
    row_number() over () as source_row,
    codigo,
    nombre,
    sociedad_id,
    activo
  from staging.cat_centros_gestores
),
duplicados as (
  select
    btrim(codigo) as codigo
  from staging.cat_centros_gestores
  where nullif(btrim(codigo), '') is not null
  group by btrim(codigo)
  having count(*) > 1
)
select
  s.source_row,
  'codigo' as columna,
  'El codigo es obligatorio y no puede venir vacio.' as error_detalle
from src s
where nullif(btrim(s.codigo), '') is null

union all

select
  s.source_row,
  'nombre' as columna,
  'El nombre es obligatorio y no puede venir vacio.' as error_detalle
from src s
where nullif(btrim(s.nombre), '') is null

union all

select
  s.source_row,
  'codigo' as columna,
  'El codigo esta duplicado dentro del archivo CSV.' as error_detalle
from src s
inner join duplicados d
  on btrim(s.codigo) = d.codigo

union all

select
  s.source_row,
  'sociedad_id' as columna,
  'sociedad_id no tiene un formato UUID valido.' as error_detalle
from src s
where nullif(btrim(s.sociedad_id), '') is not null
  and btrim(s.sociedad_id) !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'

union all

select
  s.source_row,
  'activo' as columna,
  'activo contiene un valor invalido. Valores permitidos: true, false, 1, 0, si, no, yes, no.' as error_detalle
from src s
where nullif(btrim(s.activo), '') is not null
  and lower(btrim(s.activo)) not in ('true', 'false', '1', '0', 'si', 'sí', 'no', 'yes', 'y', 'n');
