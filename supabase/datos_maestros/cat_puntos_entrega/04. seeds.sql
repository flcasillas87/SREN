-- =========================================================
-- Seed Data: Catálogo de Puntos de Entrega (Nodos)
-- =========================================================
INSERT INTO datos_maestros.cat_puntos_entrega (nombre_punto, codigo, sistema_transporte, capacidad_tecnica_mmscfd)
VALUES -- Nodos de Inyección / Importación
    ('Cactus', 'CACT-01', 'Sistrangas', NULL),
    ('Nuevo Laredo', 'NLA-01', 'Sistrangas', NULL),
    ('Reynosa', 'REY-01', 'Sistrangas', NULL),
    ('Altamira', 'ALT-01', 'Sistrangas', NULL),
    ('Aguascalientes', 'AGU-01', 'Sistrangas', NULL),   
    -- Nodos de Entrega Comunes
    ('Zempoala', 'ZEMP-02', 'Sistrangas', NULL),
    ('Monclova', 'MON-05', 'Sistrangas', NULL),
    ('Venta de Carpio', 'VDC-01', 'Sistrangas', NULL),
    ('Ramones', 'RAM-01', 'Sistrangas', NULL),
    -- Otros Sistemas
    ('Waha', 'WAH-01', 'Waha-Presidio', NULL),
    ('El Encino', 'ENC-01', 'Tarahumara Pipelines', NULL),
    (
        'Topolobampo',
        'TOP-01',
        'Topolobampo',
        NULL
    )