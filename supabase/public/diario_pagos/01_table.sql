-- =========================================================
-- Esquema: public
-- Tabla: diario_pagos
-- Archivo: 01_table.sql
-- =========================================================

drop table if exists public.diario_pagos cascade;

create table public.diario_pagos (
    id uuid not null default gen_random_uuid(),
    documento_id uuid not null,
    fecha_pago date not null,
    documento_pago_sap text null,
    moneda_pago varchar(5) not null,
    monto_pagado_moneda_pago numeric(18, 2) null,
    tc_pago numeric(12, 6) null,
    total_pagado_mxn numeric(18, 2) null,
    comentarios text null,
    created_at timestamp not null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp not null default (now() at time zone 'America/Monterrey'),
    constraint diario_pagos_pkey primary key (id)
);
