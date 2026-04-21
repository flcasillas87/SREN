-- Trigger de auditoría (asumiendo que ya creaste public.fn_update_at)
CREATE TRIGGER tr_u_cat_contratos_transporte
    BEFORE UPDATE ON datos_maestros.cat_contratos_transporte
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_update_at();