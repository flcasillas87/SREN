-- =========================================================
-- Esquema: datos_maestros
-- Tabla: Catálogo de Centros Gestores
-- =========================================================
drop table if exists datos_maestros.cat_centros_gestores cascade;
create table datos_maestros.cat_centros_gestores (
  id_centro_gestor uuid not null default extensions.uuid_generate_v4(),
  codigo varchar(20) not null,
  nombre text not null,
  sociedad_id uuid null,
  pos_pre varchar(20) null,
  cuenta_contable varchar(20) null,
  fondo varchar(20) null,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by varchar(50) null,
  updated_by varchar(50) null,
  constraint cat_centros_gestores_pkey primary key (id_centro_gestor)
);