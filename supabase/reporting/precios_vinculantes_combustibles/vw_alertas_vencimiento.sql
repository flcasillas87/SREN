-- =============================================================================
-- vw_alertas_vencimiento.sql
-- =============================================================================
-- Propósito:
--   Identifica registros activos que aún están dentro de la ventana editable
--   de 7 días pero están próximos a volverse inmutables por la función
--   check_fecha_vinculante(). Permite corregir errores antes del bloqueo.
--
-- Semáforo de urgencia:
--   CRÍTICO  → 0 o 1 día restante  (vence hoy o mañana)
--   URGENTE  → 2 a 4 días restantes
--   VIGENTE  → 5 a 7 días restantes
--
-- Uso típico:
--   SELECT * FROM public.vw_alertas_vencimiento
--   WHERE urgencia = 'CRÍTICO'
--   ORDER BY dias_restantes;
-- =============================================================================
create or replace view reporting.vw_alertas_vencimiento as
with registros_editables as (
    -- Calcular días restantes una sola vez para reutilizar en semáforo
    select
        pvc.id_precio_vinculante_combustible,
        pvc.fecha,
        pvc.id_central_generacion,
        pvc.id_combustible,
        pvc.id_unidad_medida,
        pvc.precio_vinculante_combustibles      as precio,
        pvc.fuente,
        pvc.observaciones,
        pvc.usuario_carga,
        -- Días que faltan para que el registro cumpla 7 días
        (pvc.fecha + interval '7 days' - current_date)::int as dias_restantes
    from public.precios_vinculantes_combustibles pvc
    where pvc.es_activo = true
      and pvc.fecha >= current_date - interval '7 days'
)
select
    re.id_precio_vinculante_combustible,
    re.fecha,
    cg.nombre_central                           as central,
    c.nombre_combustible                        as combustible,
    um.descripcion                              as unidad_medida,
    re.precio,
    re.dias_restantes,
    -- Clasificación de urgencia para filtrado rápido en Excel
    case
        when re.dias_restantes <= 1 then 'CRÍTICO'
        when re.dias_restantes <= 4 then 'URGENTE'
        else 'VIGENTE'
    end                                         as urgencia,
    re.fuente,
    re.observaciones,
    re.usuario_carga
from registros_editables re
inner join datos_maestros.cat_centrales_generacion  cg  on cg.id_central_generacion = re.id_central_generacion
inner join datos_maestros.cat_combustibles           c  on c.id_combustible          = re.id_combustible
inner join datos_maestros.cat_unidades_medida       um  on um.id_unidad_medida       = re.id_unidad_medida
order by re.dias_restantes asc;