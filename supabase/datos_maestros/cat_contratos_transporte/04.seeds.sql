-- =========================================================
-- SEED: Carga Inicial de Contratos de Transporte
-- Nota: Los UUIDs se recuperan dinámicamente de cat_proveedores
-- =========================================================
-- =========================================================
-- SEED: Carga Inicial de Contratos de Transporte
-- Nota: Los UUIDs se recuperan dinámicamente de cat_proveedores
-- =========================================================

INSERT INTO datos_maestros.cat_contratos_transporte (
    id_proveedor,
    moneda_tarifa,
    id_unidad_medida,
    id_plurianual,
    nombre_contrato,
    sistema_transporte,
    capacidad_reservada_diaria,
    tarifa_reservacion,
    tarifa_uso,
    fecha_inicio,
    fecha_fin
)
VALUES 
(
    (SELECT id_proveedor FROM datos_maestros.cat_proveedores WHERE razon_social = 'CENTRO NACIONAL DE CONTROL DEL GAS NATURAL'),
    'MXN',
    1, -- Asumiendo 1 = GJ o MMBtu en tu cat_unidades_medida
    'PLU-SISTRANGAS-2024-2030',
    'Base Sistrangas Principal',
    'SISTRANGAS',
    5000.00,
    0.345678, -- Tarifa en MXN
    0.012000,
    '2024-01-01',
    '2030-12-31'
)

ON CONFLICT (nombre_contrato) DO UPDATE SET
    capacidad_reservada_diaria = EXCLUDED.capacidad_reservada_diaria,
    tarifa_reservacion = EXCLUDED.tarifa_reservacion,
    updated_at = NOW();