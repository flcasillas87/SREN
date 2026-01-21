create or replace function etl.fn_load_precios_vinculantes_combustibles() returns void language plpgsql as $$ begin
insert into public.precios_vinculantes_combustibles (
        fecha,
        id_combustible,
        id_unidad_medida,
        id_central_generacion,
        precio_vinculante_combustibles,
        fuente,
        observaciones
    )
select to_date(s.fecha, 'YYYY-MM-DD') as fecha,
    c.id_combustible,
    u.id_unidad_medida,
    cg.id_central_generacion,
    replace(s.precio_vinculante_combustibles, ',', '')::numeric(15, 4),
    s.fuente,
    s.observaciones
from staging.stg_precios_vinculantes_combustibles s
    join datos_maestros.cat_combustibles c on upper(trim(s.nombre_combustible)) = upper(trim(c.nombre))
    join datos_maestros.cat_unidades_medida u on upper(trim(s.nombre_unidad)) = upper(trim(u.codigo))
    join datos_maestros.cat_centrales_generacion cg on upper(trim(s.nombre_central_generacion)) = upper(trim(cg.nombre))
where s.precio_vinculante_combustibles ~ '^[0-9,]+(\.[0-9]+)?$';
exception
when others then raise exception 'Error en ETL precios vinculantes: %',
sqlerrm;
end;
$$;