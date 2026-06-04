-- =========================================================
-- Esquema: public
-- Tabla: precios_vinculantes_combustibles
-- Archivo: 02_constraints.sql
-- =========================================================

alter table public.precios_vinculantes_combustibles
    add constraint precios_vinculantes_combustibles_pkey
        primary key (id_precio_vinculante_combustible),
    add constraint uq_precio_fecha_combustible_central
        unique(fecha, id_combustible, id_central_generacion),
    add constraint fk_pv_id_combustible
        foreign key (id_combustible)
        references datos_maestros.cat_combustibles(id_combustible)
        on delete restrict,
    add constraint fk_pv_id_unidad_medida
        foreign key (id_unidad_medida)
        references datos_maestros.cat_unidades_medida(id_unidad_medida)
        on delete restrict,
    add constraint fk_pv_id_central_generacion
        foreign key (id_central_generacion)
        references datos_maestros.cat_centrales_generacion(id_central_generacion)
        on delete restrict,
    add constraint fk_pv_created_by
        foreign key (created_by)
        references auth.users(id);

alter table public.audit_precios_vinculantes_combustibles
    add constraint audit_pv_id_precio_fkey
        foreign key (id_precio_vinculante_combustible)
        references public.precios_vinculantes_combustibles(id_precio_vinculante_combustible)
        on delete restrict;
