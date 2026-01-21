CREATE INDEX idx_proveedores_razon_social ON datos_maestros.cat_proveedores (razon_social);
CREATE INDEX idx_proveedores_rfc ON datos_maestros.cat_proveedores (rfc) WHERE rfc IS NOT NULL;