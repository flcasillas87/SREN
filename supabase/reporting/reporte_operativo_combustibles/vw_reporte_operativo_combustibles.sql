-- =============================================================================
-- 07_view.sql
-- Vista de reporting del reporte operativo por combustible y central.
-- =============================================================================

create or replace view reporting.vw_reporte_operativo_combustibles as
select
    ro.id_reporte_operativo,
    ro.fecha_entrega,
    cg.nombre_central as central_generacion,
    c.nombre_combustible as combustible,
    um.descripcion as unidad_medida,
    ro.volumen,
    ro.precio_unitario,
    ro.moneda,
    round(ro.volumen * coalesce(ro.precio_unitario, 0), 4) as importe,
    ro.fuente,
    ro.observaciones,
    ro.archivo_origen,
    ro.es_activo,
    ro.created_at,
    ro.updated_at,
    ro.fecha_carga,
    ro.usuario_carga
from public.reporte_operativo ro
inner join datos_maestros.cat_centrales_generacion cg
    on cg.id_central_generacion = ro.id_central_generacion
inner join datos_maestros.cat_combustibles c
    on c.id_combustible = ro.id_combustible
inner join datos_maestros.cat_unidades_medida um
    on um.id_unidad_medida = ro.id_unidad_medida;
