-- =========================================================
-- Esquema: staging
-- Tabla: stg_cat_centros_gestores_ready
-- Archivo: 03_prepare_merge.sql
-- Descripción: Prepara registros validos para merge
-- =========================================================

drop table if exists staging.stg_cat_centros_gestores_ready;

create table staging.stg_cat_centros_gestores_ready as
select
  n.source_row,
  n.codigo,
  n.nombre,
  case
    when n.sociedad_id_raw is null then null
  else n.sociedad_id_raw::uuid
  end as sociedad_id,
  coalesce(n.activo, true) as activo,
  n.observaciones as observaciones,
  n.archivo_origen as archivo_origen,
  n.fecha_carga as fecha_carga,
  n.usuario_carga as usuario_carga
from staging.stg_cat_centros_gestores_normalized n
where not exists (
  select 1
  from staging.vw_cat_centros_gestores_validation_errors e
  where e.source_row = n.source_row
);
