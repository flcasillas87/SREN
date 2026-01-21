CREATE TRIGGER tr_u_cat_proveedores
BEFORE UPDATE ON datos_maestros.cat_proveedores
FOR EACH ROW EXECUTE FUNCTION public.fn_update_at(); -- Asegúrate de tener esta función en public