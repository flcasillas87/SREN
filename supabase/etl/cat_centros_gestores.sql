create schema if not exists etl;

create or replace procedure etl.pr_load_cat_centros_gestores()
language plpgsql
as $$
begin
    drop table if exists staging.cat_centros_gestores_normalized;
    drop table if exists staging.cat_centros_gestores_ready;

    create table staging.cat_centros_gestores_normalized as
    with src as (
        select
            id_stg_centro_gestor as source_row,
            codigo,
            nombre,
            sociedad_id,
            activo,
            observaciones,
            archivo_origen,
            fecha_carga,
            usuario_carga
        from staging.cat_centros_gestores
    )
    select
        source_row,
        upper(btrim(codigo)) as codigo,
        btrim(nombre) as nombre,
        nullif(btrim(sociedad_id), '') as sociedad_id_raw,
        nullif(btrim(observaciones), '') as observaciones,
        nullif(btrim(archivo_origen), '') as archivo_origen,
        fecha_carga,
        usuario_carga,
        case
            when nullif(btrim(activo), '') is null then true
            when lower(btrim(activo)) in ('true', '1', 'si', 'sí', 'yes', 'y') then true
            when lower(btrim(activo)) in ('false', '0', 'no', 'n') then false
            else null
        end as activo
    from src;

    create table staging.cat_centros_gestores_ready as
    with duplicados as (
        select
            upper(btrim(codigo)) as codigo
        from staging.cat_centros_gestores
        where nullif(btrim(codigo), '') is not null
        group by upper(btrim(codigo))
        having count(*) > 1
    ),
    validation_errors as (
        select
            s.source_row
        from staging.cat_centros_gestores_normalized s
        where nullif(btrim(s.codigo), '') is null

        union all

        select
            s.source_row
        from staging.cat_centros_gestores_normalized s
        where nullif(btrim(s.nombre), '') is null

        union all

        select
            s.source_row
        from staging.cat_centros_gestores_normalized s
        where nullif(btrim(s.sociedad_id_raw), '') is not null
          and btrim(s.sociedad_id_raw) !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'

        union all

        select
            s.source_row
        from staging.cat_centros_gestores_normalized s
        where s.activo is null

        union all

        select
            s.source_row
        from staging.cat_centros_gestores_normalized s
        inner join duplicados d
            on upper(btrim(s.codigo)) = d.codigo
    )
    select
        n.source_row,
        n.codigo,
        n.nombre,
        case
            when n.sociedad_id_raw is null then null
            else n.sociedad_id_raw::uuid
        end as sociedad_id,
        coalesce(n.activo, true) as activo,
        n.observaciones,
        n.archivo_origen,
        n.fecha_carga,
        n.usuario_carga
    from staging.cat_centros_gestores_normalized n
    where not exists (
        select 1
        from validation_errors e
        where e.source_row = n.source_row
    );

    insert into datos_maestros.cat_centros_gestores (
        codigo,
        nombre,
        sociedad_id,
        activo,
        created_by,
        updated_by,
        observaciones,
        archivo_origen,
        fecha_carga,
        usuario_carga
    )
    select
        r.codigo,
        r.nombre,
        r.sociedad_id,
        r.activo,
        'csv_import',
        'csv_import',
        r.observaciones,
        r.archivo_origen,
        r.fecha_carga,
        r.usuario_carga
    from staging.cat_centros_gestores_ready r
    on conflict (codigo) do update
    set
        nombre = excluded.nombre,
        sociedad_id = excluded.sociedad_id,
        activo = excluded.activo,
        updated_at = now(),
        updated_by = 'csv_import',
        observaciones = excluded.observaciones,
        archivo_origen = excluded.archivo_origen,
        fecha_carga = excluded.fecha_carga,
        usuario_carga = excluded.usuario_carga;

    truncate table staging.cat_centros_gestores;
    drop table if exists staging.cat_centros_gestores_normalized;
    drop table if exists staging.cat_centros_gestores_ready;
end;
$$;
