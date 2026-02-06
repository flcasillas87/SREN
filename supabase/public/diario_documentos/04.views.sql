-- Facturas que aún no tienen registro en SAP
CREATE OR REPLACE VIEW public.vw_diario_documentos_pendientes_sap AS
SELECT 
    proveedor,
    numero_factura,
    total_moneda_original,
    moneda_documento
FROM public.diario_documentos
WHERE numero_documento_pasivo IS NULL;