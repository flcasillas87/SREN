-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 01_create_staging_cat_centros_gestores.sql
-- Descripción: Tabla de staging para carga inicial de CSV
-- =========================================================
create table if not exists staging.cat_centros_gestores (
  id_stg_centro_gestor bigserial primary key,
  batch_id uuid not null default gen_random_uuid(),
  codigo text,
  nombre text,
  sociedad_id text,
  activo text,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);

