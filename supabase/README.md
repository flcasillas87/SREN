
# Base de Datos
**CFE Región Norte · Supabase / PostgreSQL 15+**

---

## Contenido

1. [Contexto y objetivo](#1-contexto-y-objetivo)
2. [Arquitectura general](#2-arquitectura-general)
3. [Convenciones del esquema](#3-convenciones-del-esquema)
4. [Tablas preexistentes](#4-tablas-preexistentes)
5. [Catálogos nuevos — esquema `datos_maestros`](#5-catálogos-nuevos--esquema-datos_maestros)
6. [Tabla maestra — `public.factura_pago`](#6-tabla-maestra--publicfactura_pago)
7. [Tablas de concepto — esquema `public`](#7-tablas-de-concepto--esquema-public)
8. [Vistas](#8-vistas)
9. [Índices](#9-índices)
10. [Relaciones entre tablas](#10-relaciones-entre-tablas)
11. [Orden de ejecución del DDL](#11-orden-de-ejecución-del-ddl)
12. [Fórmulas de cálculo](#12-fórmulas-de-cálculo)
13. [Decisiones de diseño](#13-decisiones-de-diseño)

---

## 1. Contexto y objetivo

Este esquema soporta el registro, validación y conciliación de los pagos que realiza **CFE Región Norte** por el servicio de transporte de gas natural

La base de datos reemplaza un control en hoja de cálculo Excel donde todos los conceptos de pago convivían en una sola tabla plana. El diseño los separa en tablas especializadas para:

- Facilitar el cálculo y la validación de cada concepto con su propia fórmula.
- Permitir auditoría y conciliación cruzando el importe facturado contra el importe calculado por fórmula.
- Generar reportes por contrato, periodo y concepto de forma independiente.
- Integrar con SAP mediante los números de documento de pasivo y pago.

---

## 2. Arquitectura general

```
datos_maestros                         public
──────────────────────────────         ──────────────────────────────────────────
cat_proveedores          ◄──────────── cat_contratos_transporte
cat_monedas              ◄──┐                    │
cat_unidades_medida      ◄──┼──┐                 │ FK
cat_centros_gestores     ◄──┼──┼────────── factura_pago  (tabla maestra)
cat_contratos_transporte ◄──┘  │                 │
                               │          ┌──────┼──────┬──────────┐
                               │          │      │      │          │
                               └──── cargo_fijo  │  cargo_variable │
                                         cargo_interconexion   penalizacion
                                                           (1:N)
                                    ─────────────────────────────────────
                                    v_resumen_factura
                                    v_diferencias_conciliacion
```

Cada factura registrada en `factura_pago` tiene exactamente **un registro** en la tabla de concepto que le corresponde (cargo fijo, cargo variable o interconexión), o **uno o más** en `penalizacion`. Esto se garantiza mediante la restricción `UNIQUE (id_factura)` en las tablas 1:1 y `UNIQUE (id_factura, num_linea)` en penalizaciones.

### Estructura

├── 00_bootstrap/        # Base técnica del sistema
├── 01_catalogos/        # Datos maestros
├── 02_operacion/        # Datos transaccionales
├── 03_shared/           # Componentes reutilizables
├── 04_security/         # Seguridad y accesos
├── 05_seeds_global/     # Cargas controladas
├── deploy/              # Orquestación de despliegues

---

## 3. Convenciones del esquema

| Aspecto | Convención |
|---|---|
| Primary keys (catálogos) | `UUID` con `extensions.uuid_generate_v4()` |
| Primary keys (tablas operativas) | `UUID` con `extensions.uuid_generate_v4()` |
| Nombres de tablas | `snake_case`, prefijo `cat_` en catálogos |
| Nombres de columnas | `snake_case` |
| Timestamps (catálogos) | `timestamptz` con `default now()` |
| Timestamps (tablas operativas) | `timestamp` con `default (now() at time zone 'America/Monterrey')` |
| Trigger `updated_at` | `BEFORE UPDATE FOR EACH ROW EXECUTE FUNCTION fn_update_at_mx()` |
| Tablespace | `pg_default` explícito en todas las tablas e índices |
| Montos | `numeric(18,6)` para importes, `numeric(10,6)` para tipos de cambio |
| Volúmenes / tarifas | `numeric(18,4)` para GJ, `numeric(18,6)` para tarifas |
| Columnas generadas | `GENERATED ALWAYS AS (...) STORED` para cálculos derivados |

---

## 4. Tablas preexistentes

Estas tablas ya existen en Supabase y **no se recrean**. El DDL nuevo las referencia mediante `FOREIGN KEY`.

### `datos_maestros.cat_proveedores`

Operadores de gasoductos (Valia Energía, NET Mexico Pipeline, etc.).

| Columna | Tipo | Notas |
|---|---|---|
| `id_proveedor` | `uuid` PK | `uuid_generate_v4()` |
| `razon_social` | `text` | UNIQUE |
| `rfc` | `text` | UNIQUE, nullable |
| `email` | `text` | nullable |
| `created_at` | `timestamptz` | |
| `updated_at` | `timestamptz` | trigger `tr_u_cat_proveedores` |

---

### `datos_maestros.cat_monedas`

Catálogo de monedas. Usado como FK en `factura_pago` y `cat_contratos_transporte`.

| Columna | Tipo | Notas |
|---|---|---|
| `codigo` | `varchar(5)` PK | p.ej. `'USD'`, `'MXN'` |
| `descripcion` | `text` | |

---

### `datos_maestros.cat_unidades_medida`

Unidades energéticas con factor de conversión a MMBTU. Referenciada en todas las tablas de concepto.

| Columna | Tipo | Notas |
|---|---|---|
| `id_unidad_medida` | `serial` PK | |
| `codigo` | `varchar(20)` | UNIQUE, índice normalizado upper/trim |
| `descripcion` | `text` | nullable |
| `factor_conversion_mbtu` | `numeric(15,8)` | |
| `id_combustible` | `integer` | índice btree |
| `es_activo` | `boolean` | índice parcial `where es_activo = true` |
| `created_at` / `updated_at` | `timestamp` | zona America/Monterrey |

---

### `datos_maestros.cat_contratos_transporte`

Contratos de transporte activos con sus parámetros tarifarios base.

| Columna | Tipo | Notas |
|---|---|---|
| `id_contrato` | `uuid` PK | |
| `id_proveedor` | `uuid` FK | → `cat_proveedores` |
| `moneda_tarifa` | `varchar(5)` FK | → `cat_monedas` |
| `id_unidad_medida` | `integer` FK | → `cat_unidades_medida` |
| `plurianual` | `text` | |
| `nombre_contrato` | `text` | UNIQUE |
| `sistema_transporte` | `text` | nombre del gasoducto |
| `capacidad_reservada_diaria` | `numeric(18,4)` | GJ/día contratados |
| `tarifa_reservacion` | `numeric(18,6)` | tarifa de capacidad |
| `tarifa_uso` | `numeric(18,6)` | tarifa volumétrica, default 0 |
| `fecha_inicio` / `fecha_fin` | `date` | vigencia del contrato |
| `activo` | `boolean` | default `true` |

> **Nota:** Las tarifas en `cat_contratos_transporte` son los valores base del contrato. En las tablas `cargo_fijo` y `cargo_variable` se registran las tarifas vigentes al momento de la facturación para preservar trazabilidad histórica ante ajustes USPPI u otras modificaciones.

---

## 5. Catálogos nuevos — esquema `datos_maestros`

### `datos_maestros.cat_centros_gestores`

Unidades presupuestales SAP (centros gestores) con sus claves contables.

| Columna | Tipo | Notas |
|---|---|---|
| `id_centro_gestor` | `uuid` PK | `uuid_generate_v4()` |
| `codigo` | `varchar(20)` | UNIQUE |
| `nombre` | `text` | nombre completo de la unidad |
| `sociedad` | `varchar(10)` | código de sociedad SAP, p.ej. `'1000'` |
| `pos_pre` | `varchar(20)` | posición presupuestal |
| `cuenta_contable` | `varchar(20)` | |
| `fondo` | `varchar(20)` | |
| `activo` | `boolean` | default `true` |
| `created_at` / `updated_at` | `timestamptz` | trigger `tr_u_cat_centros_gestores` |

**Índices:** índice parcial en `activo = true`.

---

## 6. Tabla maestra — `public.factura_pago`

Registro completo del ciclo de vida de cada factura de servicio de transporte. Es la tabla central del esquema; todas las tablas de concepto la referencian.

### Grupos de columnas

**Relaciones**

| Columna | Tipo | Referencia |
|---|---|---|
| `id_contrato` | `uuid` FK | `cat_contratos_transporte` |
| `id_centro_gestor` | `uuid` FK | `cat_centros_gestores` |
| `moneda` | `varchar(5)` FK | `cat_monedas` |

**Identificación temporal**

| Columna | Tipo | Notas |
|---|---|---|
| `anio_pago` / `anio_servicio` | `smallint` | año fiscal / año del servicio prestado |
| `periodo_pago` / `periodo_servicio` | `smallint` | mes 1–12, con `CHECK` |
| `mes` | `varchar(20)` | nombre del mes, solo para display |

**Datos de factura**

| Columna | Tipo | Notas |
|---|---|---|
| `numero_factura` | `varchar(60)` | UNIQUE por contrato |
| `fecha_factura` | `date` | |
| `oficio_pago` | `varchar(60)` | número de oficio CFE |
| `clave` | `varchar(60)` | clave interna |
| `estimado` | `boolean` | `true` si es importe estimado pendiente de factura definitiva |
| `validacion` | `varchar(100)` | estatus de validación |

**Importes**

| Columna | Tipo | Notas |
|---|---|---|
| `importe` | `numeric(18,6)` | importe antes de IVA, `CHECK >= 0` |
| `iva` | `numeric(18,6)` | default 0 (servicio puede ser exento) |
| `total` | `numeric(18,6)` | **columna generada**: `importe + iva` |

**Pasivo SAP** (registro en módulo de cuentas por pagar)

| Columna | Tipo | Notas |
|---|---|---|
| `numero_doc_pasivo` | `varchar(20)` | número de documento SAP |
| `fecha_pasivo` | `date` | |
| `importe_pasivo` / `iva_pasivo` / `total_pasivo` | `numeric(18,6)` | importes al momento del registro |
| `tc_pasivo` | `numeric(10,6)` | tipo de cambio USD/MXN al registrar pasivo |

**Pago SAP**

| Columna | Tipo | Notas |
|---|---|---|
| `numero_doc_pago` | `varchar(20)` | número de documento SAP |
| `fecha_pago` | `date` | |
| `importe_pago` / `iva_pago` / `total_pago` | `numeric(18,6)` | importes al momento del pago |
| `tc_pago` | `numeric(10,6)` | tipo de cambio USD/MXN al pagar |

**Control y divisas**

| Columna | Tipo | Notas |
|---|---|---|
| `numero_doc_aux` | `varchar(20)` | documento auxiliar SAP |
| `reviso` | `varchar(100)` | nombre/clave del revisor |
| `pct_impuestos` | `numeric(6,4)` | fracción de impuestos aplicada, p.ej. `0.16` |
| `participacion_impuestos` | `numeric(6,4)` | participación de impuestos especiales |
| `doc_pago_usd` | `varchar(20)` | documento de pago en USD |
| `pagadero_usd` | `numeric(18,6)` | monto pagadero en USD |
| `pago_pesos_usd` | `numeric(18,6)` | conversión a pesos (origen USD) |
| `pago_pesos_mxn` | `numeric(18,6)` | pago en pesos de origen MXN |

**Índices en `factura_pago`**

| Índice | Columnas | Uso principal |
|---|---|---|
| `idx_fp_contrato` | `id_contrato` | filtrar por proveedor/contrato |
| `idx_fp_periodo_servicio` | `anio_servicio, periodo_servicio` | reportes mensuales |
| `idx_fp_fecha_pago` | `fecha_pago` | consultas por fecha de pago |
| `idx_fp_numero_factura` | `numero_factura` | búsqueda de factura específica |
| `idx_fp_centro_gestor` | `id_centro_gestor` | filtrar por unidad presupuestal |

---

## 7. Tablas de concepto — esquema `public`

Cada tabla almacena los parámetros propios de su fórmula de cálculo. La columna `importe_calculado` permite cruzar el resultado teórico contra el importe facturado en `factura_pago`.

---

### 7.1 `public.cargo_fijo`

Cargo por reserva de capacidad. Relación **1:1** con `factura_pago`.

**Fórmula:**
```
importe = reserva_diaria_gj × tarifa × dias_periodo
```

| Columna | Tipo | Notas |
|---|---|---|
| `id_cargo_fijo` | `uuid` PK | |
| `id_factura` | `uuid` FK UNIQUE | → `factura_pago`, CASCADE DELETE |
| `reserva_capacidad_gj` | `numeric(18,4)` | reserva total contratada (referencia) |
| `reserva_diaria_gj` | `numeric(18,4)` | **base del cálculo**, `CHECK > 0` |
| `dias_periodo` | `smallint` | días del mes de servicio, `CHECK 1–31` |
| `tarifa` | `numeric(18,6)` | tarifa vigente al momento de la factura, `CHECK > 0` |
| `id_unidad_medida` | `integer` FK | → `cat_unidades_medida` |
| `usppi_o` | `numeric(10,6)` | USPPIo: índice base del contrato |
| `usppi_m` | `numeric(10,6)` | USPPIm: índice del mes facturado |
| `factor_usppi` | `numeric(10,8)` | **generada**: `usppi_m / usppi_o` |
| `importe_calculado` | `numeric(18,6)` | **generada**: `reserva_diaria_gj × tarifa × dias_periodo` |
| `conciliado` | `boolean` | `true` cuando el importe fue verificado |
| `diferencia_importe` | `numeric(18,6)` | llenado por el proceso de conciliación |
| `notas` | `text` | observaciones libres |

> El ajuste USPPI se aplica sobre la tarifa base del contrato. El campo `tarifa` en esta tabla debe ya incluir el ajuste (`tarifa_contrato × factor_usppi`) para que `importe_calculado` sea directamente comparable con el importe facturado.

---

### 7.2 `public.cargo_variable`

Cargo por volumen realmente transportado. Relación **1:1** con `factura_pago`.

**Fórmula:**
```
importe = volumen_real_gj × tarifa_variable
```

| Columna | Tipo | Notas |
|---|---|---|
| `id_cargo_variable` | `uuid` PK | |
| `id_factura` | `uuid` FK UNIQUE | → `factura_pago`, CASCADE DELETE |
| `volumen_real_gj` | `numeric(18,4)` | GJ realmente transportados, `CHECK >= 0` |
| `flujo_promedio_gj` | `numeric(18,4)` | flujo promedio diario (auditoría) |
| `volumen_mensual_gj` | `numeric(18,4)` | total del mes (referencia cruzada) |
| `tarifa_variable` | `numeric(18,6)` | tarifa USD/GJ vigente, `CHECK > 0` |
| `id_unidad_medida` | `integer` FK | → `cat_unidades_medida` |
| `usppi_o` / `usppi_m` | `numeric(10,6)` | índices USPPI |
| `factor_usppi` | `numeric(10,8)` | **generada**: `usppi_m / usppi_o` |
| `importe_calculado` | `numeric(18,6)` | **generada**: `volumen_real_gj × tarifa_variable` |
| `conciliado` | `boolean` | |
| `diferencia_importe` | `numeric(18,6)` | |
| `notas` | `text` | |

---

### 7.3 `public.cargo_interconexion`

Cargos derivados de los acuerdos de interconexión en la frontera México–EE.UU. Relación **1:1** con `factura_pago`.

La fórmula varía por contrato y punto de interconexión, por lo que `importe_calculado` no es una columna generada automáticamente sino que se llena mediante proceso externo o manualmente.

| Columna | Tipo | Notas |
|---|---|---|
| `id_interconexion` | `uuid` PK | |
| `id_factura` | `uuid` FK UNIQUE | → `factura_pago`, CASCADE DELETE |
| `punto_interconexion` | `varchar(200)` | p.ej. `'Reynosa–McAllen'` |
| `operador_frontera` | `varchar(200)` | operador lado EE.UU. |
| `cruce_fronterizo` | `varchar(200)` | nombre del cruce físico |
| `estado_frontera` | `varchar(100)` | estado/ciudad fronteriza |
| `capacidad_contratada_gj` | `numeric(18,4)` | GJ/día contratados en el punto |
| `volumen_interconexion_gj` | `numeric(18,4)` | volumen realmente cursado |
| `tarifa_interconexion` | `numeric(18,6)` | tarifa específica del punto |
| `dias_periodo` | `smallint` | |
| `id_unidad_medida` | `integer` FK | → `cat_unidades_medida` |
| `tipo_cargo` | `varchar(20)` | `'CAPACIDAD'` \| `'VOLUMETRICO'` \| `'MIXTO'` |
| `base_calculo` | `text` | descripción textual de la fórmula contractual |
| `importe_calculado` | `numeric(18,6)` | llenado manualmente o por proceso externo |
| `conciliado` | `boolean` | |
| `diferencia_importe` | `numeric(18,6)` | |
| `notas` | `text` | |

---

### 7.4 `public.penalizacion`

Penalizaciones por desbalanceo o incumplimiento de nominaciones. Relación **1:N** con `factura_pago` — una factura puede contener múltiples líneas de penalización del mismo periodo.

**Fórmula:**
```
importe = volumen_desbalance_gj × factor_penalizacion × COALESCE(precio_referencia, tarifa_base, 0)
```

| Columna | Tipo | Notas |
|---|---|---|
| `id_penalizacion` | `uuid` PK | |
| `id_factura` | `uuid` FK | → `factura_pago`, CASCADE DELETE |
| `num_linea` | `smallint` | orden dentro de la factura, UNIQUE con `id_factura` |
| `tipo_penalizacion` | `varchar(100)` | p.ej. `'DESBALANCE_DIARIO'`, `'EXCESO_CAPACIDAD'` |
| `descripcion_causa` | `text` | descripción libre de la causa |
| `referencia_cre` | `varchar(100)` | disposición CRE/CENAGAS aplicable |
| `periodo_penalizado` | `date` | fecha exacta del desbalance |
| `volumen_desbalance_gj` | `numeric(18,4)` | GJ en desequilibrio, `CHECK >= 0` |
| `factor_penalizacion` | `numeric(10,6)` | multiplicador, p.ej. `1.10` = 110%, `CHECK > 0` |
| `precio_referencia` | `numeric(18,6)` | precio spot o índice de referencia |
| `tarifa_base` | `numeric(18,6)` | tarifa normal del servicio (fallback) |
| `id_unidad_medida` | `integer` FK | → `cat_unidades_medida` |
| `importe_calculado` | `numeric(18,6)` | **generada**: `vol × factor × COALESCE(precio_ref, tarifa_base, 0)` |
| `conciliado` | `boolean` | |
| `diferencia_importe` | `numeric(18,6)` | |
| `notas` | `text` | |

---

## 8. Vistas

### `public.v_resumen_factura`

Vista de uso general para reportes y auditoría. Une `factura_pago` con sus catálogos y los cuatro conceptos de cargo mediante `LEFT JOIN`.

**Columnas clave de salida:**

| Columna | Descripción |
|---|---|
| `proveedor` | Razón social del operador |
| `nombre_contrato` | Nombre del contrato SAP |
| `sistema_transporte` | Nombre del gasoducto |
| `concepto_pago` | `'CARGO FIJO'` \| `'CARGO VARIABLE'` \| `'INTERCONEXIÓN'` \| `'PENALIZACIÓN'` \| `'SIN CLASIFICAR'` |
| `calc_cargo_fijo` / `calc_cargo_variable` / etc. | Importe calculado por fórmula para cruce |
| `conciliado` | `true` si el concepto ya fue validado |

> Para facturas con múltiples líneas de penalización, la vista toma solo `num_linea = 1`. Para el detalle completo de penalizaciones usar directamente `public.penalizacion`.

---

### `public.v_diferencias_conciliacion`

Lista las facturas donde el importe facturado difiere del importe calculado por fórmula en más de **$0.01** (tolerancia de un centavo). Ordenada por valor absoluto de la diferencia descendente.

**Columnas:**

| Columna | Descripción |
|---|---|
| `importe_facturado` | `factura_pago.importe` |
| `importe_calculado` | `COALESCE` de los cuatro conceptos |
| `diferencia` | `importe_facturado − importe_calculado` |

Diferencias positivas indican que el proveedor cobró más de lo calculado; negativas, que cobró menos.

---

## 9. Índices

| Índice | Tabla | Columnas | Tipo |
|---|---|---|---|
| `idx_fp_contrato` | `factura_pago` | `id_contrato` | btree |
| `idx_fp_periodo_servicio` | `factura_pago` | `anio_servicio, periodo_servicio` | btree |
| `idx_fp_fecha_pago` | `factura_pago` | `fecha_pago` | btree |
| `idx_fp_numero_factura` | `factura_pago` | `numero_factura` | btree |
| `idx_fp_centro_gestor` | `factura_pago` | `id_centro_gestor` | btree |
| `idx_cf_factura` | `cargo_fijo` | `id_factura` | btree |
| `idx_cv_factura` | `cargo_variable` | `id_factura` | btree |
| `idx_ci_factura` | `cargo_interconexion` | `id_factura` | btree |
| `idx_pen_factura` | `penalizacion` | `id_factura` | btree |
| `idx_pen_periodo` | `penalizacion` | `periodo_penalizado` | btree |
| `idx_cat_centros_gestores_activo` | `cat_centros_gestores` | `activo` | btree parcial (`activo = true`) |

---

## 10. Relaciones entre tablas

```
datos_maestros.cat_proveedores (1)
    └──< datos_maestros.cat_contratos_transporte (N)
              │   FK: id_proveedor
              │
              └──< public.factura_pago (N)
                        │   FK: id_contrato
                        │   FK: id_centro_gestor → cat_centros_gestores
                        │   FK: moneda           → cat_monedas
                        │
                        ├──── public.cargo_fijo          (1:1, CASCADE DELETE)
                        ├──── public.cargo_variable      (1:1, CASCADE DELETE)
                        ├──── public.cargo_interconexion (1:1, CASCADE DELETE)
                        └──── public.penalizacion        (1:N, CASCADE DELETE)
                                        │
                                        └── FK: id_unidad_medida → cat_unidades_medida
```

**`ON DELETE CASCADE`** en las tablas de concepto: si se elimina una factura de `factura_pago`, se eliminan automáticamente todos sus registros de cargo asociados.

---

## 11. Orden de ejecución del DDL

Ejecutar en este orden en el SQL Editor de Supabase para respetar dependencias de foreign keys:

```
1.  datos_maestros.cat_centros_gestores       ← nuevo catálogo
2.  public.factura_pago                       ← tabla maestra
3.  public.cargo_fijo                         ← concepto 1
4.  public.cargo_variable                     ← concepto 2
5.  public.cargo_interconexion                ← concepto 3
6.  public.penalizacion                       ← concepto 4
7.  public.v_resumen_factura                  ← vista de reportes
8.  public.v_diferencias_conciliacion         ← vista de auditoría
```

**No volver a crear** (ya existen en Supabase):
- `datos_maestros.cat_proveedores`
- `datos_maestros.cat_monedas`
- `datos_maestros.cat_unidades_medida`
- `datos_maestros.cat_contratos_transporte`

---

## 12. Fórmulas de cálculo

| Concepto | Fórmula | Columna generada |
|---|---|---|
| Cargo fijo | `reserva_diaria_gj × tarifa × dias_periodo` | `cargo_fijo.importe_calculado` |
| Factor USPPI | `usppi_m / usppi_o` | `cargo_fijo.factor_usppi` y `cargo_variable.factor_usppi` |
| Cargo variable | `volumen_real_gj × tarifa_variable` | `cargo_variable.importe_calculado` |
| Penalización | `volumen_desbalance_gj × factor_penalizacion × COALESCE(precio_referencia, tarifa_base, 0)` | `penalizacion.importe_calculado` |
| Total factura | `importe + iva` | `factura_pago.total` |
| Interconexión | Fórmula contractual variable | **manual** / proceso externo |

> Las columnas generadas (`GENERATED ALWAYS AS ... STORED`) son calculadas y actualizadas automáticamente por PostgreSQL cuando cambia cualquier columna que participa en la expresión. No requieren llenado manual.

---

## 13. Decisiones de diseño

**Separación en tablas por concepto en lugar de una columna discriminadora.**
Cada concepto tiene parámetros de cálculo distintos e incompatibles. Una tabla única con columnas `nullable` para cada concepto genera filas con 60–70% de valores nulos y hace inviable la validación por columna generada. El modelo elegido es más verboso pero completamente normalizado.

**Trazabilidad histórica de tarifas.**
Las tarifas almacenadas en `cat_contratos_transporte` son los valores vigentes del contrato. Las tablas `cargo_fijo` y `cargo_variable` guardan la tarifa aplicada en cada periodo de facturación, independientemente de ajustes posteriores (USPPI, renegociaciones). Esto permite auditar cualquier factura histórica sin depender del valor actual del contrato.

**`cargo_interconexion.importe_calculado` no es columna generada.**
La fórmula de los cargos de interconexión varía por contrato y puede incluir componentes externos (índices de mercado, cargos regulatorios de FERC). No es posible expresarla como una expresión SQL determinista. El campo existe para que el proceso de conciliación lo llene después de calcular externamente.

**Relación 1:N exclusivamente en `penalizacion`.**
Una factura puede agrupar múltiples cargos por desbalanceo de distintos días del mismo periodo. Las otras tres tablas de concepto son siempre 1:1 porque una factura corresponde a un único concepto tarifario.

**`ON DELETE CASCADE` en tablas de concepto.**
Si se elimina una factura (p.ej. por registro duplicado), sus detalles de cargo se eliminan en cascada para mantener integridad referencial sin requerir operaciones manuales adicionales.

**Esquema `datos_maestros` para catálogos, `public` para transaccionales.**
Sigue la convención ya establecida en el proyecto. Facilita la gestión de permisos en Supabase (Row Level Security puede configurarse por esquema) y mantiene separados los datos de configuración de los datos operativos.

---

*Última actualización: abril 2025*
*Motor: Supabase / PostgreSQL 15+ · Esquemas: `datos_maestros`, `public`*
/control-pagos-db
│
├── 📂 supabase/
│   ├── 📂 migrations/              # Para control de versiones (si usas CLI)
│   │   └── 0001_initial_schema.sql
│   │
│   ├── 📂 catalogos/               # TABLAS MAESTRAS (Se cargan primero)
│   │   ├── 01_cat_monedas.sql
│   │   ├── 02_cat_sociedades.sql
│   │   ├── 03_cat_proveedores.sql  
│   │   ├── 04_cat_presupuesto.sql  # (Fondo, Centro Gestor, PosPre)
│   │   └── 05_cat_cuentas.sql
│   │
│   ├── 📂 transacciones/           # TABLA PRINCIPAL (Depende de los catálogos)
│   │   └── 06_diario_documentos_tpl.sql
│   │
│   └── 📂 seed_data/               # PLANTILLAS CSV PARA CARGA
│       ├── monedas.csv
│       ├── proveedores.csv
│       └── diario_operaciones.csv
│
03_public/
├── precios_vinculantes_combustibles/
│   ├── table.sql
│   ├── indexes.sql
│   ├── triggers.sql
│   ├── functions.sql
│   └── views.sql
│
├── suministro_combustibles/
│   ├── table.sql
│   ├── indexes.sql
│   ├── triggers.sql
│   └── views.sql
│
└── _shared/
    ├── functions.sql
    └── triggers.sql
1️⃣ table.sql
2️⃣ functions.sql
3️⃣ triggers.sql
4️⃣ indexes.sql
5️⃣ view_dashboard.sql

#Nomenclatura
##Indices
idx_<tabla>_<columnas>

ej:
idx_precios_vinculantes_fecha_combustible

##triggers
tr_<tabla>_<accion>

ej:
tr_precios_vinculantes_updated
tr_precios_vinculantes_audit

##Funciones
fn_<tabla>_<proposito>
fn_precios_vinculantes_validar_fecha()


-- =====================================================
-- TABLA: public.precios_vinculantes_combustibles
-- OBJETO: INDICES
-- =====================================================
# cat        → Datos maestros (catálogos)

## cat_centrales_generacion

Centrales eléctricas

## cat_centros_gestores

Infraestructura de transporte

## cat_combustibles

Gas natural, diésel, etc.

## cat_contratos_transporte

## cat_cuentas_contables

## cat_estado_operativo

## cat_gasoductos

## cat_lugares_servicio

## cat_monedas

USD, MXN, etc.

## cat_proveedores

## cat_puntos_entrega

## cat_sociedades

Empresas o subsidiarias

## cat_trabajadores

## cat_transportistas

## cat_unidades_medida

## organigrama

Estructura jerárquica

Se cargan seeds.

# stg        → Staging + validaciones + logs
Este es el corazón del sistema.
**    Datos crudos importados (Excel, API, CSV)
    Tablas temporales
    Validaciones
    Logs
    Errores
    Auditoría técnica**


# public     → Datos finales listos para BI / operación
Aquí solo llega información limpia, validada y trazable.
Precios vinculantes finales
Suministros
Pagos
Vistas para Power BI