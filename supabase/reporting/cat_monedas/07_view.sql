create or replace view reporting.vw_cat_monedas as
select
    codigo,
    descripcion
from datos_maestros.cat_monedas;

comment on view reporting.vw_cat_monedas
    is 'Vista de catalogo de monedas para consumo y reporteria.';

