-- =========================================================
-- Esquema: staging
-- Tabla: stg_precios_vinculantes_combustibles
-- Archivo: 02.transform_logic.sql
-- Descripcion: Normaliza datos de staging para preparar el merge
-- =========================================================

drop table if exists staging.precios_vinculantes_combustibles_normalized;

create table staging.precios_vinculantes_combustibles_normalized as
with src as (
    select
        id_stg_precio_vinculante_combustible as source_row,
        batch_id,
        fecha,
        nombre_combustible,
        nombre_unidad_medida,
        nombre_central,
        precio_vinculante_combustibles,
        fuente,
        observaciones,
        archivo_origen,
        fecha_carga,
        usuario_carga
    from staging.stg_precios_vinculantes_combustibles
)
select
    source_row,
    batch_id,
    case
        when nullif(btrim(fecha), '') is null then null
        when btrim(fecha) ~ '^\d{4}-\d{2}-\d{2}$' then to_date(btrim(fecha), 'YYYY-MM-DD')
        when btrim(fecha) ~ '^\d{2}/\d{2}/\d{4}$' then to_date(btrim(fecha), 'DD/MM/YYYY')
        else null
    end as fecha,
    upper(btrim(nombre_combustible)) as nombre_combustible,
    upper(btrim(nombre_unidad_medida)) as nombre_unidad_medida,
    regexp_replace(upper(btrim(nombre_central)), '\s+', ' ', 'g') as nombre_central,
    case
        when nullif(
            replace(replace(replace(btrim(precio_vinculante_combustibles), ',', ''), '$', ''), ' ', ''),
            ''
        ) ~ '^-?\d+(\.\d+)?$'
        then replace(replace(replace(btrim(precio_vinculante_combustibles), ',', ''), '$', ''), ' ', '')::numeric(15, 4)
        else null
    end as precio_vinculante_combustibles,
    coalesce(nullif(btrim(fuente), ''), 'csv_import') as fuente,
    nullif(btrim(observaciones), '') as observaciones,
    nullif(btrim(archivo_origen), '') as archivo_origen,
    fecha_carga,
    usuario_carga
from src;
