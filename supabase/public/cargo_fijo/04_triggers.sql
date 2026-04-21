-- =========================================================
-- Esquema: public
-- Tabla: cargo_fijo
-- Archivo: 04_triggers.sql
-- =========================================================

drop trigger if exists tr_u_cargo_fijo
    on public.cargo_fijo;

create trigger tr_u_cargo_fijo
before update on public.cargo_fijo
for each row
execute function public.fn_update_at_mx();
