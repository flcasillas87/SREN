-- =========================================================
-- Esquema: public
-- Tabla: diario_pagos
-- Archivo: 04_triggers.sql
-- =========================================================

drop trigger if exists tr_u_diario_pagos
    on public.diario_pagos;

create trigger tr_u_diario_pagos
before update on public.diario_pagos
for each row
execute function public.fn_update_at_mx();
