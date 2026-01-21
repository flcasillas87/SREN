-- =============================================================================
-- TRIGGER DE ACTUALIZACIÓN
-- =============================================================================
create trigger tr_cat_combustibles_updated before
update on datos_maestros.cat_combustibles for each row execute function public.set_updated_at_mx();
comment on table datos_maestros.cat_combustibles is 'Catálogo maestro de tipos de combustibles para generación eléctrica.';