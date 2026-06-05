Análisis y homologación de `detalle_suministro_combustibles`
==============================================================

Este directorio contiene la definición de la tabla de hechos `public.fact_precio_vinculante`.
Su propósito es almacenar precios vinculantes de combustible con referencia a combustible y
región, fechas de vigencia y metadatos de origen.

Estructura de archivos
----------------------
- `00_functions.sql`  → funciones relacionadas con el modelo.
- `01_table.sql`      → definición de la tabla de hechos.
- `02_constraints.sql` → claves primarias, foráneas y checks.
- `03_indexes.sql`   → índices sugeridos para consultas.
- `04_triggers.sql`  → triggers de negocio y auditoría.
- `05_comments.sql`  → comentarios de tabla y columnas.
- `06_seeds.sql`     → datos de semilla o pruebas.

Comparación con `precios_vinculantes_combustibles`
--------------------------------------------------
- `precios_vinculantes_combustibles` es un conjunto de objetos enfocado en reporting,
  con una tabla de hechos (`public.precios_vinculantes_combustibles`) y vistas de reporte
  en `reporting.*`.
- `detalle_suministro_combustibles` define un modelo dimensional más clásico:
  una tabla de hechos (`fact_precio_vinculante`) y dimensiones (`dim_combustible`,
  `dim_region`).
- Ambos modelos comparten la misma información de negocio: precio de combustible,
  fuente, fecha y metadatos de carga, pero `detalle_suministro_combustibles`
  usa rango de vigencia y esquema de dimensiones en lugar de clave única por fecha.

Lógica del script
-----------------
- Tabla: `public.fact_precio_vinculante`
- Clave primaria: `id_precio_vinculante` (UUID generado automáticamente)
- Dimensiones referenciadas:
  - `public.dim_combustible`
  - `public.dim_region`
- Campos de vigencia:
  - `fecha_inicio_vigencia`
  - `fecha_fin_vigencia`
- Precio nominal:
  - `precio_vinculante` con precisión `NUMERIC(14,6)`
- Metadatos:
  - `moneda`, `fuente`, `documento_referencia`
  - `observaciones`, `archivo_origen`
  - `fecha_carga`, `usuario_carga`
- Control de estado:
  - `activo` booleano, por defecto `TRUE`
- Validación:
  - `CHECK (fecha_fin_vigencia >= fecha_inicio_vigencia)`

Homologación recomendada
------------------------
1. Unificar esquemas de maestro de datos.
   - Si el proyecto usa `datos_maestros.*`, valorar mover o renombrar las dimensiones
     `dim_combustible` y `dim_region` al esquema `datos_maestros`.
2. Homologar nombres de columnas.
   - `activo` puede alinearse con `es_activo` usado en `precios_vinculantes_combustibles`.
   - `precio_vinculante` podría coincidir con `precio_vinculante_combustibles` para mayor
     consistencia.
3. Añadir vistas de reporting.
   - Crear vistas en `reporting.*` similares a `vw_precios_vigentes`,
     `vw_comparativo_mensual`, `vw_reporte_mensual_por_central`, etc.
   - Por ejemplo, una vista de precios vigentes usando `fecha_fin_vigencia >= current_date`.
4. Añadir índices.
   - Recomendado: `activo`, `id_combustible`, `id_region`, `fecha_inicio_vigencia`,
     `fecha_fin_vigencia`.
5. Documentar el modelo.
   - Este README deja claro que la carpeta es un modelo de hechos dimensional,
     no una colección de vistas.

Siguientes pasos
----------------
- Revisar si la tabla `fact_precio_vinculante` será la fuente principal de los reportes
  de precios vinculantes o si se debe mantener junto a `public.precios_vinculantes_combustibles`.
- Si se decide homologar totalmente, crear un conjunto paralelo de vistas en
  `supabase/reporting` para exponer este modelo de hechos a la capa de BI.
- Validar si `dim_region` y `dim_combustible` tienen datos equivalentes a los catálogos
  `datos_maestros.cat_*` usados por los reportes actuales.
