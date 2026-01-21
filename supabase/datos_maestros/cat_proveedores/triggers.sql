DROP TRIGGER IF EXISTS tr_u_cat_proveedores ON datos_maestros.cat_proveedores;
CREATE TRIGGER tr_u_cat_proveedores BEFORE
UPDATE ON datos_maestros.cat_proveedores FOR EACH ROW EXECUTE FUNCTION public.fn_update_at_mx();