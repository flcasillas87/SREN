delete from staging.stg_precios_vinculantes_combustibles
where batch_id = :batch_id;
delete from transform.trf_precios_vinculantes_combustibles
where batch_id = :batch_id;
delete from transform.prep_precios_vinculantes_combustibles
where batch_id = :batch_id;