-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 01_table.sql
-- =========================================================

drop table if exists datos_maestros.cat_monedas cascade;

create table datos_maestros.cat_monedas (
    codigo varchar(5) not null,
    descripcion varchar(100) not null,
    constraint cat_monedas_pkey primary key (codigo)
);
