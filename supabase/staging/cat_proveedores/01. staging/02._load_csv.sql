drop table if exists staging.cat_proveedores_raw;

create table staging.cat_proveedores_raw (
    id_proveedor text,
    razon_social text,
    rfc text,
    email text,
    created_at text,
    updated_at text
);

\copy staging.cat_proveedores_raw (
    id_proveedor,
    razon_social,
    rfc,
    email,
    created_at,
    updated_at
)
from 'C:/ruta/cat_proveedores_rows.csv'
with (
    format csv,
    header true,
    encoding 'UTF8'
);

truncate table staging.stg_proveedores;

insert into staging.stg_proveedores (
    razon_social_raw,
    rfc_raw,
    email_raw,
    observaciones,
    archivo_origen
)
select
    razon_social,
    rfc,
    email,
    null,
    'cat_proveedores_rows.csv'
from staging.cat_proveedores_raw;

drop table if exists staging.cat_proveedores_raw;

call etl.pr_load_cat_proveedores();

