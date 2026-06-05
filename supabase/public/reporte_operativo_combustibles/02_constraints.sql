-- =============================================================================
-- 02_constraints.sql
-- Constraints para public.reporte_operativo_combustibles
-- =============================================================================

alter table public.reporte_operativo_combustibles
    add constraint reporte_operativo_combustibles_pkey
        primary key (id_reporte_operativo_combustibles),
    add constraint reporte_operativo_combustibles_unq
        unique (fecha_entrega, id_central_generacion, id_combustible, id_unidad_medida),
    add constraint reporte_operativo_combustibles_fk_central
        foreign key (id_central_generacion)
        references datos_maestros.cat_centrales_generacion(id_central_generacion)
        on delete restrict,
    add constraint reporte_operativo_combustibles_fk_combustible
        foreign key (id_combustible)
        references datos_maestros.cat_combustibles(id_combustible)
        on delete restrict,
    add constraint reporte_operativo_combustibles_fk_unidad_medida
        foreign key (id_unidad_medida)
        references datos_maestros.cat_unidades_medida(id_unidad_medida)
        on delete restrict,
    add constraint reporte_operativo_combustibles_fk_created_by
        foreign key (created_by)
        references auth.users(id);
