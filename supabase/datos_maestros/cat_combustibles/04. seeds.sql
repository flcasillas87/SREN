-- Limpiar la tabla antes de insertar (Opcional, ten cuidado)
-- TRUNCATE "public"."cat_combustibles" RESTART IDENTITY CASCADE;
-- Insertar datos de catálogo
INSERT INTO "public"."cat_combustibles" ("nombre", "descripcion", "tipo", "es_activo")
VALUES (
        'Gasolina Regular',
        'Combustible de 100 octanos',
        'Fósil',
        true
    ),
    (
        'Gasolina Premium',
        'Combustible de 91 octanos',
        'Fósil',
        true
    ),
    (
        'Diesel',
        'Combustible para carga pesada',
        'Fósil',
        true
    ),
    (
        'Biodiesel',
        'Combustible derivado de aceites vegetales',
        'Renovable',
        true
    ),
    (
        'Etanol',
        'Biocombustible a base de alcohol',
        'Renovable',
        false
    ) ON CONFLICT ("nombre") DO NOTHING;
-- El "ON CONFLICT" evita errores si el nombre ya existe