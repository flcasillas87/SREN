-- =========================================================
-- Índices
-- =========================================================
create index if not exists idx_cat_centros_gestores_activo on datos_maestros.cat_centros_gestores (activo)
where activo = true;
create index if not exists idx_cat_centros_gestores_sociedad on datos_maestros.cat_centros_gestores (sociedad_id);