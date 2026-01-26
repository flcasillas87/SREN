-- =========================================================
-- STAGING TABLE
-- Dominio : precios_vinculantes_combustibles
-- Uso     : Carga cruda desde CSV / Excel / API
-- =========================================================
drop table if exists staging.stg_precios_vinculantes_combustibles cascade;
create table staging.stg_precios_vinculantes_combustibles (
    batch_id uuid not null default gen_random_uuid(),
    fecha text,
    nombre_combustible text,
    nombre_unidad_medida text,
    nombre_central text,
    precio_vinculante_combustibles text,
    fuente text,
    observaciones text,
    archivo_origen text,
    fecha_carga timestamp default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid default auth.uid()
);