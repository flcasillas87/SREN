-- =========================================================
-- VALIDACIONES ETL
-- Dominio : precios_vinculantes_combustibles
-- Etapa   : staging → transform
-- =========================================================

-- 1. Precios no numéricos
select
    'Precio No Numérico' as tipo_error,
    s.*
from staging.stg_precios_vinculantes_combustibles s
where s.precio_vinculante_combustibles !~ '^[0-9,]+(\.[0-9]+)?$';

-- 2. Precios <= 0
select
    'Precio Inválido (<=0)' as tipo_error,
    s.*
from staging.stg_precios_vinculantes_combustibles s
where s.precio_vinculante_combustibles ~ '^[0-9,]+(\.[0-9]+)?$'
  and replace(s.precio_vinculante_combustibles, ',', '')::numeric <= 0;

-- 3. Unidades no mapeadas
select
    'Unidad No Existe' as tipo_error,
    s.nombre_unidad_medida
from staging.stg_precios_vinculantes_combustibles s
where not exists (
    select 1
    from datos_maestros.cat_unidades_medida u
    where upper(trim(s.nombre_unidad_medida)) = upper(trim(u.codigo))
);

-- 4. Combustibles no mapeados
select
    'Combustible No Existe' as tipo_error,
    s.nombre_combustible
from staging.stg_precios_vinculantes_combustibles s
where not exists (
    select 1
    from datos_maestros.cat_combustibles c
    where upper(trim(s.nombre_combustible)) = upper(trim(c.nombre_combustible))
);

-- 5. Centrales no mapeadas
select
    'Central No Existe' as tipo_error,
    s.nombre_central
from staging.stg_precios_vinculantes_combustibles s
where not exists (
    select 1
    from datos_maestros.cat_centrales_generacion g
    where regexp_replace(upper(trim(s.nombre_central)), '\s+', ' ', 'g')
        = regexp_replace(upper(trim(g.nombre_central)), '\s+', ' ', 'g')
);

-- 6. Fechas inválidas
select
    'Fecha Fuera de Rango o Formato' as tipo_error,
    s.*
from staging.stg_precios_vinculantes_combustibles s
where s.fecha !~ '^\d{4}-\d{2}-\d{2}$'
   or (
        to_date(s.fecha, 'YYYY-MM-DD') < date '2000-01-01'
        or to_date(s.fecha, 'YYYY-MM-DD') > current_date
      );
