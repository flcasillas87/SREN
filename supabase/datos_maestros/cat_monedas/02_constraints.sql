-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 02_constraints.sql
-- =========================================================

alter table datos_maestros.cat_monedas
    drop constraint if exists cat_monedas_codigo_chk,
    drop constraint if exists cat_monedas_descripcion_chk;

alter table datos_maestros.cat_monedas
    add constraint cat_monedas_codigo_chk
    check (btrim(codigo) <> '');

alter table datos_maestros.cat_monedas
    add constraint cat_monedas_descripcion_chk
    check (btrim(descripcion) <> '');
