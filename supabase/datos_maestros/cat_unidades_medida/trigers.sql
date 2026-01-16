-- =========================================================
-- TRIGGERS
-- =========================================================
create trigger tr_cat_unidades_medida_updated before
update on datos_maestros.cat_unidades_medida for each row execute function public.set_updated_at_mx();
