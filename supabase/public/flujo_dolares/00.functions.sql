CREATE OR REPLACE PROCEDURE datos_maestros.sp_generar_estimacion_transporte(p_anio int)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Borramos estimaciones previas del año para evitar duplicados
    DELETE FROM datos_maestros.flujo_mensual_transporte 
    WHERE EXTRACT(YEAR FROM periodo_mes) = p_anio AND tipo_registro = 'Estimado';

    INSERT INTO datos_maestros.flujo_mensual_transporte (
        id_contrato, periodo_mes, tipo_registro, 
        capacidad_snapshot, tarifa_snapshot, monto_usd
    )
    SELECT 
        c.id_contrato,
        make_date(p_anio, m.mes, 1) as periodo_mes,
        'Estimado',
        c.capacidad_reservada_diaria,
        c.tarifa_reservacion_usd,
        -- Cálculo: Capacidad * Tarifa * Días del mes (aproximado 30.41)
        (c.capacidad_reservada_diaria * c.tarifa_reservacion_usd * 30.41) as monto_usd
    FROM datos_maestros.cat_contratos_transporte c
    CROSS JOIN (SELECT generate_series(1,12) as mes) m -- Genera los 12 meses
    WHERE c.activo = true;

    COMMIT;
END;
$$;

CREATE OR REPLACE PROCEDURE datos_maestros.sp_generar_estimacion_transporte(p_anio int)
-- (El código del procedimiento que inserta los 12 meses basado en cat_contratos_transporte)