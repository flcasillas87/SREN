-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_centros_gestores
-- Archivo: 01_merge_to_datos_maestros.sql
-- Descripción: Inserta o actualiza datos desde staging
-- =========================================================

insert into datos_maestros.cat_centros_gestores (
  codigo,
  nombre,
  sociedad_id,
  activo,
  created_by,
  updated_by
)
select
  r.codigo,
  r.nombre,
  r.sociedad_id,
  r.activo,
  'csv_import',
  'csv_import'
from staging.cat_centros_gestores_ready r
on conflict (codigo) do update
set
  nombre = excluded.nombre,
  sociedad_id = excluded.sociedad_id,
  activo = excluded.activo,
  updated_at = now(),
  updated_by = 'csv_import';
