-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 01_create_staging_cat_centros_gestores.sql
-- Descripción: Tabla de staging para carga inicial de CSV
-- =========================================================
create table if not exists staging.cat_centros_gestores (
  codigo text,
  nombre text,
  sociedad_id text,
  activo text
);

