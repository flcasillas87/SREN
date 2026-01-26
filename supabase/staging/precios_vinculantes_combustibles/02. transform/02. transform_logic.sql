-- =========================================================
-- 02b_transform_logic.sql
-- STG → TRF (validación y normalización)
-- =========================================================
insert into transform.trf_precios_vinculantes_combustibles (
        batch_id,
        fecha,
        nombre_combustible,
        nombre_unidad_medida,
        nombre_central,
        precio_vinculante_combustibles,
        fuente,
        observaciones,
        es_valido,
        error_motivo
    )
select s.batch_id,
    -- Fecha
    case
        when s.fecha ~ '^\d{4}-\d{2}-\d{2}$' then to_date(s.fecha, 'YYYY-MM-DD')
        else null
    end as fecha,
    upper(trim(s.nombre_combustible)) as nombre_combustible,
    upper(trim(s.nombre_unidad_medida)) as nombre_unidad_medida,
    regexp_replace(upper(trim(s.nombre_central)), '\s+', ' ', 'g') as nombre_central,
    -- Precio
    case
        when replace(s.precio_vinculante_combustibles, ',', '') ~ '^[0-9]+(\.[0-9]+)?$' then replace(s.precio_vinculante_combustibles, ',', '')::numeric
        else null
    end as precio_vinculante_combustibles,
    coalesce(s.fuente, 'Carga_Manual_' || current_date) as fuente,
    s.observaciones,
    -- Validación global
    case
        when s.fecha ~ '^\d{4}-\d{2}-\d{2}$'
        and replace(s.precio_vinculante_combustibles, ',', '') ~ '^[0-9]+(\.[0-9]+)?$'
        and s.nombre_combustible is not null
        and s.nombre_unidad_medida is not null
        and s.nombre_central is not null then true
        else false
    end as es_valido,
    -- Motivo de error
    case
        when s.fecha !~ '^\d{4}-\d{2}-\d{2}$' then 'Fecha inválida'
        when replace(s.precio_vinculante_combustibles, ',', '') !~ '^[0-9]+(\.[0-9]+)?$' then 'Precio inválido'
        when s.nombre_combustible is null then 'Combustible nulo'
        when s.nombre_unidad_medida is null then 'Unidad medida nula'
        when s.nombre_central is null then 'Central nula'
        else null
    end as error_motivo
from staging.stg_precios_vinculantes_combustibles s;