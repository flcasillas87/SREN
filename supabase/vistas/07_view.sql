-- =========================================================
-- Vista: reporte de precios vinculantes por central, año y mes
-- =========================================================
create or replace view public.vw_reporte_precios_por_central_ano_mes as
select
    cg.id_central_generacion,
    cg.nombre_central,
    extract(year from p.fecha)::int as ano,
    extract(month from p.fecha)::int as mes,
    case extract(month from p.fecha)::int
        when 1 then 'Enero'
        when 2 then 'Febrero'
        when 3 then 'Marzo'
        when 4 then 'Abril'
        when 5 then 'Mayo'
        when 6 then 'Junio'
        when 7 then 'Julio'
        when 8 then 'Agosto'
        when 9 then 'Septiembre'
        when 10 then 'Octubre'
        when 11 then 'Noviembre'
        when 12 then 'Diciembre'
    end as mes_nombre,
    count(*) as total_registros,
    round(avg(p.precio_vinculante_combustibles)::numeric, 4) as precio_promedio,
    round(min(p.precio_vinculante_combustibles)::numeric, 4) as precio_minimo,
    round(max(p.precio_vinculante_combustibles)::numeric, 4) as precio_maximo,
    round(sum(p.precio_vinculante_combustibles)::numeric, 4) as precio_total,
    round(avg(p.precio_vinculante_combustibles * u.factor_conversion_mbtu), 4) as costo_mbtu_promedio
from public.precios_vinculantes_combustibles p
join datos_maestros.cat_centrales_generacion cg
  on p.id_central_generacion = cg.id_central_generacion
join datos_maestros.cat_unidades_medida u
  on p.id_unidad_medida = u.id_unidad_medida
where p.es_activo = true
group by
    cg.id_central_generacion,
    cg.nombre_central,
    extract(year from p.fecha),
    extract(month from p.fecha),
    to_char(p.fecha, 'TMMonth');
