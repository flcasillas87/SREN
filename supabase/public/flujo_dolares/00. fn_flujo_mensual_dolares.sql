CREATE OR REPLACE PROCEDURE datos_maestros.sp_generar_estimacion_transporte(p_anio int)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Limpieza de proyecciones anteriores para evitar duplicados
    DELETE FROM datos_maestros.flujo_mensual_transporte 
    WHERE EXTRACT(YEAR FROM periodo_mes) = p_anio 
      AND tipo_registro = 'Estimado';

    -- 2. Cálculo masivo de los 12 meses
    INSERT INTO datos_maestros.flujo_mensual_transporte (
        id_contrato, 
        periodo_mes, 
        tipo_registro, 
        capacidad_snapshot, 
        tarifa_snapshot, 
        monto_usd
    )
    SELECT 
        c.id_contrato,
        make_date(p_anio, m.mes, 1) as periodo_mes,
        'Estimado',
        c.capacidad_reservada_diaria,
        c.tarifa_reservacion_usd,
        -- Fórmula: Reserva * Tarifa * 30.41 (Promedio días mes)
        (c.capacidad_reservada_diaria * c.tarifa_reservacion_usd * 30.41) as monto_usd
    FROM datos_maestros.cat_contratos_transporte c
    CROSS JOIN (SELECT generate_series(1,12) as mes) m 
    WHERE c.activo = true 
      AND (c.fecha_fin IS NULL OR c.fecha_fin >= make_date(p_anio, m.mes, 1));

    COMMIT;
END;
$$;