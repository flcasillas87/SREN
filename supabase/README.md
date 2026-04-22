# Base de Datos
**CFE Región Norte · Supabase / PostgreSQL 15+**

---

## Contenido

1. [Objetivo](#1-objetivo)
2. [Esquemas y criterios](#2-esquemas-y-criterios)
3. [Estructura del repositorio](#3-estructura-del-repositorio)
4. [Estándar de carpetas SQL](#4-estándar-de-carpetas-sql)
5. [Convenciones de modelado](#5-convenciones-de-modelado)
6. [Modelo funcional actual](#6-modelo-funcional-actual)
7. [Vistas para reporteo y Power BI](#7-vistas-para-reporteo-y-power-bi)
8. [Criterios de diseño](#8-criterios-de-diseño)
9. [Pendientes de arquitectura](#9-pendientes-de-arquitectura)

---

## 1. Objetivo

Este repositorio concentra el DDL, seeds, funciones, vistas y procesos auxiliares para administrar información operativa y financiera relacionada con:

- contratos de transporte de gas natural
- documentos contables y pagos
- cargos fijos, variables, de interconexión y penalizaciones
- catálogos maestros para operación, conciliación y analítica

La meta es reemplazar hojas de cálculo y scripts dispersos por una estructura SQL mantenible, reusable y lista para integración con Supabase, ETL y Power BI.

---

## 2. Esquemas y criterios

### `datos_maestros`

Usar este esquema para catálogos y configuraciones relativamente estables.

Ejemplos:

- `cat_monedas`
- `cat_contratos_transporte`
- `cat_unidades_medida`
- `cat_proveedores`
- `cat_centros_gestores`

### `public`

Usar este esquema para tablas operativas y transaccionales finales.

Ejemplos:

- `diario_documentos`
- `diario_pagos`
- `cargo_fijo`
- `cargo_variable`
- `cargo_interconexion`
- `penalizacion`
- tablas finales de precios o detalle operativo

### `staging`

Usar este esquema y sus carpetas asociadas para carga temporal, validación, transformación y limpieza de datos.

Aquí viven:

- tablas intermedias
- cargas desde CSV o Excel
- reglas de validación
- transformaciones previas a la publicación

### `etl`

Usar esta carpeta para scripts de proceso, utilitarios y orquestación técnica.

### `shared`

Usar esta carpeta para funciones y componentes reutilizables por varios módulos.

### `security`

Usar esta carpeta para permisos, roles, RLS y objetos de seguridad.

### Criterio general

- `datos_maestros` = catálogo y referencia
- `public` = dato final operativo
- `staging` = dato temporal o en saneamiento
- `shared` = reutilizable
- `etl` = proceso técnico

---

## 3. Estructura del repositorio

La estructura vigente del proyecto es:

```text
supabase/
├── 00. Init/                  # Bootstrap técnico: schemas, roles, permisos, extensiones
├── data/                      # Archivos fuente y plantillas de carga
├── datos_maestros/            # Catálogos y relaciones maestras
├── etl/                       # Scripts de carga, lectura y procesos auxiliares
├── migrations/                # Migraciones versionadas
├── pipelines/                 # Pipelines orientados a carga/merge por dominio
├── public/                    # Tablas y vistas operativas finales
├── security/                  # Seguridad
├── shared/                    # Funciones y vistas compartidas
├── staging/                   # Staging, validación, normalización y carga intermedia
├── templates/                 # Plantillas de archivos
├── config.toml                # Configuración de Supabase CLI
├── README.md                  # Esta documentación
├── sqlgen.ps1                 # Generador de estructura estándar
└── crear_estructura_sql.ps1   # Generador alterno de estructura
```

---

## 4. Estándar de carpetas SQL

Para tablas maestras y operativas se adoptó el estándar de **7 archivos** por carpeta.

### Estructura base

```text
<modulo>/<tabla>/
├── 01_table.sql
├── 02_constraints.sql
├── 03_indexes.sql
├── 04_triggers.sql
├── 05_comments.sql
├── 06_seeds.sql
└── 07_view.sql
```

### Archivos opcionales adicionales

Cuando un módulo lo requiere, se permiten archivos extra con numeración fuera del set principal:

- `00_functions.sql`
- `00_fn_<proposito>.sql`
- `08_rls_policies.sql`
- `06_seeds_helper.sql`
- `06_seeds_legacy.sql`

### Responsabilidad de cada archivo

| Archivo | Responsabilidad |
|---|---|
| `01_table.sql` | `CREATE TABLE`, columnas y PK mínima |
| `02_constraints.sql` | FKs, UNIQUE, CHECK, constraints adicionales |
| `03_indexes.sql` | índices |
| `04_triggers.sql` | triggers |
| `05_comments.sql` | `COMMENT ON ...` |
| `06_seeds.sql` | seeds controlados |
| `07_view.sql` | vistas de consumo o apoyo |

### Reglas

- No mezclar seeds dentro de `01_table.sql`.
- No mezclar índices dentro de `01_table.sql` si pueden separarse.
- No usar nombres viejos como `01. table.sql`, `03.triggers.sql` o `04.views.sql`.
- Mantener `snake_case` en carpetas, archivos, tablas y columnas.

---

## 5. Convenciones de modelado

| Aspecto | Convención |
|---|---|
| Nombres de tablas | `snake_case` |
| Catálogos | prefijo `cat_` |
| Nombres de columnas | `snake_case` |
| PK operativas | `uuid` con `uuid_generate_v4()` o `gen_random_uuid()` según el módulo |
| PK de catálogos | `uuid`, `serial` o clave natural, según el catálogo |
| Timestamps operativos | `timestamp` con zona `America/Monterrey` |
| Timestamps maestros | seguir el patrón propio del módulo, idealmente consistente por carpeta |
| Trigger de actualización | `public.fn_update_at_mx()` |
| Importes | `numeric(18,2)` o `numeric(18,6)` según precisión requerida |
| Tipos de cambio | `numeric(10,6)` o `numeric(12,6)` |
| Volúmenes | `numeric(18,4)` |
| Tarifas | `numeric(18,6)` |

### Moneda y unidad de medida

Separar siempre:

- moneda de la tarifa o del pago
- unidad física o energética

Esto significa:

- `moneda_*` debe apuntar a `datos_maestros.cat_monedas`
- `id_unidad_medida` debe apuntar a `datos_maestros.cat_unidades_medida`

No mezclar moneda y unidad física en una sola columna o asumir que una tarifa siempre está en USD o siempre en GJ si el modelo ya admite variantes.

---

## 6. Modelo funcional actual

### Catálogos base

Los catálogos principales viven en `datos_maestros`, por ejemplo:

- `cat_monedas`
- `cat_unidades_medida`
- `cat_contratos_transporte`
- `cat_proveedores`
- `cat_centros_gestores`

### Tablas operativas actuales

En `public` se concentran tablas finales como:

- `diario_documentos`
- `diario_pagos`
- `cargo_fijo`
- `cargo_variable`
- `cargo_interconexion`
- `penalizacion`
- `precios_vinculantes_combustibles`

### Sobre los cargos

El modelo preferido para cálculos de servicio es por tablas especializadas:

- `cargo_fijo`
- `cargo_variable`
- `cargo_interconexion`
- `penalizacion`

Este enfoque es preferible a una tabla genérica de detalle con muchas columnas opcionales, porque:

- reduce nulabilidad estructural
- hace más claras las fórmulas por concepto
- mejora conciliación y trazabilidad
- permite separar reglas de negocio por tipo de cargo

### Sobre `diario_documentos` y `diario_pagos`

- `diario_documentos` representa la cabecera o documento operativo-contable
- `diario_pagos` representa el evento financiero del pago

No son tablas duplicadas respecto de `cargo_*`; cumplen funciones distintas.

---

## 7. Vistas para reporteo y Power BI

Las vistas de BI deben usarse como capa de consumo estable para reportes y Power BI.

### Recomendaciones

- exponer vistas en `07_view.sql` por módulo cuando la vista sea local al dominio
- si el volumen de vistas analíticas crece, evaluar un esquema dedicado como `reportes`
- evitar conectar Power BI directamente a tablas transaccionales cuando se requiera semántica más amigable

### Ejemplos actuales o recomendados

- `datos_maestros.vw_cat_monedas`
- `public.vw_diario_pagos`
- vistas de detalle de cargos y conciliación

### Criterios de una buena vista para BI

- nombres de columnas claros
- joins resueltos contra catálogos
- descripciones legibles
- no depender de columnas ambiguas o IDs sin contexto

---

## 8. Criterios de diseño

### Separación por dominios

Cada carpeta debe representar un dominio de negocio claro, no una mezcla de objetos sin relación.

### Separación por responsabilidad

Dentro de cada carpeta, cada archivo debe tener una sola responsabilidad.

### Reutilización

Funciones y utilitarios compartidos deben ir a `shared`, no duplicarse por carpeta.

### Trazabilidad histórica

Los valores aplicados en una operación deben guardarse en la tabla transaccional aunque difieran del valor vigente actual del catálogo o contrato.

### Diseño para conciliación

Las tablas operativas deben permitir comparar:

- monto registrado
- monto calculado
- diferencias
- observaciones de validación

### Diseño para evolución

El repositorio admite módulos con `00_*` y `08_*` cuando hay necesidades adicionales, pero el núcleo siempre debe seguir el estándar `01` a `07`.

---

## 9. Pendientes de arquitectura

Los siguientes puntos siguen siendo relevantes para consolidar el proyecto:

1. definir una ruta única de despliegue entre carpetas SQL, `config.toml` y migraciones
2. homologar tablas que todavía usan enums de moneda con el catálogo `cat_monedas`
3. completar la separación real de contenido en algunas carpetas que hoy ya tienen nombres estándar pero aún conservan lógica mezclada
4. decidir si las vistas analíticas crecerán lo suficiente para moverlas a un esquema dedicado de reportes
5. cerrar el modelo de documento maestro que relaciona contratos, cargos y pagos de forma definitiva

---

*Última actualización: abril 2026*  
*Motor: Supabase / PostgreSQL 15+*  
*Esquemas principales: `datos_maestros`, `public`, `staging`*
