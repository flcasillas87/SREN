-- =========================================================
-- ÍNDICES PARA REPORTES MENSUALES
-- =========================================================
CREATE INDEX idx_flujo_transporte_periodo ON datos_maestros.flujo_mensual_transporte (anio, mes);