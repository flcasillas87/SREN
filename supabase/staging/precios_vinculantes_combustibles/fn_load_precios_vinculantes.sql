create or replace function etl.fn_load_precios_vinculantes_combustibles()
returns void
language plpgsql
as $$
begin
    insert into public.precios_vinculantes_combustibles (
        fecha,
        id_combustible,
        id_unidad_medida,
        id_central_generacion,
        precio_vinculante_combustibles,
        fuente,
        observaciones,
        es_activo
    )
    select
        r.fecha,
        r.id_combustible,
        r.id_unidad_medida,
        r.id_central_generacion,
        r.precio_vinculante_combustibles,
        r.fuente,
        r.observaciones,
        true
    from staging.precios_vinculantes_combustibles_ready r
    on conflict (fecha, id_combustible, id_central_generacion) do update
    set
        id_unidad_medida = excluded.id_unidad_medida,
        precio_vinculante_combustibles = excluded.precio_vinculante_combustibles,
        fuente = excluded.fuente,
        observaciones = excluded.observaciones,
        es_activo = true,
        updated_at = (now() at time zone 'America/Monterrey');
exception
when others then
    raise exception 'Error en ETL precios vinculantes: %', sqlerrm;
end;
$$;
