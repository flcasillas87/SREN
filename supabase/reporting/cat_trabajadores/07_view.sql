create or replace view reporting.v_trabajadores_detalle as
select
    *,
    extract(year from age(now(), fecha_ingreso)) as antiguedad_real,
    (nombre || ' ' || apellido_paterno || ' ' || coalesce(apellido_materno, '')) as nombre_completo
from datos_maestros.cat_trabajadores;

