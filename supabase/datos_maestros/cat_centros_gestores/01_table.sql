-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_centros_gestores
-- Archivo: 01_table_cat_centros_gestores.sql
-- =========================================================
drop table if exists datos_maestros.cat_centros_gestores cascade;
create table datos_maestros.cat_centros_gestores (
  id_centro_gestor uuid not null default extensions.uuid_generate_v4(),
  codigo varchar(20) not null,
  nombre text not null,
  sociedad_id uuid null,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by varchar(50) null,
  updated_by varchar(50) null,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid(),
  constraint cat_centros_gestores_pkey primary key (id_centro_gestor)
);
