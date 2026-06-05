-- =============================================================================
-- Vista: detalle de precios vinculantes con costo en MBTU
-- =============================================================================
create or replace view reporting.vw_precios_vinculantes_combustibles as
select p.fecha,
    c.nombre_combustible as combustible,
    cg.nombre_central as central_generacion,
    p.precio_vinculante_combustibles as precio_nominal,
    u.codigo as unidad,
    round(
        p.precio_vinculante_combustibles * u.factor_conversion_mbtu,
        4
    ) as costo_mbtu,
    p.fuente,
    p.observaciones,
    p.id_central_generacion
from public.precios_vinculantes_combustibles p
    join datos_maestros.cat_combustibles c on p.id_combustible = c.id_combustible
    join datos_maestros.cat_unidades_medida u on p.id_unidad_medida = u.id_unidad_medida
    join datos_maestros.cat_centrales_generacion cg on p.id_central_generacion = cg.id_central_generacion
where p.es_activo = true;