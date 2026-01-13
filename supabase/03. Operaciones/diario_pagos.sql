DROP TABLE IF EXISTS public.diario_pagos CASCADE;

CREATE TABLE public.diario_pagos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    documento_id UUID REFERENCES public.diario_documentos(id) ON DELETE CASCADE,
    
    -- Datos del Pago
    fecha_pago DATE NOT NULL,
    documento_pago_sap TEXT,         -- Folio de compensación
    moneda_pago public.tipo_moneda,
    
    -- Liquidación
    monto_pagado_moneda_pago NUMERIC(18, 2), -- Lo que se mandó (ej. 500 USD)
    tc_pago NUMERIC(12, 6),                  -- TC real del banco
    total_pagado_mxn NUMERIC(18, 2),         -- Lo que costó en pesos al final
    
    -- Diferencia Cambiaria (Vs lo que se provisionó en el Pasivo)
    -- Nota: Este cálculo se hace via código o vista para mayor precisión por pago
    comentarios TEXT
);

CREATE INDEX idx_pagos_doc_id ON public.diario_pagos(documento_id);