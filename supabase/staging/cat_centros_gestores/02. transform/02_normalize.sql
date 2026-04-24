-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 02_normalize.sql
-- Descripción: Normaliza datos de staging
-- =========================================================

drop table if exists staging.cat_centros_gestores_normalized;

create table staging.cat_centros_gestores_normalized as
with src as (
  select
    row_number() over () as source_row,
    codigo,
    nombre,
    sociedad_id,
    activo,
    observaciones,
    archivo_origen,
    fecha_carga,
    usuario_carga
  from staging.cat_centros_gestores
)
select
  source_row,
  upper(btrim(codigo)) as codigo,
  btrim(nombre) as nombre,
  nullif(btrim(sociedad_id), '') as sociedad_id_raw,
  nullif(btrim(observaciones), '') as observaciones,
  nullif(btrim(archivo_origen), '') as archivo_origen,
  fecha_carga,
  usuario_carga,

  case
    when nullif(btrim(activo), '') is null then true
    when lower(btrim(activo)) in ('true', '1', 'si', 'sí', 'yes', 'y') then true
    when lower(btrim(activo)) in ('false', '0', 'no', 'n') then false
    else null
  end as activo
from src;
