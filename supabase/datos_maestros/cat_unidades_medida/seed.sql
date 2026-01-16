-- =============================================================================
-- DATOS SEMILLA (SEEDING)
-- Vinculados a los IDs creados en cat_combustibles
-- =============================================================================
insert into datos_maestros.cat_unidades_medida (
    codigo,
    descripcion,
    factor_conversion_mbtu,
    id_combustible
  )
values -- Unidades para Gas Natural (Asumiendo que Gas Natural es ID 1)
  (
    'MMBtu',
    'Millón de Unidades Térmicas Británicas',
    1.00000000,
    (
      select id_combustible
      from datos_maestros.cat_combustibles
      where nombre = 'Gas Natural'
    )
  ),
  (
    'GJ',
    'Giga Joule (0.9478 MMBtu)',
    0.94781712,
    (
      select id_combustible
      from datos_maestros.cat_combustibles
      where nombre = 'Gas Natural'
    )
  ),
  -- Unidades para Diesel (Asumiendo Diesel es ID 2)
  (
    'Litro',
    'Litro de Diesel',
    0.03600000,
    (
      select id_combustible
      from datos_maestros.cat_combustibles
      where nombre = 'Diesel'
    )
  ),
  (
    'm3',
    'Metro cúbico de Diesel',
    36.00000000,
    (
      select id_combustible
      from datos_maestros.cat_combustibles
      where nombre = 'Diesel'
    )
  ),
  -- Unidades para Fuel Oil (Combustóleo)
  (
    'Barril',
    'Barril de 42 galones',
    6.28700000,
    (
      select id_combustible
      from datos_maestros.cat_combustibles
      where nombre = 'Fuel Oil'
    )
  ) on conflict (codigo) do
update
set factor_conversion_mbtu = excluded.factor_conversion_mbtu,
  descripcion = excluded.descripcion,
  updated_at = now() at time zone 'America/Monterrey';