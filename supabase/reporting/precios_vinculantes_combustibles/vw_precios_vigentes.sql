-- =============================================================================
-- vw_precios_vigentes.sql
-- =============================================================================
-- Propósito:
--   Muestra el precio vinculante más reciente por combinación de
--   central + combustible + unidad de medida, filtrando solo registros activos.
--   Vista principal para reportes ejecutivos y consultas de precio actual.
--
-- Uso típico:
--   SELECT * FROM public.vw_precios_vigentes
--   WHERE central = 'CTG Huinalá';
-- =============================================================================
create or replace view reporting.vw_precios_vigentes as
with precio_rankeado as (
    select
        pvc.id_precio_vinculante_combustible,
        pvc.fecha,
        pvc.id_central_generacion,
        pvc.id_combustible,
        pvc.id_unidad_medida,
        pvc.precio_vinculante_combustibles      as precio,
        pvc.fuente,
        pvc.observaciones,
        pvc.archivo_origen,
        pvc.fecha_carga,
        pvc.created_at                          as fecha_registro,
        -- Numerar filas: rn=1 es el registro más reciente por combinación
        row_number() over (
            partition by pvc.id_central_generacion,
                         pvc.id_combustible,
                         pvc.id_unidad_medida
            order by pvc.fecha desc
        ) as rn
    from public.precios_vinculantes_combustibles pvc
    where pvc.es_activo = true
)
select
    pr.id_precio_vinculante_combustible,
    pr.fecha,
    cg.nombre_central                           as central,
    c.nombre_combustible                        as combustible,
    um.descripcion                              as unidad_medida,
    pr.precio,
    pr.fuente,
    pr.observaciones,
    pr.archivo_origen,
    pr.fecha_carga,
    pr.fecha_registro
from precio_rankeado pr
inner join datos_maestros.cat_centrales_generacion  cg  on cg.id_central_generacion = pr.id_central_generacion
inner join datos_maestros.cat_combustibles           c  on c.id_combustible          = pr.id_combustible
inner join datos_maestros.cat_unidades_medida       um  on um.id_unidad_medida       = pr.id_unidad_medida
where pr.rn = 1;