-- =========================================================
-- Seed Data: Trabajadores Base
-- =========================================================

INSERT INTO datos_maestros.cat_trabajadores 
    (rfc, curp, rpe, nombre, apellido_paterno, apellido_materno, correo_electronico, fecha_ingreso)
VALUES 
    ('GOPA850101HDF', 'GOPA850101HDFLNR01', 'RPE-001', 'Alberto', 'González', 'Pérez', 'alberto.gonzalez@empresa.com', '2020-01-15'),
    ('MARL900512MDF', 'MARL900512MDFRSS02', 'RPE-002', 'Lucía', 'Martínez', 'Rodríguez', 'lucia.martinez@empresa.com', '2021-03-10'),
    ('SAMA780820HDF', 'SAMA780820HDFGTT03', 'RPE-003', 'Antonio', 'Sánchez', 'Maya', 'antonio.sanchez@empresa.com', '2019-11-20')
ON CONFLICT (rfc) DO UPDATE SET
    correo_electronico = EXCLUDED.correo_electronico,
    updated_at = NOW();