CREATE OR REPLACE FUNCTION datos_maestros.seed_cat_combustibles()
RETURNS void AS $$
BEGIN
    INSERT INTO datos_maestros.cat_combustibles (nombre, codigo_corto, tipo)
    VALUES 
        ('Gas Natural', 'GN', 'Fósil'),
        ('Diesel', 'DSL', 'Fósil'),
        ('Fuel Oil', 'FO', 'Fósil'),
        ('Carbon', 'CBO', 'Fósil')
    ON CONFLICT (nombre) DO UPDATE SET
        codigo_corto = EXCLUDED.codigo_corto,
        tipo = EXCLUDED.tipo,
        updated_at = (now() AT TIME ZONE 'America/Monterrey'); -- Mantenemos trazabilidad
    
    RAISE NOTICE 'Semillas de cat_combustibles cargadas correctamente.';
END;
$$ LANGUAGE plpgsql;

-- Ejecución
SELECT datos_maestros.seed_cat_combustibles();