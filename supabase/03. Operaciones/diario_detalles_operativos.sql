DROP TABLE IF EXISTS public.diario_detalles_operativos CASCADE;

CREATE TABLE public.diario_detalles_operativos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    documento_id UUID REFERENCES public.diario_documentos(id) ON DELETE CASCADE,
    
    -- FECHAS OPERATIVAS (El "Devengo" del costo)
    -- Estas pueden ser distintas a la fecha de factura
    fecha_servicio_inicio DATE,
    fecha_servicio_fin DATE,
    mes_consumo_costo TEXT,          -- Ej: '2023-12' (Útil para agrupar costos por mes real)

    -- Detalle del Costo
    concepto_gasto TEXT,             
    tipo_item public.tipo_entrega,   
    
    -- Variables Operativas
    cantidad NUMERIC(15, 4),         
    unidad_medida TEXT,
    precio_unitario_o_tarifa NUMERIC(15, 6),
    
    -- Importes en Pesos 
    -- Se calculan con el TC de la tabla diario_documentos (fecha de factura/pasivo)
    importe_mxn NUMERIC(18, 2),      
    
    -- Clasificación Contable
    centro_costos TEXT,
    cuenta_contable TEXT
);

CREATE INDEX idx_det_fecha_servicio ON public.diario_detalles_operativos(fecha_servicio_inicio);
CREATE INDEX idx_det_mes_consumo ON public.diario_detalles_operativos(mes_consumo_costo);