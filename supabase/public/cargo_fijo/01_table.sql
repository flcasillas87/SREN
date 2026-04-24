-- =========================================================
-- Esquema: public
-- Tabla: cargo_fijo
-- Archivo: 01_table.sql
-- =========================================================
drop table if exists public.cargo_fijo cascade;
create table public.cargo_fijo (
    id_cargo_fijo uuid not null default extensions.uuid_generate_v4(),
    id_factura uuid not null,
    reserva_capacidad numeric(18, 4) null,
    reserva_diaria numeric(18, 4) not null,
    dias_periodo smallint not null,
    tarifa numeric(18, 6) not null,
    moneda_tarifa varchar(5) not null,
    id_unidad_medida integer not null,
    importe_calculado numeric(18, 6) generated always as (
        reserva_diaria * tarifa * dias_periodo
    ) stored,
    conciliado boolean null default false,
    diferencia_importe numeric(18, 6) null,
    notas text null,
    created_at timestamp not null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp not null default (now() at time zone 'America/Monterrey'),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    constraint cargo_fijo_pkey primary key (id_cargo_fijo)
);
