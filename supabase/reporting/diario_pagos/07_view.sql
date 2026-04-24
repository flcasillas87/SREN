create or replace view reporting.vw_diario_pagos as
select
    p.id_diario_pago,
    p.id_documento,
    p.fecha_pago,
    p.documento_pago_sap,
    p.moneda_pago,
    m.descripcion as moneda_pago_descripcion,
    p.monto_pagado_moneda_pago,
    p.tc_pago,
    p.total_pagado_mxn,
    p.comentarios,
    p.created_at,
    p.updated_at
from public.diario_pagos p
left join datos_maestros.cat_monedas m
    on p.moneda_pago = m.codigo;

comment on view reporting.vw_diario_pagos
    is 'Vista de pagos del diario con descripcion de moneda para consumo en reportes y Power BI.';

