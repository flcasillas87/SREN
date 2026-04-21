-- ----------------------------------------------------------------------------
-- 3.4  penalizacion
--      Fórmula: importe = volumen_desbalance × factor × precio_referencia
--      Una factura puede incluir varias líneas de penalización (1:N).
-- ----------------------------------------------------------------------------
create table public.penalizacion (
    id_penalizacion uuid not null default extensions.uuid_generate_v4(),
    id_factura uuid not null,
    num_linea smallint not null default 1,
    -- orden dentro de la factura
    -- Tipo y causa
    tipo_penalizacion varchar(100) not null,
    -- Ej: 'DESBALANCE_DIARIO' | 'EXCESO_CAPACIDAD' | 'INCUMPLIMIENTO_NOMINAL'
    descripcion_causa text null,
    referencia_cre varchar(100) null,
    -- disposición CRE/CENAGAS aplicable
    periodo_penalizado date null,
    -- fecha del desbalance
    -- Parámetros de cálculo
    volumen_desbalance_gj numeric(18, 4) not null,
    factor_penalizacion numeric(10, 6) not null,
    -- multiplicador (p.ej. 1.10 = 110%)
    precio_referencia numeric(18, 6) null,
    -- precio spot o de referencia
    tarifa_base numeric(18, 6) null,
    -- tarifa normal del servicio
    id_unidad_medida integer null,
    -- Importe calculado
    importe_calculado numeric(18, 6) generated always as (
        volumen_desbalance_gj * factor_penalizacion * coalesce(precio_referencia, tarifa_base, 0)
    ) stored,
    -- Conciliación
    conciliado boolean null default false,
    diferencia_importe numeric(18, 6) null,
    notas text null,
    created_at timestamp null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp null default (now() at time zone 'America/Monterrey'),
    constraint penalizacion_pkey primary key (id_penalizacion),
    constraint penalizacion_uq_linea unique (id_factura, num_linea),
    -- no duplicar línea
    constraint fk_pen_factura foreign key (id_factura) references public.factura_pago (id_factura) on delete cascade,
    constraint fk_pen_unidad foreign key (id_unidad_medida) references datos_maestros.cat_unidades_medida (id_unidad_medida),
    constraint chk_pen_volumen check (volumen_desbalance_gj >= 0),
    constraint chk_pen_factor check (factor_penalizacion > 0)
) tablespace pg_default;
create index if not exists idx_pen_factura on public.penalizacion using btree (id_factura) tablespace pg_default;
create index if not exists idx_pen_periodo on public.penalizacion using btree (periodo_penalizado) tablespace pg_default;
create trigger tr_u_penalizacion before
update on public.penalizacion for each row execute function fn_update_at_mx();
comment on table public.penalizacion is 'Penalizaciones/desbalanceos. Fórmula: Vol_desbalance × Factor × Precio_ref. Rel. 1:N con factura_pago.';
comment on column public.penalizacion.importe_calculado is 'Calculado: vol_desbalance × factor × coalesce(precio_referencia, tarifa_base, 0)';