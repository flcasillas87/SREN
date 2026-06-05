-- =============================================================================
-- vw_comparativo_mensual.sql
-- =============================================================================
-- Propósito:
--   Precio promedio mensual por central + combustible + unidad, comparado
--   contra el mes inmediato anterior. Útil para análisis de tendencia y
--   reportes de variación de costos de combustible.
--
-- Nota técnica:
--   Los LAG() se calculan una sola vez en el CTE `con_lag` para evitar
--   repetir la window function en cada columna derivada, lo que mejora
--   legibilidad y reduce riesgo de inconsistencias.
--
-- Uso típico:
--   SELECT * FROM public.vw_comparativo_mensual
--   WHERE anio = 2025 AND mes = 9
--   ORDER BY central, combustible;
-- =============================================================================
create or replace view reporting.vw_comparativo_mensual as
with precios_mensuales as (
    -- Paso 1: agregar precios a nivel mensual por combinación
    select
        date_trunc('month', pvc.fecha)::date              as periodo,
        extract(year  from pvc.fecha)::int                as anio,
        extract(month from pvc.fecha)::int                as mes,
        pvc.id_central_generacion,
        pvc.id_combustible,
        pvc.id_unidad_medida,
        round(avg(pvc.precio_vinculante_combustibles), 4) as precio_mes
    from public.precios_vinculantes_combustibles pvc
    where pvc.es_activo = true
    group by 1, 2, 3, 4, 5, 6
),
con_lag as (
    -- Paso 2: calcular LAG una sola vez para reutilizar en columnas derivadas
    select
        pm.*,
        lag(pm.precio_mes) over (
            partition by pm.id_central_generacion,
                         pm.id_combustible,
                         pm.id_unidad_medida
            order by pm.periodo
        ) as precio_mes_anterior
    from precios_mensuales pm
)
select
    cl.anio,
    cl.mes,
    cl.periodo,
    cg.nombre_central                                   as central,
    c.nombre_combustible                                as combustible,
    um.descripcion                                      as unidad_medida,
    cl.precio_mes                                       as precio_mes_actual,
    cl.precio_mes_anterior,
    -- Variación absoluta calculada desde el LAG ya materializado en el CTE
    round(cl.precio_mes - cl.precio_mes_anterior, 4)    as variacion_absoluta,
    -- Variación porcentual protegida contra división entre cero o NULL
    case
        when coalesce(cl.precio_mes_anterior, 0) = 0 then null
        else round(
            ((cl.precio_mes - cl.precio_mes_anterior) / cl.precio_mes_anterior) * 100,
            2
        )
    end                                                 as variacion_pct
from con_lag cl
inner join datos_maestros.cat_centrales_generacion  cg  on cg.id_central_generacion = cl.id_central_generacion
inner join datos_maestros.cat_combustibles           c  on c.id_combustible          = cl.id_combustible
inner join datos_maestros.cat_unidades_medida       um  on um.id_unidad_medida       = cl.id_unidad_medida;