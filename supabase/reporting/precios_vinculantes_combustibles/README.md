Análisis y acciones aplicadas sobre la carpeta `precios_vinculantes_combustibles`
==========================================================================

Resumen
- Contenido: vistas SQL que exponen datos de `precios_vinculantes_combustibles`
  para usos ejecutivos y reporting (vigente, mensual, comparativos, auditoría,
  alertas y detalle).

Acciones aplicadas
- Renombré `07_view.sql` → `vw_precios_detalle.sql` para un nombre descriptivo.
- Añadí `00_indexes_and_materialized_views.sql` con las recomendaciones
  de índices y materialized views sugeridos (no ejecutados).
- Este README: resume la lógica y explica pasos siguientes recomendados.

Recomendaciones y pasos siguientes
1. Ejecutar el script `00_indexes_and_materialized_views.sql` en un entorno
   de pruebas antes de aplicarlo en producción.
2. Crear índices propuestos para mejorar rendimiento en filtros y ventanas.
3. Materializar vistas pesadas (`vw_comparativo_mensual`,
   `vw_reporte_precios_por_central_ano_mes`) y programar `REFRESH` periódico
   (ej. nightly) mediante `pg_cron` o job externo.
4. Unificar esquema de reporting: usar `reporting.*` para todas las vistas o
   mantener vistas públicas y crear wrappers en `reporting` (incluido en el SQL
   sugerido) para minimizar ruptura de dependencias.
5. Verificar `lc_time` si se requiere siempre `Mes` en español (to_char 'TMMonth'
   depende de la localización del servidor).
6. Validar la función `check_fecha_vinculante()` y la política de inmutabilidad
   mencionada en los comentarios para garantizar que `vw_alertas_vencimiento`
   refleja la lógica esperada.

Notas de seguridad
- Los cambios propuestos crean objetos en la base de datos (índices y
  materialized views). Recomendado probar en staging y revisar locks/influencia
  en ventanas de mantenimiento.

Preguntas abiertas
- ¿Quieres que aplique el SQL de índices y materialized views directamente
  (generando un patch adicional con `CREATE INDEX` y `CREATE MATERIALIZED VIEW`)?
