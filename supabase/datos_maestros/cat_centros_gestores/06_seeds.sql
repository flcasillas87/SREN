-- =========================================================
-- Archivo: 06_seeds_cat_centros_gestores.sql
-- =========================================================

insert into datos_maestros.cat_centros_gestores (
  codigo,
  nombre,
  sociedad_id,
  pos_pre,
  cuenta_contable,
  fondo,
  activo,
  created_by
)
values
  ('CG001', 'Centro Gestor 001', null, null, null, null, true, 'seed'),
  ('CG002', 'Centro Gestor 002', null, null, null, null, true, 'seed')
on conflict (codigo) do nothing;
