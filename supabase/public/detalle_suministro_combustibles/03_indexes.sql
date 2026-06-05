-- =============================================================================
-- ÍNDICES recomendados para fact_precio_vinculante
-- =============================================================================

create index if not exists idx_fact_precio_vinculante_activo_fecha
  on public.fact_precio_vinculante (activo, fecha_inicio_vigencia, fecha_fin_vigencia);

create index if not exists idx_fact_precio_vinculante_combustible_region
  on public.fact_precio_vinculante (id_combustible, id_region);
