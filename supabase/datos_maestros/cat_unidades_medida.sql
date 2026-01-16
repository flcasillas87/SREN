-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_unidades
-- =========================================================
drop table if exists datos_maestros.cat_unidades_medida cascade;
create table datos_maestros.cat_unidades_medida (
  id_unidad_medida serial not null,
  codigo character varying(20) not null,
  descripcion text null,
  factor_conversion_mbtu numeric(15, 8) not null,
  id_combustible integer not null,
  es_activo boolean null default true,
  created_at timestamp null default (now() at time zone 'America/Monterrey'),
  updated_at timestamp null default (now() at time zone 'America/Monterrey'),
  -- Índices y restricciones
  constraint cat_unidades_medida_pkey primary key (id_unidad_medida),
  constraint cat_unidades_medida_codigo_key unique (codigo),
  constraint fk_cat_unidades_medida_combustible foreign key (id_combustible) references datos_maestros.cat_combustibles (id_combustible) on delete restrict
) TABLESPACE pg_default;
-- =========================================================
-- TRIGGERS
-- =========================================================
create trigger tr_cat_unidades_medida_updated before
update on datos_maestros.cat_unidades_medida for each row execute function public.set_updated_at_mx();
-- =========================================================
-- ÍNDICES
-- =========================================================
-- Índice para acelerar los JOINs con combustibles
CREATE INDEX idx_cat_unidades_medida_id_combustible ON datos_maestros.cat_unidades_medida (id_combustible);
-- Índice funcional para acelerar el ETL (Búsquedas exactas sin importar espacios/mayúsculas)
CREATE INDEX idx_cat_unidades_medida_codigo_normalizado ON datos_maestros.cat_unidades_medida (upper(trim(codigo)));
-- Índice para el estado activo (Útil si tienes miles de unidades y solo buscas las vigentes)
CREATE INDEX idx_cat_unidades_medida_es_activo ON datos_maestros.cat_unidades_medida (es_activo)
WHERE es_activo = true;
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
      from public.cat_combustibles
      where nombre = 'Gas Natural'
    )
  ),
  (
    'GJ',
    'Giga Joule (0.9478 MMBtu)',
    0.94781712,
    (
      select id_combustible
      from public.cat_combustibles
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
      from public.cat_combustibles
      where nombre = 'Diesel'
    )
  ),
  (
    'm3',
    'Metro cúbico de Diesel',
    36.00000000,
    (
      select id_combustible
      from public.cat_combustibles
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
      from public.cat_combustibles
      where nombre = 'Fuel Oil'
    )
  ) on conflict (codigo) do
update
set factor_conversion_mbtu = excluded.factor_conversion_mbtu,
  descripcion = excluded.descripcion,
  updated_at = now() at time zone 'America/Monterrey';
-- Comentarios para documentación en el Dashboard de Supabase
comment on table public.cat_unidades is 'Unidades de medida vinculadas a tipos de combustibles específicos.';
comment on column public.cat_unidades.factor_conversion_mbtu is 'Factor multiplicador para normalizar el precio a MMBtu.';