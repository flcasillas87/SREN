CREATE TABLE public.diario_costos_detalle (
    id_diario_costo_detalle UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_documento UUID REFERENCES public.diario_documentos(id_documento) ON DELETE CASCADE,
    
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
    importe_costo_mxn NUMERIC(18, 2) -- (subtotal * tc_contable_pasivo de la cabecera),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);
