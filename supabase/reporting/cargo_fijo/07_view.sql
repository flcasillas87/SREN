create or replace view reporting.vw_cargo_fijo as
select
    cf.id_cargo_fijo,
    cf.id_factura,
    cf.reserva_capacidad,
    cf.reserva_diaria,
    cf.dias_periodo,
    cf.tarifa,
    cf.moneda_tarifa,
    mon.descripcion as moneda_tarifa_descripcion,
    cf.id_unidad_medida,
    um.codigo as unidad_medida_codigo,
    um.descripcion as unidad_medida_descripcion,
    cf.importe_calculado,
    cf.conciliado,
    cf.diferencia_importe,
    cf.notas,
    cf.created_at,
    cf.updated_at
from public.cargo_fijo cf
left join datos_maestros.cat_monedas mon
    on cf.moneda_tarifa = mon.codigo
left join datos_maestros.cat_unidades_medida um
    on cf.id_unidad_medida = um.id_unidad_medida;

comment on view reporting.vw_cargo_fijo
    is 'Vista de cargo fijo con descripcion de moneda y unidad de medida para consulta operativa y Power BI.';

