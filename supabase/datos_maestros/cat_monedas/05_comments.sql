-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 05_comments.sql
-- =========================================================

comment on table datos_maestros.cat_monedas
    is 'Catalogo de monedas utilizadas en el sistema.';

comment on column datos_maestros.cat_monedas.codigo
    is 'Codigo de la moneda, por ejemplo MXN o USD.';

comment on column datos_maestros.cat_monedas.descripcion
    is 'Descripcion de la moneda.';
