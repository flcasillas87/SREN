# Tabla: precios_vinculantes_combustibles

Módulo para el registro y auditoría de precios vinculantes de combustibles.

## Objetivo
Controlar precios habilitados por fecha, combustible, unidad de medida y central de generación, con auditoría de cambios y restricciones de edición histórica.

## Estructura del módulo
- `00_functions.sql`: funciones de negocio usadas por triggers.
- `01_table.sql`: definición de tablas principales (`precios_vinculantes_combustibles` y `audit_precios_vinculantes_combustibles`).
- `02_constraints.sql`: constraints de integridad relacional y unicidad para este módulo.
- `03_indexes.sql`: índices de consulta y filtros.
- `04_triggers.sql`: triggers de validación, auditoría y actualización de `updated_at`.
- `05_comments.sql`: comentarios `COMMENT ON` para tablas y columnas.
- `06_seeds.sql`: datos semilla controlados.
- `07_view.sql`: vista de consumo basada en `reporting.vw_precios_vinculantes_combustibles`.
- `logs.sql`: espacio para scripts de seguimiento adicionales.

## Tablas principales
- `public.precios_vinculantes_combustibles`
  - Almacena precios vinculantes por fecha, combustible y central.
  - Mantiene control de auditoría, estatus y origen de carga.
- `public.audit_precios_vinculantes_combustibles`
  - Registra cambios de precio cuando el valor de `precio_vinculante_combustibles` se modifica.

## Reglas de negocio
- Restricción de unicidad: un solo precio por combinación `fecha + id_combustible + id_central_generacion`.
- Inmutabilidad limitada: registros con `fecha` anteriores a 7 días no pueden actualizarse ni eliminarse.
- Auditoría automática: cambios de precio generan registros en la tabla de auditoría.
- `updated_at` se actualiza automáticamente en cada actualización del registro.

## Dependencias
- `datos_maestros.cat_combustibles`
- `datos_maestros.cat_unidades_medida`
- `datos_maestros.cat_centrales_generacion`
- `auth.users`
- `reporting.vw_precios_vinculantes_combustibles`
- Función compartida `public.set_updated_at_mx()` definida en `supabase/shared/functions/fn_shared.sql`

## Orden de despliegue recomendado
1. `00_functions.sql`
2. `01_table.sql`
3. `02_constraints.sql`
4. `03_indexes.sql`
5. `04_triggers.sql`
6. `05_comments.sql`
7. `06_seeds.sql`
8. `07_view.sql`

## Notas
- `06_seeds.sql` no incluye datos semilla por dependencia de catálogos externos.
- `logs.sql` se mantiene como archivo de soporte para scripts adicionales de auditoría o migración.
