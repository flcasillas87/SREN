create schema if not exists etl;

create or replace procedure etl.pr_load_diario_documentos()
language plpgsql
as $$
begin
    insert into public.diario_documentos (
        sociedad_sap,
        fondo_sap,
        centro_gestor_sap,
        pospre_sap,
        cuenta_sap,
        acreedor_sap,
        contrato_sap,
        proveedor,
        rfc_proveedor,
        id_lugar_servicio,
        numero_contrato,
        nombre_contrato,
        plurianual,
        tipo_entrega,
        moneda_documento,
        numero_oficio_tramite,
        fecha_oficio_tramite,
        numero_factura,
        fecha_factura,
        periodo_contable,
        estimado,
        concepto,
        importe_moneda_original,
        iva_moneda_original,
        total_moneda_original,
        numero_documento_pasivo,
        fecha_contable_pasivo,
        tc_contable_pasivo,
        importe_pasivo_mxn,
        iva_pasivo_mxn,
        total_pasivo_mxn
    )
    select
        sociedad_sap,
        fondo_sap,
        centro_gestor_sap,
        pospre_sap,
        cuenta_sap,
        acreedor_sap,
        contrato_sap,
        proveedor,
        rfc_proveedor,
        id_lugar_servicio,
        numero_contrato,
        nombre_contrato,
        plurianual,
        tipo_entrega::public.tipo_entrega,
        moneda_documento::public.tipo_moneda,
        numero_oficio_tramite,
        nullif(fecha_oficio_tramite, '')::date,
        numero_factura,
        nullif(fecha_factura_clean, '')::date,
        nullif(periodo_clean, '')::date,
        estimado_clean::boolean,
        concepto,
        nullif(importe_clean, '')::numeric,
        nullif(replace(replace(iva_moneda_original, ',', ''), '$', ''), '')::numeric,
        nullif(replace(replace(total_moneda_original, ',', ''), '$', ''), '')::numeric,
        numero_documento_pasivo,
        nullif(fecha_contable_pasivo, '')::date,
        nullif(tc_clean, '')::numeric,
        nullif(replace(replace(importe_pasivo_mxn, ',', ''), '$', ''), '')::numeric,
        nullif(replace(replace(iva_pasivo_mxn, ',', ''), '$', ''), '')::numeric,
        nullif(replace(replace(total_pasivo_mxn, ',', ''), '$', ''), '')::numeric
    from staging.vw_prepare_merge_diario
    on conflict (numero_factura, proveedor) do nothing;

    truncate table staging.stg_diario_documentos;
end;
$$;
