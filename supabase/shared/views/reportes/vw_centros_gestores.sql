create or replace view reporting.vw_centros_gestores as
select
  c.id_centro_gestor,
  c.codigo,
  c.nombre,
  s.codigo as sociedad_codigo,
  s.nombre as sociedad_nombre,
  c.activo
from datos_maestros.cat_centros_gestores c
left join datos_maestros.cat_sociedades s
  on c.sociedad_id = s.id_sociedad;