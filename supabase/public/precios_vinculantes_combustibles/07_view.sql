-- =============================================================================
-- VISTA: v_dashboard_precios_vinculantes_combustibles
-- USO : Power BI – precios vinculantes de combustibles
-- =============================================================================

create or replace view public.v_dashboard_precios_vinculantes_combustibles as
select 
    p.fecha,
    c.nombre as combustible,
    p.precio_vinculante_combustibles as precio_nominal,
    u.codigo as unidad,
    round(
        
            p.precio_vinculante_combustibles * u.factor_conversion_mbtu,
            4
        ) as costo_mbtu,
     
    p.fuente,
    p.id_central_generacion as id_central_generacion
from public.precios_vinculantes_combustibles p
    join datos_maestros.cat_combustibles c on p.id_combustible = c.id_combustible
    join datos_maestros.cat_unidades_medida u on p.id_unidad_medida = u.id_unidad_medida
where p.es_activo = true;