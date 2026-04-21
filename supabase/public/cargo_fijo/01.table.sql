-- =============================================================================
-- SECCIÓN 3 — TABLAS DE CONCEPTO (public)
--   Cada tabla referencia factura_pago 1:1 (o 1:N en penalizaciones).
--   Contienen solo los campos propios de su fórmula de cálculo.
-- =============================================================================
-- ----------------------------------------------------------------------------
-- 3.1  cargo_fijo
--      Fórmula: importe = reserva_diaria_gj × tarifa × dias_periodo
--      La tarifa y la reserva vienen del contrato; aquí se registran los
--      valores vigentes al momento de la facturación para trazabilidad.
-- ----------------------------------------------------------------------------
create table public.cargo_fijo (
    id_cargo_fijo uuid not null default extensions.uuid_generate_v4(),
    id_factura uuid not null,
    -- Parámetros de cálculo (valores del periodo facturado)
    reserva_capacidad_gj numeric(18, 4) null,
    -- reserva total contratada
    reserva_diaria_gj numeric(18, 4) not null,
    -- RC diaria base del cálculo
    dias_periodo smallint not null,
    -- días del mes de servicio
    tarifa numeric(18, 6) not null,
    -- tarifa USD/GJ·día vigente
    id_unidad_medida integer null,
    -- → datos_maestros.cat_unidades_medida
    -- Ajuste USPPI (índice de precios al productor de EE.UU.)
    usppi_o numeric(10, 6) null,
    -- USPPIo: índice base (origen del contrato)
    usppi_m numeric(10, 6) null,
    -- USPPIm: índice del mes facturado
    factor_usppi numeric(10, 8) generated always as (
        case
            when usppi_o is not null
            and usppi_o <> 0 then usppi_m / usppi_o
            else null
        end
    ) stored,
    -- Importe calculado para validación cruzada vs factura
    importe_calculado numeric(18, 6) generated always as (
        reserva_diaria_gj * tarifa * dias_periodo
    ) stored,
    -- Conciliación
    conciliado boolean null default false,
    diferencia_importe numeric(18, 6) null,
    -- llenado por proceso de validación
    notas text null,
    created_at timestamp null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp null default (now() at time zone 'America/Monterrey'),
    constraint cargo_fijo_pkey primary key (id_cargo_fijo),
    constraint cargo_fijo_factura_uq unique (id_factura),
    -- 1 registro por factura
    constraint fk_cf_factura foreign key (id_factura) references public.factura_pago (id_factura) on delete cascade,
    constraint fk_cf_unidad foreign key (id_unidad_medida) references datos_maestros.cat_unidades_medida (id_unidad_medida),
    constraint chk_cf_dias check (
        dias_periodo between 1 and 31
    ),
    constraint chk_cf_reserva check (reserva_diaria_gj > 0),
    constraint chk_cf_tarifa check (tarifa > 0)
) tablespace pg_default;
create index if not exists idx_cf_factura on public.cargo_fijo using btree (id_factura) tablespace pg_default;
create trigger tr_u_cargo_fijo before
update on public.cargo_fijo for each row execute function fn_update_at_mx();
comment on table public.cargo_fijo is 'Cargo fijo por reserva de capacidad. Fórmula: RC_diaria × Tarifa × Días';
comment on column public.cargo_fijo.factor_usppi is 'Calculado: USPPIm / USPPIo';
comment on column public.cargo_fijo.importe_calculado is 'Calculado: reserva_diaria_gj × tarifa × dias_periodo';