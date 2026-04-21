CREATE OR REPLACE VIEW datos_maestros.v_trabajadores_detalle AS
SELECT 
    *,
    EXTRACT(YEAR FROM AGE(NOW(), fecha_ingreso)) AS antiguedad_real,
    (nombre || ' ' || apellido_paterno || ' ' || COALESCE(apellido_materno, '')) AS nombre_completo
FROM datos_maestros.cat_trabajadores;