-- =============================================================================
-- 04_triggers.sql
-- Triggers para public.reporte_operativo_combustibles
-- =============================================================================

drop trigger if exists tr_reporte_operativo_combustibles_updated on public.reporte_operativo_combustibles;

create trigger tr_reporte_operativo_combustibles_updated
before update
on public.reporte_operativo_combustibles
for each row
execute function public.set_updated_at_mx();

-- Nota: si se requiere auditoría o bloqueos de negocio adicionales,
-- agréguelos a este archivo y defina las funciones correspondientes en
-- 00_functions.sql.
