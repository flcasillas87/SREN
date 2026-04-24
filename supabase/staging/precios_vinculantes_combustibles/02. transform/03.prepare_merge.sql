-- =========================================================
-- Esquema: staging
-- Tabla: stg_precios_vinculantes_combustibles_ready
-- Archivo: 03.prepare_merge.sql
-- Descripcion: Resuelve IDs de catalogos y deja solo registros validos
-- =========================================================

drop table if exists staging.stg_precios_vinculantes_combustibles_ready;

create table staging.stg_precios_vinculantes_combustibles_ready as
select
    n.source_row,
    n.batch_id,
    n.fecha,
    c.id_combustible,
    u.id_unidad_medida,
    cg.id_central_generacion,
    n.precio_vinculante_combustibles,
    n.fuente,
    n.observaciones as observaciones,
    n.archivo_origen as archivo_origen,
    n.fecha_carga as fecha_carga,
    n.usuario_carga as usuario_carga
from staging.stg_precios_vinculantes_combustibles_normalized n
join datos_maestros.cat_combustibles c
  on upper(btrim(c.nombre_combustible)) = n.nombre_combustible
join datos_maestros.cat_unidades_medida u
  on upper(btrim(u.codigo)) = n.nombre_unidad_medida
 and u.id_combustible = c.id_combustible
join datos_maestros.cat_centrales_generacion cg
  on regexp_replace(upper(btrim(cg.nombre_central)), '\s+', ' ', 'g') = n.nombre_central
where not exists (
    select 1
    from staging.vw_precios_vinculantes_combustibles_validation_errors e
    where e.source_row = n.source_row
);
