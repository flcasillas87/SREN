-- =========================================================
-- PROCESO: Carga de Precios Vinculantes
-- Origen  : staging.stg_precios_vinculantes_combustibles
-- Destino : datos_maestros.precios_vinculantes
-- =========================================================
drop table if exists transform.prep_precios_vinculantes_combustibles cascade;
create table transform.prep_precios_vinculantes_combustibles as
select t.batch_id,
    c.id_central_generacion,
    cb.id_combustible,
    u.id_unidad_medida,
    t.fecha,
    t.precio_vinculante_combustibles,
    t.fuente,
    t.observaciones
from transform.trf_precios_vinculantes_combustibles t
    join datos_maestros.cat_centrales_generacion c on t.nombre_central = regexp_replace(upper(trim(c.nombre_central)), '\s+', ' ', 'g')
    join datos_maestros.cat_combustibles cb on t.nombre_combustible = upper(trim(cb.nombre_combustible))
    join datos_maestros.cat_unidades_medida u on t.nombre_unidad_medida = upper(trim(u.codigo))
where t.es_valido = true;