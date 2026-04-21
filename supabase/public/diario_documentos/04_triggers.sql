DROP TRIGGER IF EXISTS tr_diario_documentos_antes_de_insertar ON public.diario_documentos;

CREATE TRIGGER tr_diario_documentos_antes_de_insertar
BEFORE INSERT OR UPDATE ON public.diario_documentos
FOR EACH ROW
EXECUTE FUNCTION public.fn_diario_documentos_calculos();