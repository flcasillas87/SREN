-- =============================================================================
-- vw_reporte_mensual_por_central.sql
-- =============================================================================
-- Propósito:
--   Despliega todos los registros diarios por central para un mes determinado.
--   Un renglón por día con precio, fuente y metadatos de carga.
--   Diseñada para exportarse directamente a Excel como reporte mensual formal.
--
-- Uso típico:
--   SELECT * FROM public.vw_reporte_mensual_por_central
--   WHERE anio = 2025 AND mes = 9 AND central = 'CTG Huinalá'
--   ORDER BY fecha;
-- =============================================================================
create or replace view reporting.vw_reporte_mensual_por_central as
select
    extract(year  from pvc.fecha)::int          as anio,
    extract(month from pvc.fecha)::int          as mes,
    -- Nombre del mes para encabezados de reporte en Excel
    to_char(pvc.fecha, 'TMMonth')               as nombre_mes,
    extract(day from pvc.fecha)::int            as dia,
    pvc.fecha,
    cg.nombre_central                           as central,
    c.nombre_combustible                        as combustible,
    um.descripcion                              as unidad_medida,
    pvc.precio_vinculante_combustibles          as precio,
    pvc.fuente,
    pvc.observaciones,
    pvc.archivo_origen,
    pvc.fecha_carga,
    pvc.es_activo
from public.precios_vinculantes_combustibles pvc
inner join datos_maestros.cat_centrales_generacion  cg  on cg.id_central_generacion = pvc.id_central_generacion
inner join datos_maestros.cat_combustibles           c  on c.id_combustible          = pvc.id_combustible
inner join datos_maestros.cat_unidades_medida       um  on um.id_unidad_medida       = pvc.id_unidad_medida;