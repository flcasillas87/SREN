-- =============================================================================
-- PROCESO ETL: Carga desde Staging a Datos Maestros
-- =============================================================================

INSERT INTO datos_maestros.cat_contratos_transporte (
    id_proveedor,
    nombre_contrato,
    moneda_tarifa,
    id_unidad_medida,
    plurianual,
    sistema_transporte,
    capacidad_reservada_diaria,
    tarifa_reservacion,
    tarifa_uso,
    fecha_inicio,
    fecha_fin
)
SELECT 
    p.id_proveedor,     
    t.nombre_contrato,
    COALESCE(NULLIF(TRIM(t.moneda_tarifa), ''), 'MXN'),
    u.id_unidad_medida, 
    t.plurianual,       
    t.sistema_transporte,
    NULLIF(t.capacidad_reservada_diaria, '')::numeric,
    NULLIF(t.tarifa_reservacion, '')::numeric,
    NULLIF(t.tarifa_uso, '')::numeric,
    NULLIF(t.fecha_inicio, '')::date,
    NULLIF(t.fecha_fin, '')::date
FROM staging.stg_contratos_transporte t
JOIN datos_maestros.cat_proveedores p 
    ON UPPER(TRIM(t.razon_social)) = UPPER(TRIM(p.razon_social))
LEFT JOIN datos_maestros.cat_unidades_medida u 
    ON UPPER(TRIM(t.unidad_medida)) = UPPER(TRIM(u.codigo)) 


ON CONFLICT (nombre_contrato) DO UPDATE SET
    id_proveedor = EXCLUDED.id_proveedor,
    id_unidad_medida = EXCLUDED.id_unidad_medida,
    plurianual = EXCLUDED.plurianual,
    capacidad_reservada_diaria = EXCLUDED.capacidad_reservada_diaria,
    tarifa_reservacion = EXCLUDED.tarifa_reservacion,
    tarifa_uso = EXCLUDED.tarifa_uso,
    fecha_inicio = EXCLUDED.fecha_inicio,
    fecha_fin = EXCLUDED.fecha_fin,
    moneda_tarifa = EXCLUDED.moneda_tarifa,
    updated_at = NOW();