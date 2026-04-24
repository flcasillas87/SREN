create or replace view reporting.v_variacion_transporte as
select 
    e.periodo_mes,
    c.nombre_contrato,
    e.monto_usd as monto_estimado,
    r.monto_usd as monto_real,
    (coalesce(r.monto_usd, 0) - e.monto_usd) as desviacion_usd
from datos_maestros.flujo_mensual_transporte e
left join datos_maestros.flujo_mensual_transporte r 
    on e.id_contrato = r.id_contrato 
    and e.periodo_mes = r.periodo_mes 
    and r.tipo_registro = 'Real'
join datos_maestros.cat_contratos_transporte c on e.id_contrato = c.id_contrato
where e.tipo_registro = 'Estimado';

create or replace view reporting.v_flujo_dolares_por_proveedor as
select 
    f.periodo_mes,
    p.nombre_comercial as proveedor,
    sum(f.monto_usd) as total_usd,
    sum(f.monto_moneda_original) as total_original,
    mon.codigo as moneda_pago
from datos_maestros.flujo_mensual_transporte f
join datos_maestros.cat_contratos_transporte c on f.id_contrato = c.id_contrato
join datos_maestros.cat_proveedores p on c.id_proveedor = p.id_proveedor
join datos_maestros.cat_monedas mon on f.id_moneda_original = mon.id_moneda
where f.tipo_registro = 'Estimado'
group by f.periodo_mes, p.nombre_comercial, mon.codigo;

