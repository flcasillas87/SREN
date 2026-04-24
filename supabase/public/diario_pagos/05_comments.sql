-- =========================================================
-- Esquema: public
-- Tabla: diario_pagos
-- Archivo: 05_comments.sql
-- =========================================================

comment on table public.diario_pagos
    is 'Registro de pagos realizados sobre documentos del diario contable.';

comment on column public.diario_pagos.id_documento
    is 'Documento contable origen al que corresponde el pago.';

comment on column public.diario_pagos.fecha_pago
    is 'Fecha en la que se realizo el pago.';

comment on column public.diario_pagos.documento_pago_sap
    is 'Folio o documento de compensacion en SAP.';

comment on column public.diario_pagos.moneda_pago
    is 'Moneda en la que se realizo el pago, por ejemplo USD o MXN.';

comment on column public.diario_pagos.monto_pagado_moneda_pago
    is 'Monto pagado en la moneda original del pago.';

comment on column public.diario_pagos.tc_pago
    is 'Tipo de cambio real utilizado al momento del pago.';

comment on column public.diario_pagos.total_pagado_mxn
    is 'Costo total del pago expresado en pesos mexicanos.';

comment on column public.diario_pagos.comentarios
    is 'Observaciones libres sobre el pago o su liquidacion.';
