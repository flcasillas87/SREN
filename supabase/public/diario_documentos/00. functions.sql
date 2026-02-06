CREATE OR REPLACE FUNCTION public.fn_diario_documentos_calculos()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Asegurar totales en moneda original
    IF NEW.total_moneda_original IS NULL OR NEW.total_moneda_original = 0 THEN
        NEW.total_moneda_original := COALESCE(NEW.importe_moneda_original, 0) + COALESCE(NEW.iva_moneda_original, 0);
    END IF;

    -- 2. Asegurar totales en MXN
    IF NEW.total_pasivo_mxn IS NULL OR NEW.total_pasivo_mxn = 0 THEN
        NEW.total_pasivo_mxn := COALESCE(NEW.importe_pasivo_mxn, 0) + COALESCE(NEW.iva_pasivo_mxn, 0);
    END IF;

    -- 3. Limpieza de texto (opcional pero recomendado)
    NEW.proveedor := UPPER(TRIM(NEW.proveedor));
    NEW.rfc_proveedor := UPPER(TRIM(NEW.rfc_proveedor));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;