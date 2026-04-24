-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================
CREATE TABLE fact_precio_vinculante (
    id_precio_vinculante UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_combustible UUID NOT NULL REFERENCES dim_combustible(id_combustible),
    id_region UUID NOT NULL REFERENCES dim_region(id_region),

    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,

    precio_vinculante NUMERIC(14,6) NOT NULL,
    moneda TEXT DEFAULT 'MXN',

    fuente TEXT NOT NULL,
    documento_referencia TEXT,

    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT now(),

    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    CONSTRAINT chk_fechas_vigencia
        CHECK (fecha_fin_vigencia >= fecha_inicio_vigencia)
);

-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================

Campo	Descripción
cliente	Nombre cliente
combustible	Tipo
region	Región
fecha_suministro	Fecha
volumen	Litros / MMBtu
precio_aplicado	Precio cobrado
importe	volumen × precio_aplicado
