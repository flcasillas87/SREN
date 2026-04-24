-- =========================================================
-- Esquema: public
-- Tabla: diario_pagos
-- Archivo: 02_constraints.sql
-- =========================================================

alter table public.diario_pagos
    drop constraint if exists fk_diario_pagos_documento,
    drop constraint if exists fk_diario_pagos_moneda,
    drop constraint if exists chk_diario_pagos_moneda,
    drop constraint if exists chk_diario_pagos_monto,
    drop constraint if exists chk_diario_pagos_tc,
    drop constraint if exists chk_diario_pagos_total;

alter table public.diario_pagos
    add constraint fk_diario_pagos_documento
    foreign key (id_documento)
    references public.diario_documentos (id_documento)
    on delete cascade;

alter table public.diario_pagos
    add constraint fk_diario_pagos_moneda
    foreign key (moneda_pago)
    references datos_maestros.cat_monedas (codigo);

alter table public.diario_pagos
    add constraint chk_diario_pagos_moneda
    check (btrim(moneda_pago) <> '');

alter table public.diario_pagos
    add constraint chk_diario_pagos_monto
    check (monto_pagado_moneda_pago is null or monto_pagado_moneda_pago >= 0);

alter table public.diario_pagos
    add constraint chk_diario_pagos_tc
    check (tc_pago is null or tc_pago > 0);

alter table public.diario_pagos
    add constraint chk_diario_pagos_total
    check (total_pagado_mxn is null or total_pagado_mxn >= 0);
