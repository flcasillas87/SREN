-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 03_indexes.sql
-- =========================================================

create index if not exists idx_cat_monedas_descripcion
    on datos_maestros.cat_monedas (descripcion);
