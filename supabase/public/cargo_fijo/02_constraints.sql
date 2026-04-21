-- =========================================================
-- Esquema: public
-- Tabla: cargo_fijo
-- Archivo: 02_constraints.sql
-- =========================================================

alter table public.cargo_fijo
    drop constraint if exists cargo_fijo_factura_uq,
    drop constraint if exists fk_cf_factura,
    drop constraint if exists fk_cf_moneda,
    drop constraint if exists fk_cf_unidad,
    drop constraint if exists chk_cf_dias,
    drop constraint if exists chk_cf_reserva_total,
    drop constraint if exists chk_cf_reserva,
    drop constraint if exists chk_cf_tarifa,
    drop constraint if exists chk_cf_moneda_tarifa,
    drop constraint if exists chk_cf_usppi_positivos,
    drop constraint if exists chk_cf_usppi_par;

alter table public.cargo_fijo
    add constraint cargo_fijo_factura_uq unique (id_factura);

alter table public.cargo_fijo
    add constraint fk_cf_factura
    foreign key (id_factura)
    references public.factura_pago (id_factura)
    on delete cascade;

alter table public.cargo_fijo
    add constraint fk_cf_moneda
    foreign key (moneda_tarifa)
    references datos_maestros.cat_monedas (codigo);

alter table public.cargo_fijo
    add constraint fk_cf_unidad
    foreign key (id_unidad_medida)
    references datos_maestros.cat_unidades_medida (id_unidad_medida);

alter table public.cargo_fijo
    add constraint chk_cf_dias
    check (dias_periodo between 1 and 31);

alter table public.cargo_fijo
    add constraint chk_cf_reserva_total
    check (reserva_capacidad_gj is null or reserva_capacidad_gj > 0);

alter table public.cargo_fijo
    add constraint chk_cf_reserva
    check (reserva_diaria_gj > 0);

alter table public.cargo_fijo
    add constraint chk_cf_tarifa
    check (tarifa > 0);

alter table public.cargo_fijo
    add constraint chk_cf_moneda_tarifa
    check (btrim(moneda_tarifa) <> '');

alter table public.cargo_fijo
    add constraint chk_cf_usppi_positivos
    check (
        (usppi_o is null or usppi_o > 0)
        and (usppi_m is null or usppi_m > 0)
    );

alter table public.cargo_fijo
    add constraint chk_cf_usppi_par
    check (
        (usppi_o is null and usppi_m is null)
        or (usppi_o is not null and usppi_m is not null)
    );
