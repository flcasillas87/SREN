insert into public.precios_vinculantes_combustibles (
    id_central_generacion,
    id_combustible,
    id_unidad_medida,
    fecha,
    precio_vinculante_combustibles,
    fuente
)
select
    p.id_central_generacion,
    p.id_combustible,
    p.id_unidad_medida,
    p.fecha,
    p.precio_vinculante_combustibles,
    p.fuente
from transform.prep_precios_vinculantes_combustibles p
where p.batch_id = '3f8c2a9e-4b12-4f8a-9c31-8d2a5e9c1234'  -- <-- aquí tu batch real
on conflict (fecha, id_combustible, id_central_generacion)
do update set
    precio_vinculante_combustibles = excluded.precio_vinculante_combustibles,
    updated_at = (now() at time zone 'America/Monterrey');


