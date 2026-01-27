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
where p.batch_id = '8bb3cef1-dc85-4c9f-8f5a-740fd7556f22'  -- <-- aquí tu batch real
on conflict (fecha, id_combustible, id_central_generacion)
do update set
    precio_vinculante_combustibles = excluded.precio_vinculante_combustibles,
    updated_at = (now() at time zone 'America/Monterrey');