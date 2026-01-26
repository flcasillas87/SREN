-- =============================================================================
-- TRIGGERS
-- =============================================================================
drop trigger if exists tr_precios_vinculantes_combustibles_updated 
  on public.precios_vinculantes_combustibles;

drop trigger if exists tr_audit_precios_vinculantes_combustibles 
  on public.precios_vinculantes_combustibles;

drop trigger if exists tr_bloqueo_precios_vinculantes_combustibles_antiguos 
  on public.precios_vinculantes_combustibles;

-- -----------------------------------------------------------------------------
-- Trigger: bloqueo de actualización o borrado de fechas antiguas (primero)
-- -----------------------------------------------------------------------------
create trigger tr_bloqueo_precios_vinculantes_combustibles_antiguos
before update or delete
on public.precios_vinculantes_combustibles
for each row
execute function public.check_fecha_vinculante();

-- -----------------------------------------------------------------------------
-- Trigger: actualización automática de updated_at
-- -----------------------------------------------------------------------------
create trigger tr_precios_vinculantes_combustibles_updated
before update
on public.precios_vinculantes_combustibles
for each row
execute function public.set_updated_at_mx();

-- -----------------------------------------------------------------------------
-- Trigger: auditoría de cambios de precio
-- -----------------------------------------------------------------------------
create trigger tr_audit_precios_vinculantes_combustibles
after update
on public.precios_vinculantes_combustibles
for each row
when (
    old.precio_vinculante_combustibles
    is distinct from new.precio_vinculante_combustibles
)
execute function public.log_cambios_precios();
