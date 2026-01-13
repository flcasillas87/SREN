CREATE TABLE public.diario_costos_detalle (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    documento_id UUID REFERENCES public.diario_documentos(id) ON DELETE CASCADE,
    
    -- Clasificación del costo
    concepto_costo TEXT, -- Ej: 'Tarifa Base', 'Excedente', 'Refacción X'
    tipo_item public.tipo_entrega, -- Bien o Servicio
    
    -- Datos Técnicos para el cálculo
    cantidad NUMERIC(15, 4),
    tarifa_o_precio_unitario NUMERIC(15, 6),
    unidad_medida TEXT, -- GJ, m3, Piezas, etc.
    
    -- El resultado en moneda original
    subtotal_costo_moneda_original NUMERIC(18, 2),
    
    -- Para tu seguimiento de costos en Pesos
    importe_costo_mxn NUMERIC(18, 2) -- (subtotal * tc_contable_pasivo de la cabecera)
);