README: Lógica y detalle de los scripts de la carpeta
======================================================

Resumen rápido
--------------
- `vw_precios_vigentes.sql`: precio actual por central/combustible/unidad.
- `vw_precios_detalle.sql`: detalle de todos los precios activos y costo MBTU.
- `vw_reporte_mensual_por_central.sql`: filas diarias para un mes.
- `vw_reporte_precios_por_central.sql`: métricas mensuales agregadas.
- `vw_comparativo_mensual.sql`: comparación mes a mes con variaciones.
- `vw_historico_auditoria.sql`: historial de cambios y variaciones.
- `vw_alertas_vencimiento.sql`: alertas de registros próximos a vencer.

Esta carpeta contiene vistas SQL enfocadas en el reporte de precios vinculantes
por combustible y central de generación. El objetivo es ofrecer diferentes
perspectivas: precios vigentes, reportes mensuales, comparativos de tendencia,
auditoría de cambios y alertas de expiración.

Estructura actual
-----------------
- `vw_precios_vigentes.sql`
- `vw_reporte_mensual_por_central.sql`
- `vw_reporte_precios_por_central.sql`
- `vw_comparativo_mensual.sql`
- `vw_historico_auditoria.sql`
- `vw_alertas_vencimiento.sql`
- `vw_precios_detalle.sql`
- `00_indexes_and_materialized_views.sql`

Resumen de lógica por script
----------------------------

1) `vw_precios_vigentes.sql`
   - Obtiene el precio vinculante más reciente para cada combinación de:
     central de generación + combustible + unidad de medida.
   - Filtra solo los registros activos (`es_activo = true`).
   - Usa `ROW_NUMBER()` particionado por `id_central_generacion`,
     `id_combustible` y `id_unidad_medida`, ordenado por `fecha DESC`.
   - Devuelve solo `rn = 1`, lo que garantiza un precio actual por combinación.
   - Traduce las claves a nombres legibles con `datos_maestros.cat_*`.

2) `vw_precios_detalle.sql`
   - Renombrado desde `07_view.sql` para mayor claridad.
   - Ofrece el detalle de todos los registros activos de
     `public.precios_vinculantes_combustibles`.
   - Calcula el costo en MBTU usando `u.factor_conversion_mbtu`.
   - Ideal para análisis de origen y exportación de datos completos.

3) `vw_reporte_mensual_por_central.sql`
   - Devuelve filas diarias de precios por central para un mes específico.
   - Incluye año, mes, nombre del mes, día, precio, fuente, observaciones y
     metadatos de carga.
   - No agrega o resume datos; es un reporte transaccional listo para Excel.

4) `vw_reporte_precios_por_central.sql`
   - Agrega los precios por central, año y mes.
   - Calcula: cantidad de registros, promedio, mínimo, máximo, total y costo MBTU
     promedio.
   - Usa `round(..., 4)` para normalizar los valores numéricos.
   - Permite comparar desempeño mensual de cada central.

5) `vw_comparativo_mensual.sql`
   - Agrega el precio promedio mensual por combinación de central,
     combustible y unidad de medida.
   - Usa un CTE `precios_mensuales` para calcular el promedio mensual.
   - Aplica `LAG()` por combinación para obtener el precio del mes anterior.
   - Calcula variación absoluta y porcentual entre meses consecutivos.
   - Protege contra divisiones por cero devolviendo `NULL` cuando no hay mes
     anterior.

6) `vw_historico_auditoria.sql`
   - Une la tabla de auditoría `public.audit_precios_vinculantes_combustibles`
     con `public.precios_vinculantes_combustibles` para enriquecer el registro.
   - Muestra fecha del cambio, usuario, observaciones y archivo de origen.
   - Calcula variación absoluta y porcentual entre precio anterior y nuevo.
   - Es la vista principal para trazabilidad de modificaciones de precio.

7) `vw_alertas_vencimiento.sql`
   - Identifica registros activos dentro de la ventana editable de 7 días.
   - Calcula `dias_restantes` hasta que el registro cumpla 7 días desde su
     fecha.
   - Clasifica la urgencia en `CRÍTICO`, `URGENTE` y `VIGENTE`.
   - Filtra solo registros con `fecha >= current_date - interval '7 days'`.
   - Útil para detectar y corregir datos antes de que queden inmutables.

8) `00_indexes_and_materialized_views.sql`
   - Contiene recomendaciones de implementación, no lógica de negocio.
   - Asegura la existencia del esquema `reporting`.
   - Propone wrappers `reporting.*` sobre las vistas existentes en `public`.
   - Sugiere índices sobre:
     - `public.precios_vinculantes_combustibles(es_activo, fecha)`
     - `public.precios_vinculantes_combustibles(id_central_generacion,
       id_combustible, id_unidad_medida, fecha DESC)`
     - `public.audit_precios_vinculantes_combustibles(
       id_precio_vinculante_combustible, fecha_cambio DESC)`
   - Presenta materialized views de ejemplo para `vw_comparativo_mensual` y
     `vw_reporte_precios_por_central_ano_mes` con índices asociados.
   - Incluye comandos de refresco y recomendaciones operativas.

Detalles de diseño y dependencias
---------------------------------
- Todas las vistas usan la tabla de hechos:
  `public.precios_vinculantes_combustibles`.
- Las referencias a datos maestros usan el esquema `datos_maestros`:
  - `datos_maestros.cat_centrales_generacion`
  - `datos_maestros.cat_combustibles`
  - `datos_maestros.cat_unidades_medida`
- Las vistas resultantes se crean en el esquema `reporting`.
- `to_char(..., 'TMMonth')` depende de la localización de la base de datos y
  puede devolver el nombre del mes en el idioma configurado.

Recomendaciones clave
----------------------
- Probar `00_indexes_and_materialized_views.sql` en un entorno de staging.
- Crear índices en la tabla de hechos si el volumen de datos es alto.
- Materializar `vw_comparativo_mensual` y `vw_reporte_precios_por_central_ano_mes`
  si las consultas son frecuentes.
- Revisar la función `check_fecha_vinculante()` y su política de inmutabilidad
  si se usa en producción para `vw_alertas_vencimiento`.
- Mantener nombres de vistas descriptivos y consistentes.

Uso típico
----------
- `vw_precios_vigentes`: precio actual por combinación.
- `vw_precios_detalle`: detalle diario completo.
- `vw_reporte_mensual_por_central`: fila por día para un mes.
- `vw_reporte_precios_por_central`: métricas agregadas por mes.
- `vw_comparativo_mensual`: tendencia mensual y comparación con mes anterior.
- `vw_historico_auditoria`: historial de cambios de precio.
- `vw_alertas_vencimiento`: registros próximos a expirar en la ventana
  editable.
