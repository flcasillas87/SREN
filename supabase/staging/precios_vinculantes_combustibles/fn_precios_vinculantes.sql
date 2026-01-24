-- =============================================================================
-- check_fecha_vinculante()
-- =============================================================================
create or replace function public.check_fecha_vinculante() returns trigger as $$ begin if (old.fecha < current_date - interval '7 days') then raise exception 'Registro inmutable: tiene más de 7 días.';
end if;
return new;
end;
$$ language plpgsql;
-- =============================================================================
-- log_cambios_precios()
-- =============================================================================
create or replace function public.log_cambios_precios() returns trigger as $$ begin
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
$$ language plpgsql;
-- =============================================================================
-- FUNCIÓN DE SEGURIDAD: REGLA DE INMUTABILIDAD (7 DÍAS)
-- =============================================================================
create or replace function public.check_fecha_vinculante() returns trigger as $$ begin -- Si la fecha del registro es menor a hoy menos 7 días, bloqueamos
    if (old.fecha < current_date - interval '7 days') then raise exception 'Operación denegada: El registro de fecha % tiene más de 7 días y es inmutable.',
    old.fecha;
end if;
return new;
end;
$$ language plpgsql;