-- =============================================================================
-- COMMENTS para fact_precio_vinculante
-- =============================================================================

comment on table public.fact_precio_vinculante is
    'Tabla de hechos de precios vinculantes de combustible por región con vigencia de precio.';

comment on column public.fact_precio_vinculante.id_precio_vinculante is
    'Identificador único del precio vinculante';

comment on column public.fact_precio_vinculante.id_combustible is
    'Referencia a la dimensión de combustible';

comment on column public.fact_precio_vinculante.id_region is
    'Referencia a la dimensión de región';

comment on column public.fact_precio_vinculante.fecha_inicio_vigencia is
    'Fecha de inicio de vigencia del precio';

comment on column public.fact_precio_vinculante.fecha_fin_vigencia is
    'Fecha de fin de vigencia del precio';

comment on column public.fact_precio_vinculante.precio_vinculante is
    'Precio vinculante aplicado en el período de vigencia';

comment on column public.fact_precio_vinculante.activo is
    'Indicador de registro activo para reportes y cargas';
