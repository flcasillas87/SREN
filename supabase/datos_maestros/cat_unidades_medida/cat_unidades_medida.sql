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

-- Comentarios para documentación en el Dashboard de Supabase
comment on table datos_maestros.cat_unidades_medida is 'Unidades de medida vinculadas a tipos de combustibles específicos.';
comment on column datos_maestros.cat_unidades_medida.factor_conversion_mbtu is 'Factor multiplicador para normalizar el precio a MMBtu.';