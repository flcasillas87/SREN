-- =========================================================
-- Triggers
-- =========================================================
create trigger tr_u_cat_centros_gestores before
update on datos_maestros.cat_centros_gestores for each row execute function fn_update_at_mx();