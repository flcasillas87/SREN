-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 01_table.sql
-- =========================================================

drop table if exists datos_maestros.cat_monedas cascade;

create table datos_maestros.cat_monedas (
    id_moneda serial not null,
    codigo varchar(5) not null,
    descripcion varchar(100) not null,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
    constraint cat_monedas_pkey primary key (id_moneda),
    constraint cat_monedas_codigo_key unique (codigo)
);
