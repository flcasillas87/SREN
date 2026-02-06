INSERT INTO datos_maestros.cat_lugares_servicio (nombre, pais) 
VALUES 
    ('MÉXICO', 'MX'),
    ('USA', 'USA')
ON CONFLICT (nombre) DO NOTHING;