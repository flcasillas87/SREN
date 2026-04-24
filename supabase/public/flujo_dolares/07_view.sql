-- Vistas movidas a reporting.flujo_dolares/07_view.sql
CREATE OR REPLACE VIEW datos_maestros.v_variacion_transporte AS
SELECT * FROM reporting.v_variacion_transporte;

CREATE OR REPLACE VIEW datos_maestros.v_flujo_dolares_por_proveedor AS
SELECT * FROM reporting.v_flujo_dolares_por_proveedor;
