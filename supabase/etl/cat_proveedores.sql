create schema if not exists etl;

create or replace procedure etl.pr_load_cat_proveedores()
language plpgsql
as $$
begin
    insert into datos_maestros.cat_proveedores (
        razon_social,
        rfc,
        email,
        observaciones,
        archivo_origen,
        fecha_carga,
        usuario_carga
    )
    select
        nullif(btrim(razon_social_raw), ''),
        nullif(upper(btrim(rfc_raw)), ''),
        nullif(lower(btrim(email_raw)), ''),
        observaciones,
        archivo_origen,
        fecha_carga,
        usuario_carga
    from staging.stg_proveedores
    where nullif(btrim(razon_social_raw), '') is not null
    on conflict (rfc) do update
    set
        razon_social = excluded.razon_social,
        email = excluded.email,
        updated_at = now(),
        observaciones = excluded.observaciones,
        archivo_origen = excluded.archivo_origen,
        fecha_carga = excluded.fecha_carga,
        usuario_carga = excluded.usuario_carga;

    truncate table staging.stg_proveedores;
end;
$$;

