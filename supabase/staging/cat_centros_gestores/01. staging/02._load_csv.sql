-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 02_load_csv_cat_centros_gestores.sql
-- Descripción: Carga de archivo CSV a tabla de staging
-- =========================================================

drop table if exists staging.cat_centros_gestores_raw;

create table staging.cat_centros_gestores_raw (
  id_centro_gestor text,
  codigo text,
  nombre text,
  sociedad_id text,
  activo text,
  created_at text,
  updated_at text,
  created_by text,
  updated_by text
);

\copy staging.cat_centros_gestores_raw (
  id_centro_gestor,
  codigo,
  nombre,
  sociedad_id,
  activo,
  created_at,
  updated_at,
  created_by,
  updated_by
)
from 'C:/ruta/cat_centros_gestores_rows.csv'
with (
  format csv,
  header true,
  encoding 'UTF8'
);

truncate table staging.cat_centros_gestores;

insert into staging.cat_centros_gestores (
  codigo,
  nombre,
  sociedad_id,
  activo,
  observaciones,
  archivo_origen
)
select
  codigo,
  nombre,
  sociedad_id,
  activo,
  null,
  'cat_centros_gestores_rows.csv'
from staging.cat_centros_gestores_raw;

drop table if exists staging.cat_centros_gestores_raw;

call etl.pr_load_cat_centros_gestores();
