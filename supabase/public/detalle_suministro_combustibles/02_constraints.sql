-- =============================================================================
-- CONSTRAINTS para fact_precio_vinculante
-- =============================================================================

alter table public.fact_precio_vinculante
    add constraint fact_precio_vinculante_pkey
        primary key (id_precio_vinculante),
    add constraint fact_precio_vinculante_ck_fechas_vigencia
        check (fecha_fin_vigencia >= fecha_inicio_vigencia),
    add constraint fk_fact_precio_vinculante_combustible
        foreign key (id_combustible)
        references public.dim_combustible(id_combustible)
        on delete restrict,
    add constraint fk_fact_precio_vinculante_region
        foreign key (id_region)
        references public.dim_region(id_region)
        on delete restrict;
