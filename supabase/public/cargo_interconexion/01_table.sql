-- ----------------------------------------------------------------------------
-- 3.3  cargo_interconexion
--      Cargos en puntos de interconexión fronteriza México–EE.UU.
--      La fórmula varía por contrato; se registra la base de cálculo
--      textualmente y el importe calculado se llena manualmente.
-- ----------------------------------------------------------------------------
create table public.cargo_interconexion (
    id_interconexion uuid not null default extensions.uuid_generate_v4(),
    id_factura uuid not null,
    -- Identificación del punto fronterizo
    punto_interconexion varchar(200) not null,
    -- p.ej. "Reynosa–McAllen"
    operador_frontera varchar(200) null,
    -- p.ej. "NET Mexico Pipeline"
    cruce_fronterizo varchar(200) null,
    -- nombre del cruce
    estado_frontera varchar(100) null,
    -- Parámetros de cálculo
    capacidad_contratada_gj numeric(18, 4) null,
    volumen_interconexion_gj numeric(18, 4) null,
    tarifa_interconexion numeric(18, 6) null,
    dias_periodo smallint null,
    id_unidad_medida integer null,
    -- Tipo de cargo y base contractual
    tipo_cargo varchar(20) null,
    -- 'CAPACIDAD' | 'VOLUMETRICO' | 'MIXTO'
    base_calculo text null,
    -- descripción textual de la fórmula
    -- Importe calculado (manual, fórmula contractual variable)
    importe_calculado numeric(18, 6) null,
    -- Conciliación
    conciliado boolean null default false,
    diferencia_importe numeric(18, 6) null,
    notas text null,
    created_at timestamp null default (now() at time zone 'America/Monterrey'),
    updated_at timestamp null default (now() at time zone 'America/Monterrey'),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    constraint cargo_interconexion_pkey primary key (id_interconexion),
    constraint cargo_interconexion_factura_uq unique (id_factura),
    constraint fk_ci_factura foreign key (id_factura) references public.factura_pago (id_factura) on delete cascade,
    constraint fk_ci_unidad foreign key (id_unidad_medida) references datos_maestros.cat_unidades_medida (id_unidad_medida),
    constraint chk_ci_tipo_cargo check (
        tipo_cargo in ('CAPACIDAD', 'VOLUMETRICO', 'MIXTO')
        or tipo_cargo is null
    )
) tablespace pg_default;
create index if not exists idx_ci_factura on public.cargo_interconexion using btree (id_factura) tablespace pg_default;
create trigger tr_u_cargo_interconexion before
update on public.cargo_interconexion for each row execute function fn_update_at_mx();
comment on table public.cargo_interconexion is 'Cargos por punto de interconexión fronteriza. Fórmula contractual variable.';
