-- =========================================================
-- Esquema: public
-- Tabla: precios_vinculantes_combustibles
-- Archivo: 06_seeds.sql
-- =========================================================

-- Semillas de datos no incluidas por dependencia de tablas maestras.
-- Ajustar `id_combustible`, `id_unidad_medida` y `id_central_generacion` a UUID según los catálogos existentes.

insert into public.precios_vinculantes_combustibles (
    fecha,
    id_combustible,
    id_unidad_medida,
    id_central_generacion,
    precio_vinculante_combustibles,
    fuente,
    observaciones
) values (
    '2026-06-04',
    1,
    1,
    1,
    1234.5678,
    'Prueba interna',
    'Registro de prueba para módulo de precios vinculantes.'
);

