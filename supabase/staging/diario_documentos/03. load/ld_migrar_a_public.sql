-- =========================================================
-- Script: 03. Load / ld_migrar_a_public.sql
-- Objetivo: Persistir los datos transformados en la tabla final
-- =========================================================

CREATE OR REPLACE PROCEDURE staging.pr_load_diario_documentos()
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Insertar datos en la tabla productiva
    INSERT INTO public.diario_documentos (
        sociedad_sap, fondo_sap, centro_gestor_sap, pospre_sap, cuenta_sap, 
        acreedor_sap, contrato_sap, proveedor, rfc_proveedor, lugar_servicio_id, 
        numero_contrato, nombre_contrato, plurianual, tipo_entrega, moneda_documento,
        numero_oficio_tramite, fecha_oficio_tramite, numero_factura, fecha_factura,
        periodo_contable, estimado, concepto, importe_moneda_original, 
        iva_moneda_original, total_moneda_original, numero_documento_pasivo,
        fecha_contable_pasivo, tc_contable_pasivo, importe_pasivo_mxn,
        iva_pasivo_mxn, total_pasivo_mxn
    )
    SELECT 
        sociedad_sap, fondo_sap, centro_gestor_sap, pospre_sap, cuenta_sap,
        acreedor_sap, contrato_sap, proveedor, rfc_proveedor, lugar_servicio_id,
        numero_contrato, nombre_contrato, plurianual, 
        tipo_entrega::public.tipo_entrega, 
        moneda_documento::public.tipo_moneda,
        numero_oficio_tramite, 
        NULLIF(fecha_oficio_tramite, '')::DATE,
        numero_factura, 
        NULLIF(fecha_factura_clean, '')::DATE,
        NULLIF(periodo_clean, '')::DATE,
        estimado_clean::BOOLEAN,
        concepto,
        NULLIF(importe_clean, '')::NUMERIC,
        -- Podríamos añadir lógica para calcular IVA aquí si viene vacío
        NULLIF(REPLACE(REPLACE(iva_moneda_original, ',', ''), '$', ''), '')::NUMERIC, 
        NULLIF(REPLACE(REPLACE(total_moneda_original, ',', ''), '$', ''), '')::NUMERIC,
        numero_documento_pasivo,
        NULLIF(fecha_contable_pasivo, '')::DATE,
        NULLIF(tc_clean, '')::NUMERIC,
        NULLIF(REPLACE(REPLACE(importe_pasivo_mxn, ',', ''), '$', ''), '')::NUMERIC,
        NULLIF(REPLACE(REPLACE(iva_pasivo_mxn, ',', ''), '$', ''), '')::NUMERIC,
        NULLIF(REPLACE(REPLACE(total_pasivo_mxn, ',', ''), '$', ''), '')::NUMERIC
    FROM staging.vw_prepare_merge_diario
    ON CONFLICT (numero_factura, proveedor) DO NOTHING; 
    -- Nota: Para que el ON CONFLICT funcione, debes tener un índice UNIQUE en esos campos.

    -- 2. Limpiar la tabla de staging para la próxima carga
    TRUNCATE TABLE staging.stg_diario_documentos;

    RAISE NOTICE 'Carga completada exitosamente y tabla staging vaciada.';
END;
$$;