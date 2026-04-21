-- =========================================================
-- Esquema: facturacion (o datos_maestros)
-- Tabla: flujo_mensual_transporte
-- Propósito: Almacena el cálculo proyectado basado en Tarifas y Reservas.
-- =========================================================


CREATE TABLE IF NOT EXISTS public.estimacion_flujo_transporte (
    id_estimacion serial4 NOT NULL,
    id_contrato int4 NOT NULL,
    anio int4 NOT NULL,
    mes int4 NOT NULL,
    
    -- Parámetros de Cálculo (Input)
    capacidad_reservada_diaria numeric(18,4) NOT NULL, -- Ej: GJ/día o MMBtu/día
    tarifa_reservacion_unitaria numeric(18,6) NOT NULL, -- Tarifa por unidad de capacidad
    tarifa_uso_unitaria numeric(18,6) DEFAULT 0,       -- Tarifa por volumen transportado
    volumen_estimado_mensual numeric(18,4) DEFAULT 0,  -- Pronóstico de uso real
    
    -- Resultados del Cálculo (Output)
    costo_fijo_estimado_usd numeric(18,2) GENERATED ALWAYS AS (
        capacidad_reservada_diaria * tarifa_reservacion_unitaria * 30.41 -- Promedio días mes
    ) STORED,
    
    costo_variable_estimado_usd numeric(18,2) GENERATED ALWAYS AS (
        volumen_estimado_mensual * tarifa_uso_unitaria
    ) STORED,
    
    total_estimado_usd numeric(18,2) GENERATED ALWAYS AS (
        (capacidad_reservada_diaria * tarifa_reservacion_unitaria * 30.41) + 
        (volumen_estimado_mensual * tarifa_uso_unitaria)
    ) STORED,

    -- Auditoría y Control
    tipo_cambio_proyectado numeric(12,4), -- FX estimado para presupuesto
    created_at timestamp DEFAULT (now() AT TIME ZONE 'America/Monterrey'),
    
    CONSTRAINT pk_estimacion_flujo PRIMARY KEY (id_estimacion),
    CONSTRAINT uk_contrato_periodo UNIQUE (id_contrato, anio, mes)
);

