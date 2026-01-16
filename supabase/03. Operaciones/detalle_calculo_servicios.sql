-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================


-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================
CREATE TABLE public.detalle_calculo_servicios (
    documento_id UUID PRIMARY KEY REFERENCES public.diario_documentos(id) ON DELETE CASCADE,
    reserva_capacidad NUMERIC(15, 2),
    reserva_diaria NUMERIC(15, 2),
    tarifa_base NUMERIC(15, 6),
    volumen_mensual NUMERIC(15, 2),
    usppio NUMERIC(15, 6),
    uspplm NUMERIC(15, 6)
);