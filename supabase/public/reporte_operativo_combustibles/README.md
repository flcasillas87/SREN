Reporte operativo por combustible y central generadora
======================================================

Este directorio define el modelo `public.reporte_operativo` para reportar la entrega
operativa de combustible a cada central generadora.

Estructura de archivos
----------------------
- `00_functions.sql`  → funciones de negocio y validaciones.
- `01_table.sql`      → definición de la tabla de hechos.
- `02_constraints.sql` → claves primarias, foráneas y checks.
- `03_indexes.sql`   → índices recomendados.
- `04_triggers.sql`  → triggers de actualización y lógica de integridad.
- `05_comments.sql`  → comentarios de tabla y columnas.
- `06_seeds.sql`     → datos de ejemplo para pruebas.
- `07_view.sql`      → vista de reporting unificada para BI.

Propósito
---------
El modelo registra entregas de combustible por central generadora y tipo de
combustible, permitiendo construir reportes operativos de volumen, costos e
información de origen.

Consideraciones de homologación
--------------------------------
- Usa `datos_maestros.cat_*` para enriquecer la vista de reporting con nombres.
- Sigue la estructura modular de `precios_vinculantes_combustibles` y
  `detalle_suministro_combustibles`.
- La vista `reporting.vw_reporte_operativo_combustible` expone datos listos para
  consumo de BI.

Siguientes pasos
----------------
- Validar si la métrica `importe` debe guardarse o calcularse en la vista.
- Ajustar el campo `precio_unitario` según el modelo real de suministro.
- Agregar datos de semilla reales en `06_seeds.sql`.
- Asegurarse de que los catálogos en `datos_maestros.cat_centrales_generacion`,
  `datos_maestros.cat_combustibles` y `datos_maestros.cat_unidades_medida`
  existan antes de ejecutar el seed.
- Añadir triggers y funciones de auditoría cuando la carga tenga reglas de
  negocio adicionales.
