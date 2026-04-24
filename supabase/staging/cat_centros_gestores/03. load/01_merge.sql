-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_centros_gestores
-- Archivo: 01_merge_to_datos_maestros.sql
-- Descripción: Inserta o actualiza datos desde staging
-- =========================================================
call etl.pr_load_cat_centros_gestores();
