CREATE TRIGGER tr_u_cat_contratos_transporte
BEFORE UPDATE ON datos_maestros.cat_contratos_transporte
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_mx(); 