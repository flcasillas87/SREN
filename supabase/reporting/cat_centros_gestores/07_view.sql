create or replace view reporting.vw_cat_centros_gestores as
select
  cg.id_centro_gestor,
  cg.codigo,
  cg.nombre,
  cg.sociedad_id,
  cg.activo,
  cg.created_at,
  cg.updated_at,
  cg.created_by,
  cg.updated_by
from datos_maestros.cat_centros_gestores cg;

