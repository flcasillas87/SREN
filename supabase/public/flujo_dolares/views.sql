CREATE OR REPLACE VIEW datos_maestros.v_variacion_transporte AS
SELECT 
    e.periodo_mes,
    c.nombre_contrato,
    e.monto_usd AS monto_estimado,
    r.monto_usd AS monto_real,
    (COALESCE(r.monto_usd, 0) - e.monto_usd) AS desviacion_usd
FROM datos_maestros.flujo_mensual_transporte e
LEFT JOIN datos_maestros.flujo_mensual_transporte r 
    ON e.id_contrato = r.id_contrato 
    AND e.periodo_mes = r.periodo_mes 
    AND r.tipo_registro = 'Real'
JOIN datos_maestros.cat_contratos_transporte c ON e.id_contrato = c.id_contrato
WHERE e.tipo_registro = 'Estimado';

--- =========================================================
--- Vista: v_flujo_dolares_por_proveedor
CREATE OR REPLACE VIEW datos_maestros.v_flujo_dolares_por_proveedor AS
SELECT 
    f.periodo_mes,
    p.nombre_comercial AS proveedor,
    SUM(f.monto_usd) AS total_usd,
    SUM(f.monto_moneda_original) AS total_original,
    mon.codigo AS moneda_pago
FROM datos_maestros.flujo_mensual_transporte f
JOIN datos_maestros.cat_contratos_transporte c ON f.id_contrato = c.id_contrato
JOIN datos_maestros.cat_proveedores p ON c.id_proveedor = p.id_proveedor
JOIN datos_maestros.cat_monedas mon ON f.id_moneda_original = mon.id_moneda
WHERE f.tipo_registro = 'Estimado'
GROUP BY f.periodo_mes, p.nombre_comercial, mon.codigo;