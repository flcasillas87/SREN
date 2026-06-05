-- Índices y materialized views sugeridos para `precios_vinculantes_combustibles`
-- NO ejecutar en producción sin pruebas previas en staging.

-- 1) Asegurar esquema de reporting
CREATE SCHEMA IF NOT EXISTS reporting;

-- 2) Wrappers en reporting para mantener compatibilidad con consumidores
--    Estos crean vistas en el esquema `reporting` que delegan a las vistas
--    existentes en `public`. Son seguras y no duplican lógica.
CREATE OR REPLACE VIEW reporting.vw_precios_vigentes AS
  SELECT * FROM public.vw_precios_vigentes;

CREATE OR REPLACE VIEW reporting.vw_reporte_mensual_por_central AS
  SELECT * FROM public.vw_reporte_mensual_por_central;

CREATE OR REPLACE VIEW reporting.vw_comparativo_mensual AS
  SELECT * FROM public.vw_comparativo_mensual;

CREATE OR REPLACE VIEW reporting.vw_historico_auditoria AS
  SELECT * FROM public.vw_historico_auditoria;

CREATE OR REPLACE VIEW reporting.vw_alertas_vencimiento AS
  SELECT * FROM public.vw_alertas_vencimiento;

-- 3) Índices recomendados para mejorar filtros, particiones y joins
-- Ajusta nombres según conveniencia del DBA y revisa existencia previa.
-- Índice para consultas por estado activo y fecha
CREATE INDEX IF NOT EXISTS idx_pvc_es_activo_fecha
  ON public.precios_vinculantes_combustibles (es_activo, fecha);

-- Índice compuesto para ventanas y ordenamiento por fecha (desc)
CREATE INDEX IF NOT EXISTS idx_pvc_central_combustible_unidad_fecha
  ON public.precios_vinculantes_combustibles (id_central_generacion, id_combustible, id_unidad_medida, fecha DESC);

-- Índice para auditoría (consultas por id_precio_vinculante_combustible)
CREATE INDEX IF NOT EXISTS idx_audit_idprecio_fecha
  ON public.audit_precios_vinculantes_combustibles (id_precio_vinculante_combustible, fecha_cambio DESC);

-- 4) Materialized views sugeridas (plantilla)
-- Si las vistas (ej. vw_comparativo_mensual) son costosas, materialícelas
-- y programe REFRESH periódicos.

-- Ejemplo: materializar el comparativo mensual
CREATE MATERIALIZED VIEW IF NOT EXISTS reporting.mv_comparativo_mensual
AS
  SELECT * FROM public.vw_comparativo_mensual
WITH NO DATA;

-- Índice útil sobre la materialized view para consultas por año/mes
CREATE INDEX IF NOT EXISTS idx_mv_comp_ano_mes
  ON reporting.mv_comparativo_mensual (anio, mes);

-- Ejemplo: materializar reporte por central (por año-mes)
CREATE MATERIALIZED VIEW IF NOT EXISTS reporting.mv_reporte_precios_por_central_ano_mes
AS
  SELECT * FROM reporting.vw_reporte_precios_por_central_ano_mes
WITH NO DATA;

CREATE INDEX IF NOT EXISTS idx_mv_rep_central_ano_mes
  ON reporting.mv_reporte_precios_por_central_ano_mes (id_central_generacion, ano, mes);

-- 5) Refrescar materialized views (comandos de ejemplo)
-- REFRESH MATERIALIZED VIEW reporting.mv_comparativo_mensual;
-- REFRESH MATERIALIZED VIEW reporting.mv_reporte_precios_por_central_ano_mes;
-- Para refresco sin bloquear lecturas: use CONCURRENTLY si crea índices únicos
-- y su versión de PG lo soporta: REFRESH MATERIALIZED VIEW CONCURRENTLY <mv>;

-- 6) Sugerencias de operación
-- - Programar REFRESH nightly (ej. a la madrugada) mediante pg_cron o job externo.
-- - Monitorizar tiempo/locks tras aplicar índices en tablas grandes.
-- - Validar impacto en backups y replicación.

-- Fin del script de sugerencias.
