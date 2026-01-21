-- =========================================================
-- STAGING TABLE
-- Dominio : precios_vinculantes_combustibles
-- Uso     : Carga cruda desde CSV / Excel / API
-- =========================================================
drop table if exists staging.stg_precios_vinculantes_combustibles cascade;
create table staging.stg_precios_vinculantes_combustibles (
    fecha text,
    nombre_combustible text,
    nombre_unidad_medida text,
    nombre_central text,
    precio_vinculante_combustibles text,
    fuente text,
    observaciones text,
    -- Metadatos ETL
    archivo_origen text,
    fecha_carga timestamp default (now() at time zone 'America/Monterrey')
);