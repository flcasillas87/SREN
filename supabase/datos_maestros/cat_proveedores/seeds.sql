-- =========================================================
-- SEED: Carga Inicial de Proveedores de Energía
-- Ubicación: datos_maestros.cat_proveedores
-- =========================================================

INSERT INTO datos_maestros.cat_proveedores (razon_social, rfc, email)
VALUES 
    ('CENTRO NACIONAL DE CONTROL DEL GAS NATURAL', 'CNC140828A11', 'contacto@cenagas.gob.mx'),
    ('IENOVA PIPELINES, S. DE R.L. DE C.V.', 'IPI060912ABC', 'facturacion@ienova.com.mx'),
    ('TC ENERGIA (TRANSPORTADORA DE GAS NATURAL DEL NOROESTE)', 'TGN120315XYZ', 'soporte@tcenergy.com'),
    ('ENGIE MEXICO (GASODUCTOS DE TAMAULIPAS)', 'GDT980512123', 'atencion@engie.com'),
    ('NET MEXICO PIPELINE PARTNERS, LLC', NULL, 'billing@netmexico.com'),
    ('WINDWARD ENERGY MARKETING', NULL, 'ops@windward.com'),
    ('CFE ENERGÍA S.A. DE C.V.', 'CFE150212ABC', 'ventas@cfeenergia.mx')
ON CONFLICT (razon_social) DO UPDATE SET
    updated_at = now();

-- Para verificar la carga y obtener los UUIDs generados:
-- SELECT id, razon_social FROM datos_maestros.cat_proveedores;