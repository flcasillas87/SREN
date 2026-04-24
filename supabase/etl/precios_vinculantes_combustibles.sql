-- =========================================================
-- Esquema: etl
-- Proceso: precios_vinculantes_combustibles
-- Objetivo: Orquestar validacion, normalizacion, merge y limpieza
-- =========================================================

create schema if not exists etl;

create or replace procedure etl.pr_load_precios_vinculantes_combustibles()
language plpgsql
as $$
begin
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

    drop table if exists staging.precios_vinculantes_combustibles_ready;

    create table staging.precios_vinculantes_combustibles_ready as
    select
        n.source_row,
        n.batch_id,
        n.fecha,
        c.id_combustible,
        u.id_unidad_medida,
        cg.id_central_generacion,
        n.precio_vinculante_combustibles,
        n.fuente,
        n.observaciones as observaciones,
        n.archivo_origen as archivo_origen,
        n.fecha_carga as fecha_carga,
        n.usuario_carga as usuario_carga
    from staging.precios_vinculantes_combustibles_normalized n
    join datos_maestros.cat_combustibles c
      on upper(btrim(c.nombre_combustible)) = n.nombre_combustible
    join datos_maestros.cat_unidades_medida u
      on upper(btrim(u.codigo)) = n.nombre_unidad_medida
     and u.id_combustible = c.id_combustible
    join datos_maestros.cat_centrales_generacion cg
      on regexp_replace(upper(btrim(cg.nombre_central)), '\s+', ' ', 'g') = n.nombre_central
    where not exists (
        select 1
        from staging.vw_precios_vinculantes_combustibles_validation_errors e
        where e.source_row = n.source_row
    );

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

    truncate table staging.stg_precios_vinculantes_combustibles;
    drop table if exists staging.precios_vinculantes_combustibles_normalized;
    drop table if exists staging.precios_vinculantes_combustibles_ready;
end;
$$;
