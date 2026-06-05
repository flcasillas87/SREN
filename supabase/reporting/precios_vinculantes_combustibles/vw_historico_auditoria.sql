-- =============================================================================
-- vw_historico_auditoria.sql
-- =============================================================================
-- Propósito:
--   Bitácora completa de cambios de precio vinculante. Une la tabla de
--   auditoría con los datos maestros para obtener nombres legibles.
--   Incluye variación absoluta y porcentual por cambio.
--
-- Uso típico:
--   SELECT * FROM public.vw_historico_auditoria
--   WHERE central = 'CC Huinalá II'
--   ORDER BY fecha_cambio DESC;
-- =============================================================================
create or replace view reporting.vw_historico_auditoria as
select
    a.id_audit_precio_vinculante_combustible        as id_auditoria,
    a.fecha_cambio,
    cg.nombre_central                               as central,
    c.nombre_combustible                            as combustible,
    um.descripcion                                  as unidad_medida,
    pvc.fecha                                       as fecha_precio,
    a.precio_anterior,
    a.precio_nuevo,
    -- Variación absoluta: diferencia directa entre precio nuevo y anterior
    round(a.precio_nuevo - a.precio_anterior, 4)    as variacion_absoluta,
    -- Variación porcentual: protegida contra división entre cero o NULL
    case
        when coalesce(a.precio_anterior, 0) = 0 then null
        else round(
            ((a.precio_nuevo - a.precio_anterior) / a.precio_anterior) * 100,
            2
        )
    end                                             as variacion_pct,
    a.usuario_cambio,
    a.observaciones,
    a.archivo_origen
from public.audit_precios_vinculantes_combustibles a
inner join public.precios_vinculantes_combustibles pvc
        on pvc.id_precio_vinculante_combustible = a.id_precio_vinculante_combustible
inner join datos_maestros.cat_centrales_generacion  cg  on cg.id_central_generacion = pvc.id_central_generacion
inner join datos_maestros.cat_combustibles           c  on c.id_combustible          = pvc.id_combustible
inner join datos_maestros.cat_unidades_medida       um  on um.id_unidad_medida       = pvc.id_unidad_medida;