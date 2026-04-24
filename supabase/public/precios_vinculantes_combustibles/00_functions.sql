-- =============================================================================
-- check_fecha_vinculante()
-- =============================================================================
create or replace function public.check_fecha_vinculante()
returns trigger
language plpgsql
as $$
begin
    if tg_op = 'DELETE' then
        if old.fecha < current_date - interval '7 days' then
            raise exception 'Operación denegada: el registro de fecha % tiene más de 7 días y es inmutable.', old.fecha;
        end if;
        return old;
    end if;

    if old.fecha < current_date - interval '7 days' then
        if old.fecha is distinct from new.fecha
           or old.id_combustible is distinct from new.id_combustible
           or old.id_unidad_medida is distinct from new.id_unidad_medida
           or old.id_central_generacion is distinct from new.id_central_generacion
           or old.precio_vinculante_combustibles is distinct from new.precio_vinculante_combustibles then
            raise exception 'Operación denegada: el registro de fecha % tiene más de 7 días y no puede cambiar datos de negocio.', old.fecha;
        end if;
    end if;

    return new;
end;
$$;
-- =============================================================================
-- log_cambios_precios()
-- =============================================================================
create or replace function public.log_cambios_precios()
returns trigger
language plpgsql
as $$
begin
    insert into public.audit_precios_vinculantes_combustibles (
        id_precio_vinculante_combustible,
        precio_anterior,
        precio_nuevo,
        usuario_cambio
    )
    values (
        old.id_precio_vinculante_combustible,
        old.precio_vinculante_combustibles,
        new.precio_vinculante_combustibles,
        auth.uid()
    );
    return new;
end;
$$;
