-- Trigger para actualizar updated_at automáticamente
CREATE TRIGGER tr_update_timestamp_puntos BEFORE
UPDATE ON datos_maestros.cat_puntos_entrega FOR EACH ROW EXECUTE FUNCTION public.fn_update_at_mx() ;
-- (Asumiendo que ya tienes la función genérica fn_update_updated_at)