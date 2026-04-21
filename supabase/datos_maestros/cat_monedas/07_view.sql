-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 07_view.sql
-- =========================================================

create or replace view datos_maestros.vw_cat_monedas as
select
    codigo,
    descripcion
from datos_maestros.cat_monedas;

comment on view datos_maestros.vw_cat_monedas
    is 'Vista de catalogo de monedas para consumo y reporteria.';
