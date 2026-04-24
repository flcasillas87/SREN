create or replace view reporting.vw_diario_documentos_pendientes_sap as
select
    proveedor,
    numero_factura,
    total_moneda_original,
    moneda_documento
from public.diario_documentos
where numero_documento_pasivo is null;

