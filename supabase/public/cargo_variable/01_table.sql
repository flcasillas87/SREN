-- ----------------------------------------------------------------------------
-- 3.2  cargo_variable
--      Fórmula: importe = volumen_real_gj × tarifa_variable
-- ----------------------------------------------------------------------------
create table public.cargo_variable (
    id_cargo_variable uuid not null default extensions.uuid_generate_v4(),
    id_factura uuid not null,
    -- Parámetros de cálculo
    volumen_real_gj numeric(18, 4) not null,
    -- GJ realmente transportados
    flujo_promedio_gj numeric(18, 4) null,
    -- flujo promedio diario (GJ/día)
    volumen_mensual_gj numeric(18, 4) null,
    -- total del mes (referencia/auditoría)
    tarifa_variable numeric(18, 6) not null,
    -- tarifa USD/GJ vigente
    id_unidad_medida integer null,
    -- Ajuste USPPI
    usppi_o numeric(10, 6) null,
    usppi_m numeric(10, 6) null,
    factor_usppi numeric(10, 8) generated always as (
        case
            when usppi_o is not null
            and usppi_o <> 0 then usppi_m / usppi_o
            else null
        end
    ) stored,
    -- Importe calculado
    importe_calculado numeric(18, 6) generated always as (
        volumen_real_gj * tarifa_variable
    ) stored,
    -- Conciliación
    conciliado boolean null default false,
    diferencia_importe numeric(18, 6) null,
    notas text null,
    created_at timestamp null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp null default (now() at time zone 'America/Monterrey'),
    constraint cargo_variable_pkey primary key (id_cargo_variable),
    constraint cargo_variable_factura_uq unique (id_factura),
    constraint fk_cv_factura foreign key (id_factura) references public.factura_pago (id_factura) on delete cascade,
    constraint fk_cv_unidad foreign key (id_unidad_medida) references datos_maestros.cat_unidades_medida (id_unidad_medida),
    constraint chk_cv_volumen check (volumen_real_gj >= 0),
    constraint chk_cv_tarifa check (tarifa_variable > 0)
) tablespace pg_default;
create index if not exists idx_cv_factura on public.cargo_variable using btree (id_factura) tablespace pg_default;
create trigger tr_u_cargo_variable before
update on public.cargo_variable for each row execute function fn_update_at_mx();
comment on table public.cargo_variable is 'Cargo variable por volumen transportado. Fórmula: Vol_real × Tarifa_variable';
comment on column public.cargo_variable.importe_calculado is 'Calculado: volumen_real_gj × tarifa_variable';