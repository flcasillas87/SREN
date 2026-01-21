-- =========================================================
-- Esquema: staging
-- Tabla: Catálogo de Contratos de Transporte - Staging
-- =========================================================
DROP TABLE IF EXISTS staging.stg_contratos_transporte;

CREATE TABLE staging.stg_contratos_transporte (
    razon_social text,
    nombre_contrato text,
    moneda_tarifa text,
    unidad_medida text,
    plurianual text,
    sistema_transporte text,
    capacidad_reservada_diaria text, 
    tarifa_reservacion text,
    tarifa_uso text,
    fecha_inicio text,
    fecha_fin text
);