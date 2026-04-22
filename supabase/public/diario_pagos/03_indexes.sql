-- =========================================================
-- Esquema: public
-- Tabla: diario_pagos
-- Archivo: 03_indexes.sql
-- =========================================================

create index if not exists idx_pagos_doc_id
    on public.diario_pagos (documento_id);

create index if not exists idx_pagos_fecha_pago
    on public.diario_pagos (fecha_pago);
