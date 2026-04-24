-- Vista movida a reporting.v_trabajadores_detalle
CREATE OR REPLACE VIEW datos_maestros.v_trabajadores_detalle AS
SELECT * FROM reporting.v_trabajadores_detalle;
