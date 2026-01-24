CREATE OR REPLACE FUNCTION datos_maestros.seed_cat_combustibles() RETURNS void AS $$ BEGIN
INSERT INTO datos_maestros.cat_combustibles (
        nombre_combustible,
        codigo_corto,
        tipo,
        descripcion,
        es_activo
    )
VALUES (
        'Gas Natural',
        'GN',
        'Fósil',
        'Gas natural comprimido',
        true
    ),
    (
        'Diesel',
        'DSL',
        'Fósil',
        'Combustible diesel de alta calidad',
        true
    ),
    (
        'Fuel Oil',
        'FO',
        'Fósil',
        'Combustible para calderas y generadores',
        true
    ),
    (
        'Carbon',
        'CBO',
        'Fósil',
        'Carbón mineral para procesos industriales',
        true
    ) ON CONFLICT (nombre_combustible) DO
UPDATE
SET codigo_corto = EXCLUDED.codigo_corto,
    tipo = EXCLUDED.tipo,
    descripcion = EXCLUDED.descripcion,
    es_activo = EXCLUDED.es_activo,
    updated_at = (now() AT TIME ZONE 'America/Monterrey');
-- Mantenemos trazabilidad
RAISE NOTICE 'Semillas de cat_combustibles cargadas correctamente.';
END;
$$ LANGUAGE plpgsql;
-- Ejecución
SELECT datos_maestros.seed_cat_combustibles();