-- Índices para optimizar velocidad de reportes
CREATE INDEX idx_diario_lugar ON public.diario_documentos (lugar_servicio_id);
CREATE INDEX idx_diario_fecha_factura ON public.diario_documentos (fecha_factura);
CREATE INDEX idx_diario_tipo_entrega ON public.diario_documentos (tipo_entrega);
CREATE INDEX idx_diario_proveedor ON public.diario_documentos (proveedor);
CREATE INDEX idx_diario_folio_sap ON public.diario_documentos (numero_documento_pasivo);
CREATE UNIQUE INDEX idx_unique_factura_proveedor ON public.diario_documentos (numero_factura, proveedor);