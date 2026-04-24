-- COPY se ejecuta desde cliente / Supabase SQL Editor
drop table if exists staging.precios_vinculantes_combustibles_raw;

create table staging.precios_vinculantes_combustibles_raw (
    batch_id uuid,
    fecha text,
    nombre_combustible text,
    nombre_unidad_medida text,
    nombre_central text,
    precio_vinculante_combustibles text,
    fuente text,
    observaciones text,
    archivo_origen text,
    fecha_carga text,
    usuario_carga text
);

copy staging.precios_vinculantes_combustibles_raw (
    batch_id,
    fecha,
    nombre_combustible,
    nombre_unidad_medida,
    nombre_central,
    precio_vinculante_combustibles,
    fuente,
    observaciones,
    archivo_origen,
    fecha_carga
)
from '/data/precios_vinculantes_combustibles.csv'
csv header;

insert into staging.stg_precios_vinculantes_combustibles (
    fecha,
    nombre_combustible,
    nombre_unidad_medida,
    nombre_central,
    precio_vinculante_combustibles,
    fuente,
    observaciones,
    archivo_origen
)
select
    fecha,
    nombre_combustible,
    nombre_unidad_medida,
    nombre_central,
    precio_vinculante_combustibles,
    fuente,
    observaciones,
    archivo_origen
from staging.precios_vinculantes_combustibles_raw;

drop table if exists staging.precios_vinculantes_combustibles_raw;

call etl.pr_load_precios_vinculantes_combustibles();
