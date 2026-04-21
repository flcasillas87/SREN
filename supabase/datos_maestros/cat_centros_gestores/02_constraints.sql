-- =========================================================
-- Esquema: datos_maestros
-- Tabla: Catálogo de Centros Gestores
-- Archivo: 02_constraints_cat_centros_gestores.sql
-- =========================================================

alter table datos_maestros.cat_centros_gestores
  drop constraint if exists cat_centros_gestores_codigo_key,
  drop constraint if exists cat_centros_gestores_codigo_chk,
  drop constraint if exists cat_centros_gestores_nombre_chk;

alter table datos_maestros.cat_centros_gestores
  add constraint cat_centros_gestores_codigo_key
  unique (codigo);

alter table datos_maestros.cat_centros_gestores
  add constraint cat_centros_gestores_codigo_chk
  check (btrim(codigo) <> '');

alter table datos_maestros.cat_centros_gestores
  add constraint cat_centros_gestores_nombre_chk
  check (btrim(nombre) <> '');

