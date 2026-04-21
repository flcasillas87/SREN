-- =========================================================
-- Archivo: 03_indexes_cat_centros_gestores.sql
-- =========================================================

create index if not exists idx_cat_centros_gestores_sociedad_id
  on datos_maestros.cat_centros_gestores (sociedad_id);

create index if not exists idx_cat_centros_gestores_activo
  on datos_maestros.cat_centros_gestores (activo);

create index if not exists idx_cat_centros_gestores_codigo
  on datos_maestros.cat_centros_gestores (codigo);
