-- =========================================================
-- Esquema: public
-- Tabla: cargo_fijo
-- Archivo: 05_comments.sql
-- =========================================================

comment on table public.cargo_fijo
    is 'Cargo fijo por reserva de capacidad. Formula: reserva_diaria x tarifa x dias_periodo.';

comment on column public.cargo_fijo.reserva_capacidad
    is 'Reserva total contratada para referencia y trazabilidad.';

comment on column public.cargo_fijo.reserva_diaria
    is 'Reserva diaria base del calculo del cargo fijo.';

comment on column public.cargo_fijo.dias_periodo
    is 'Dias del periodo de servicio facturado.';

comment on column public.cargo_fijo.tarifa
    is 'Valor numerico de la tarifa vigente aplicada al periodo facturado.';

comment on column public.cargo_fijo.moneda_tarifa
    is 'Moneda de la tarifa aplicada, por ejemplo USD o MXN.';

comment on column public.cargo_fijo.id_unidad_medida
    is 'Unidad fisica obligatoria asociada a la tarifa y la reserva, por ejemplo GJ o MMBtu.';

comment on column public.cargo_fijo.importe_calculado
    is 'Calculado como reserva_diaria x tarifa x dias_periodo.';

comment on column public.cargo_fijo.conciliado
    is 'Indica si el concepto fue conciliado contra la factura.';

comment on column public.cargo_fijo.diferencia_importe
    is 'Diferencia detectada entre el importe facturado y el importe calculado.';

comment on column public.cargo_fijo.notas
    is 'Observaciones libres del proceso de validacion o conciliacion.';
