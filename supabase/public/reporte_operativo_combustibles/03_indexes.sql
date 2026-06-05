-- =============================================================================
-- 03_indexes.sql
-- Índices recomendados para public.reporte_operativo_combustibles
-- =============================================================================

create index if not exists idx_reporte_operativo_combustibles_activo_fecha
  on public.reporte_operativo_combustibles (es_activo, fecha_entrega);

create index if not exists idx_reporte_operativo_combustibles_central_combustible
  on public.reporte_operativo_combustibles (id_central_generacion, id_combustible, id_unidad_medida);

create index if not exists idx_reporte_operativo_combustibles_fecha_central
  on public.reporte_operativo_combustibles (fecha_entrega, id_central_generacion);
