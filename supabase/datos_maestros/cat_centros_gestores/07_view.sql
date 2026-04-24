-- Vista movida a reporting.vw_cat_centros_gestores
drop view if exists datos_maestros.vw_cat_centros_gestores;
create view datos_maestros.vw_cat_centros_gestores as
select * from reporting.vw_cat_centros_gestores;

