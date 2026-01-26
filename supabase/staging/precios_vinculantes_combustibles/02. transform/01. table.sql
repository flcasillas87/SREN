-- =========================================================
-- 02_transform.sql
-- Crear tabla TRANSFORM
-- =========================================================
drop table if exists transform.trf_precios_vinculantes_combustibles cascade;
create table transform.trf_precios_vinculantes_combustibles (
    batch_id uuid not null,
    fecha date,
    nombre_combustible text,
    nombre_unidad_medida text,
    nombre_central text,
    precio_vinculante_combustibles numeric(15, 4),
    fuente text,
    observaciones text,
    es_valido boolean,
    error_motivo text,
    fecha_transform timestamp default (now() at time zone 'America/Monterrey')
);