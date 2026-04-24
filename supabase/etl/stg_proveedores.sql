CREATE TABLE IF NOT EXISTS staging.stg_proveedores (
    id_stg_proveedor bigserial primary key,
    batch_id uuid not null default gen_random_uuid(),
    razon_social_raw text,
    rfc_raw text,
    email_raw text,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);
