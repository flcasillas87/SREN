-- =========================================================
-- Constraints
-- =========================================================
-- cat_centros_gestores/02_constraints.sql
alter table datos_maestros.cat_centros_gestores
add constraint fk_centro_sociedad foreign key (sociedad_id) references datos_maestros.cat_sociedades(id_sociedad);