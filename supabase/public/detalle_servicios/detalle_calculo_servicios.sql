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
    id_detalle_calculo_servicio UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_documento UUID NOT NULL UNIQUE REFERENCES public.diario_documentos(id_documento) ON DELETE CASCADE,
    reserva_capacidad NUMERIC(15, 2),
    reserva_diaria NUMERIC(15, 2),
    tarifa_base NUMERIC(15, 6),
    volumen_mensual NUMERIC(15, 2),
    usppio NUMERIC(15, 6),
    uspplm NUMERIC(15, 6),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);
