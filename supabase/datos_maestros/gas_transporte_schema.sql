-- =============================================================================
-- ESQUEMA: Sistema de Pagos - Transporte de Gas Natural (CFE Región Norte)
-- Descripción: Tablas para registro y validación de pagos por servicio de
--              transporte de gas natural, separadas por concepto de cobro.
-- Motor:       PostgreSQL 15+ / MySQL 8+ compatible (ver notas al final)
-- Versión:     1.0
-- =============================================================================

-- =============================================================================
-- TABLAS CATÁLOGO (dimensiones)
-- =============================================================================

CREATE TABLE cat_proveedor (
    id_proveedor        SERIAL          PRIMARY KEY,
    nombre_proveedor    VARCHAR(200)    NOT NULL,
    acreedor_sap        VARCHAR(20)     NOT NULL UNIQUE,
    rfc                 VARCHAR(13),
    pais                VARCHAR(3)      DEFAULT 'MEX',
    moneda_default      CHAR(3)         DEFAULT 'USD',   -- USD | MXN
    activo              BOOLEAN         DEFAULT TRUE,
    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_moneda_default CHECK (moneda_default IN ('USD','MXN'))
);

COMMENT ON TABLE cat_proveedor IS 'Catálogo de proveedores/operadores de gasoductos';

-- ----------------------------------------------------------------------------

CREATE TABLE cat_contrato (
    id_contrato         SERIAL          PRIMARY KEY,
    id_proveedor        INT             NOT NULL REFERENCES cat_proveedor(id_proveedor),
    contrato_sap        VARCHAR(20)     NOT NULL UNIQUE,
    numero_contrato     VARCHAR(60)     NOT NULL,   -- número interno CFE
    descripcion         VARCHAR(300),
    lugar_servicio      VARCHAR(200),               -- p.ej. "CC Río Bravo"
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE,
    plurianual          BOOLEAN         DEFAULT FALSE,
    activo              BOOLEAN         DEFAULT TRUE,
    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fechas_contrato CHECK (fecha_fin IS NULL OR fecha_fin > fecha_inicio)
);

COMMENT ON TABLE cat_contrato IS 'Contratos de transporte de gas natural por proveedor';

-- ----------------------------------------------------------------------------

CREATE TABLE cat_centro_gestor (
    id_centro_gestor    SERIAL          PRIMARY KEY,
    codigo              VARCHAR(20)     NOT NULL UNIQUE,
    nombre              VARCHAR(200)    NOT NULL,
    sociedad            VARCHAR(10),                -- código sociedad SAP
    pos_pre             VARCHAR(20),                -- posición presupuestal
    cuenta_contable     VARCHAR(20),
    fondo               VARCHAR(20),
    activo              BOOLEAN         DEFAULT TRUE
);

COMMENT ON TABLE cat_centro_gestor IS 'Centros gestores SAP (unidades presupuestales)';

-- =============================================================================
-- TABLA MAESTRA DE FACTURAS / PAGOS
-- =============================================================================

CREATE TABLE factura_pago (
    id_factura          SERIAL          PRIMARY KEY,
    id_contrato         INT             NOT NULL REFERENCES cat_contrato(id_contrato),
    id_centro_gestor    INT             NOT NULL REFERENCES cat_centro_gestor(id_centro_gestor),

    -- Identificación temporal
    anio_pago           SMALLINT        NOT NULL,
    anio_servicio       SMALLINT        NOT NULL,
    periodo_pago        SMALLINT        NOT NULL,   -- 1-12
    periodo_servicio    SMALLINT        NOT NULL,   -- 1-12
    mes                 VARCHAR(20),                -- nombre del mes (opcional/display)

    -- Datos de la factura
    numero_factura      VARCHAR(60)     NOT NULL,
    fecha_factura       DATE            NOT NULL,
    oficio_pago         VARCHAR(60),
    clave               VARCHAR(60),
    moneda              CHAR(3)         NOT NULL DEFAULT 'USD',
    estimado            BOOLEAN         DEFAULT FALSE,
    validacion          VARCHAR(100),

    -- Importes facturados
    importe             NUMERIC(18,6)   NOT NULL,
    iva                 NUMERIC(18,6)   NOT NULL DEFAULT 0,
    total               NUMERIC(18,6)   GENERATED ALWAYS AS (importe + iva) STORED,

    -- Registro pasivo SAP
    numero_doc_pasivo   VARCHAR(20),
    fecha_pasivo        DATE,
    importe_pasivo      NUMERIC(18,6),
    iva_pasivo          NUMERIC(18,6),
    total_pasivo        NUMERIC(18,6),
    tc_pasivo           NUMERIC(10,6),             -- tipo de cambio al registrar pasivo

    -- Registro de pago SAP
    numero_doc_pago     VARCHAR(20),
    fecha_pago          DATE,
    importe_pago        NUMERIC(18,6),
    iva_pago            NUMERIC(18,6),
    total_pago          NUMERIC(18,6),
    tc_pago             NUMERIC(10,6),             -- tipo de cambio al pagar

    -- Documento auxiliar
    numero_doc_aux      VARCHAR(20),

    -- Campos de control
    reviso              VARCHAR(100),
    pct_impuestos       NUMERIC(6,4),              -- ej. 0.16 = 16%
    doc_pago_usd        VARCHAR(20),               -- documento de pago en USD
    pagadero_usd        NUMERIC(18,6),             -- monto pagadero en USD
    pago_pesos_usd      NUMERIC(18,6),             -- conversión a pesos (desde USD)
    pago_pesos_mxn      NUMERIC(18,6),             -- pago en pesos origen MXN

    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_moneda          CHECK (moneda IN ('USD','MXN','EUR')),
    CONSTRAINT chk_periodo_pago    CHECK (periodo_pago    BETWEEN 1 AND 12),
    CONSTRAINT chk_periodo_svc     CHECK (periodo_servicio BETWEEN 1 AND 12),
    CONSTRAINT chk_importe_pos     CHECK (importe >= 0),
    CONSTRAINT uq_factura          UNIQUE (numero_factura, id_contrato)
);

COMMENT ON TABLE factura_pago IS
    'Tabla maestra: registro completo de facturas y su ciclo de pago (pasivo → pago SAP)';
COMMENT ON COLUMN factura_pago.total IS
    'Calculado automáticamente: importe + iva';

-- =============================================================================
-- BASE 1: CARGO FIJO (Reserva de Capacidad)
-- Fórmula: Importe = Reserva_Diaria_GJ × Tarifa × Días_Periodo
-- =============================================================================

CREATE TABLE cargo_fijo (
    id_cargo_fijo           SERIAL          PRIMARY KEY,
    id_factura              INT             NOT NULL UNIQUE
                                            REFERENCES factura_pago(id_factura)
                                            ON DELETE CASCADE,

    -- Parámetros de la fórmula de cálculo
    reserva_capacidad_gj    NUMERIC(14,6),          -- reserva total contratada (GJ)
    reserva_diaria_gj       NUMERIC(14,6)   NOT NULL, -- RC diaria base del cálculo
    dias_periodo            SMALLINT        NOT NULL, -- días del mes de servicio
    tarifa                  NUMERIC(14,8)   NOT NULL, -- tarifa USD/GJ·día (o MXN según contrato)

    -- Ajuste tarifario USPPI (índice de precios al productor)
    usppi_o                 NUMERIC(10,6),           -- USPPIo: índice base (origen)
    usppi_m                 NUMERIC(10,6),           -- USPPIm: índice del mes
    factor_usppi            NUMERIC(10,8)
        GENERATED ALWAYS AS (
            CASE WHEN usppi_o IS NOT NULL AND usppi_o <> 0
                 THEN usppi_m / usppi_o
                 ELSE NULL
            END
        ) STORED,

    -- Participación de impuestos
    participacion_impuestos NUMERIC(6,4),            -- fracción (ej. 0.0 si exento)
    pct_impuestos           NUMERIC(6,4),            -- % impuesto aplicado

    -- Importe calculado (para validación cruzada vs factura)
    importe_calculado       NUMERIC(18,6)
        GENERATED ALWAYS AS (
            reserva_diaria_gj * tarifa * dias_periodo
        ) STORED,

    -- Bandera de conciliación
    conciliado              BOOLEAN         DEFAULT FALSE,
    diferencia_importe      NUMERIC(18,6),           -- llenado por proceso de validación
    notas                   TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE cargo_fijo IS
    'Detalle de cargo fijo por reserva de capacidad. Fórmula: RC_diaria × Tarifa × Días';
COMMENT ON COLUMN cargo_fijo.factor_usppi IS
    'Calculado automáticamente: USPPIm / USPPIo';
COMMENT ON COLUMN cargo_fijo.importe_calculado IS
    'Calculado automáticamente: reserva_diaria_gj × tarifa × dias_periodo';

-- =============================================================================
-- BASE 2: CARGO VARIABLE (Volumen Transportado)
-- Fórmula: Importe = Volumen_Real_GJ × Tarifa_Variable
-- =============================================================================

CREATE TABLE cargo_variable (
    id_cargo_variable       SERIAL          PRIMARY KEY,
    id_factura              INT             NOT NULL UNIQUE
                                            REFERENCES factura_pago(id_factura)
                                            ON DELETE CASCADE,

    -- Parámetros de la fórmula de cálculo
    volumen_real_gj         NUMERIC(14,6)   NOT NULL, -- GJ realmente transportados
    flujo_promedio_gj       NUMERIC(14,6),            -- flujo promedio diario (GJ/día)
    volumen_mensual_gj      NUMERIC(14,6),            -- volumen total del mes (GJ)
    tarifa_variable         NUMERIC(14,8)   NOT NULL, -- tarifa USD/GJ (o MXN)

    -- Ajuste tarifario USPPI
    usppi_o                 NUMERIC(10,6),
    usppi_m                 NUMERIC(10,6),
    factor_usppi            NUMERIC(10,8)
        GENERATED ALWAYS AS (
            CASE WHEN usppi_o IS NOT NULL AND usppi_o <> 0
                 THEN usppi_m / usppi_o
                 ELSE NULL
            END
        ) STORED,

    -- Participación de impuestos
    participacion_impuestos NUMERIC(6,4),
    pct_impuestos           NUMERIC(6,4),

    -- Importe calculado
    importe_calculado       NUMERIC(18,6)
        GENERATED ALWAYS AS (
            volumen_real_gj * tarifa_variable
        ) STORED,

    -- Conciliación
    conciliado              BOOLEAN         DEFAULT FALSE,
    diferencia_importe      NUMERIC(18,6),
    notas                   TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE cargo_variable IS
    'Detalle de cargo variable por volumen transportado. Fórmula: Vol_real × Tarifa_variable';
COMMENT ON COLUMN cargo_variable.importe_calculado IS
    'Calculado automáticamente: volumen_real_gj × tarifa_variable';

-- =============================================================================
-- BASE 3: CARGO POR INTERCONEXIÓN
-- Fórmula: según términos contractuales del punto de interconexión
-- =============================================================================

CREATE TABLE cargo_interconexion (
    id_interconexion        SERIAL          PRIMARY KEY,
    id_factura              INT             NOT NULL UNIQUE
                                            REFERENCES factura_pago(id_factura)
                                            ON DELETE CASCADE,

    -- Identificación del punto de interconexión
    punto_interconexion     VARCHAR(200)    NOT NULL, -- ej. "Reynosa-McAllen"
    operador_frontera       VARCHAR(200),             -- operador lado Texas (ej. NET Mexico Pipeline)
    estado_frontera         VARCHAR(100),             -- estado/localidad de la frontera
    cruce_fronterizo        VARCHAR(200),             -- nombre del cruce (ej. Río Bravo)

    -- Parámetros de cálculo
    capacidad_contratada_gj NUMERIC(14,6),            -- GJ/día contratados en el punto
    volumen_interconexion   NUMERIC(14,6),            -- volumen realmente cursado (GJ)
    tarifa_interconexion    NUMERIC(14,8),            -- tarifa específica del punto
    dias_periodo            SMALLINT,

    -- Tipo de cargo en interconexión
    tipo_cargo              VARCHAR(60),              -- 'CAPACIDAD' | 'VOLUMETRICO' | 'MIXTO'
    base_calculo            VARCHAR(300),             -- descripción de la fórmula contractual

    -- Participación de impuestos
    participacion_impuestos NUMERIC(6,4),
    pct_impuestos           NUMERIC(6,4),

    -- Conciliación
    importe_calculado       NUMERIC(18,6),            -- calculado manualmente (fórmula variable)
    conciliado              BOOLEAN         DEFAULT FALSE,
    diferencia_importe      NUMERIC(18,6),
    notas                   TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_tipo_cargo CHECK (
        tipo_cargo IN ('CAPACIDAD','VOLUMETRICO','MIXTO') OR tipo_cargo IS NULL
    )
);

COMMENT ON TABLE cargo_interconexion IS
    'Detalle de cargos por punto de interconexión fronteriza (México-Estados Unidos)';

-- =============================================================================
-- BASE 4: PENALIZACIONES Y DESBALANCEOS
-- Fórmula: Importe = Volumen_Desbalance × Factor_Penalización
-- =============================================================================

CREATE TABLE penalizacion (
    id_penalizacion         SERIAL          PRIMARY KEY,
    id_factura              INT             NOT NULL
                                            REFERENCES factura_pago(id_factura)
                                            ON DELETE CASCADE,
    -- Una factura puede tener varias penalizaciones en el mismo periodo
    num_linea               SMALLINT        NOT NULL DEFAULT 1,

    -- Tipo y causa
    tipo_penalizacion       VARCHAR(100)    NOT NULL,
    -- Ej: 'DESBALANCE_DIARIO' | 'EXCESO_CAPACIDAD' | 'INCUMPLIMIENTO_NOMINAL'
    descripcion_causa       TEXT,
    referencia_cre          VARCHAR(100),             -- disposición CRE/CENAGAS aplicable
    periodo_penalizado      DATE,                     -- fecha exacta del desbalance

    -- Parámetros de cálculo
    volumen_desbalance_gj   NUMERIC(14,6)   NOT NULL, -- GJ en desequilibrio
    factor_penalizacion     NUMERIC(10,6)   NOT NULL, -- multiplicador (ej. 1.10 = 110%)
    precio_referencia       NUMERIC(14,8),            -- precio spot o de referencia base
    tarifa_base             NUMERIC(14,8),            -- tarifa normal del servicio

    -- Importe calculado
    importe_calculado       NUMERIC(18,6)
        GENERATED ALWAYS AS (
            volumen_desbalance_gj * factor_penalizacion * COALESCE(precio_referencia, tarifa_base, 0)
        ) STORED,

    -- Participación de impuestos
    participacion_impuestos NUMERIC(6,4),
    pct_impuestos           NUMERIC(6,4),

    -- Conciliación
    conciliado              BOOLEAN         DEFAULT FALSE,
    diferencia_importe      NUMERIC(18,6),
    notas                   TEXT,
    created_at              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_pen_linea UNIQUE (id_factura, num_linea)
);

COMMENT ON TABLE penalizacion IS
    'Penalizaciones por desbalanceo o incumplimiento. Fórmula: Vol_desbalance × Factor × Precio_ref';
COMMENT ON COLUMN penalizacion.importe_calculado IS
    'Calculado automáticamente: vol_desbalance × factor × precio_referencia';

-- =============================================================================
-- ÍNDICES DE RENDIMIENTO
-- =============================================================================

-- Tabla maestra — búsquedas frecuentes
CREATE INDEX idx_fp_contrato       ON factura_pago (id_contrato);
CREATE INDEX idx_fp_periodo        ON factura_pago (anio_servicio, periodo_servicio);
CREATE INDEX idx_fp_anio_pago      ON factura_pago (anio_pago, periodo_pago);
CREATE INDEX idx_fp_fecha_pago     ON factura_pago (fecha_pago);
CREATE INDEX idx_fp_num_factura    ON factura_pago (numero_factura);
CREATE INDEX idx_fp_centro_gestor  ON factura_pago (id_centro_gestor);

-- Tablas de concepto — join principal
CREATE INDEX idx_cf_factura        ON cargo_fijo          (id_factura);
CREATE INDEX idx_cv_factura        ON cargo_variable      (id_factura);
CREATE INDEX idx_ci_factura        ON cargo_interconexion (id_factura);
CREATE INDEX idx_pen_factura       ON penalizacion        (id_factura);
CREATE INDEX idx_pen_periodo       ON penalizacion        (periodo_penalizado);

-- Catálogos
CREATE INDEX idx_cto_proveedor     ON cat_contrato (id_proveedor);

-- =============================================================================
-- VISTA: RESUMEN CONSOLIDADO POR FACTURA
-- =============================================================================

CREATE OR REPLACE VIEW v_resumen_factura AS
SELECT
    fp.id_factura,
    pr.nombre_proveedor,
    pr.acreedor_sap,
    ct.contrato_sap,
    ct.numero_contrato,
    ct.lugar_servicio,
    cg.codigo                                   AS centro_gestor,
    cg.nombre                                   AS nombre_centro_gestor,
    fp.anio_servicio,
    fp.periodo_servicio,
    fp.numero_factura,
    fp.fecha_factura,
    fp.moneda,
    fp.importe,
    fp.iva,
    fp.total,
    fp.fecha_pago,
    fp.total_pago,
    fp.tc_pago,
    -- Concepto principal identificado
    CASE
        WHEN cf.id_cargo_fijo          IS NOT NULL THEN 'CARGO FIJO'
        WHEN cv.id_cargo_variable      IS NOT NULL THEN 'CARGO VARIABLE'
        WHEN ci.id_interconexion       IS NOT NULL THEN 'INTERCONEXIÓN'
        WHEN pe.id_penalizacion        IS NOT NULL THEN 'PENALIZACIÓN'
        ELSE 'SIN CLASIFICAR'
    END                                         AS concepto_pago,
    -- Importes calculados para validación
    cf.importe_calculado                        AS calc_cargo_fijo,
    cv.importe_calculado                        AS calc_cargo_variable,
    ci.importe_calculado                        AS calc_interconexion,
    pe.importe_calculado                        AS calc_penalizacion,
    -- Banderas de conciliación
    COALESCE(cf.conciliado, cv.conciliado,
             ci.conciliado, pe.conciliado)      AS conciliado
FROM       factura_pago          fp
JOIN       cat_contrato          ct ON ct.id_contrato      = fp.id_contrato
JOIN       cat_proveedor         pr ON pr.id_proveedor      = ct.id_proveedor
JOIN       cat_centro_gestor     cg ON cg.id_centro_gestor  = fp.id_centro_gestor
LEFT JOIN  cargo_fijo            cf ON cf.id_factura        = fp.id_factura
LEFT JOIN  cargo_variable        cv ON cv.id_factura        = fp.id_factura
LEFT JOIN  cargo_interconexion   ci ON ci.id_factura        = fp.id_factura
LEFT JOIN  penalizacion          pe ON pe.id_factura        = fp.id_factura
                                    AND pe.num_linea = 1;

COMMENT ON VIEW v_resumen_factura IS
    'Vista consolidada: une la tabla maestra con los 4 conceptos de pago. Uso principal: reportes y auditoría.';

-- =============================================================================
-- VISTA: DIFERENCIAS DE CONCILIACIÓN (facturas con discrepancia)
-- =============================================================================

CREATE OR REPLACE VIEW v_diferencias_conciliacion AS
SELECT
    fp.id_factura,
    fp.numero_factura,
    fp.fecha_factura,
    pr.nombre_proveedor,
    ct.contrato_sap,
    fp.anio_servicio,
    fp.periodo_servicio,
    fp.moneda,
    fp.importe                                  AS importe_facturado,
    COALESCE(
        cf.importe_calculado,
        cv.importe_calculado,
        ci.importe_calculado,
        pe.importe_calculado
    )                                           AS importe_calculado,
    fp.importe - COALESCE(
        cf.importe_calculado,
        cv.importe_calculado,
        ci.importe_calculado,
        pe.importe_calculado
    )                                           AS diferencia
FROM       factura_pago          fp
JOIN       cat_contrato          ct ON ct.id_contrato  = fp.id_contrato
JOIN       cat_proveedor         pr ON pr.id_proveedor = ct.id_proveedor
LEFT JOIN  cargo_fijo            cf ON cf.id_factura   = fp.id_factura
LEFT JOIN  cargo_variable        cv ON cv.id_factura   = fp.id_factura
LEFT JOIN  cargo_interconexion   ci ON ci.id_factura   = fp.id_factura
LEFT JOIN  penalizacion          pe ON pe.id_factura   = fp.id_factura
                                    AND pe.num_linea = 1
WHERE
    ABS(fp.importe - COALESCE(
        cf.importe_calculado,
        cv.importe_calculado,
        ci.importe_calculado,
        pe.importe_calculado,
        fp.importe
    )) > 0.01                                   -- tolerancia de 1 centavo
ORDER BY ABS(diferencia) DESC;

COMMENT ON VIEW v_diferencias_conciliacion IS
    'Facturas donde el importe facturado difiere del calculado por fórmula (tolerancia ±$0.01)';

-- =============================================================================
-- NOTAS DE COMPATIBILIDAD
-- =============================================================================
-- PostgreSQL 12+: totalmente compatible (GENERATED ALWAYS AS ... STORED).
-- MySQL 8.0+:     Compatible. Cambiar SERIAL → INT AUTO_INCREMENT,
--                 BOOLEAN → TINYINT(1), y verificar soporte de columnas generadas.
-- SQL Server:     Cambiar SERIAL → INT IDENTITY(1,1), NUMERIC → DECIMAL,
--                 GENERATED ALWAYS AS → AS (...) PERSISTED.
-- Oracle:         Cambiar SERIAL → NUMBER GENERATED ALWAYS AS IDENTITY,
--                 BOOLEAN → NUMBER(1,0).
-- =============================================================================
