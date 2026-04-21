-- =========================================================
-- Esquema: 
-- Tabla: Catálogo de Centros Gestores
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_centros_gestores CASCADE;
create table datos_maestros.cat_centros_gestores (
  id_centro_gestor uuid not null default extensions.uuid_generate_v4(),
  codigo varchar(20) not null,
  nombre text not null,
  sociedad varchar(10) null,
  -- sociedad SAP (p.ej. "1000")
  pos_pre varchar(20) null,
  -- posición presupuestal
  cuenta_contable varchar(20) null,
  fondo varchar(20) null,
  activo boolean null default true,
  created_at timestamptz null default now(),
  updated_at timestamptz null default now(),
  constraint cat_centros_gestores_pkey primary key (id_centro_gestor),
  constraint cat_centros_gestores_codigo_key unique (codigo)
) tablespace pg_default;
create index if not exists idx_cat_centros_gestores_activo on datos_maestros.cat_centros_gestores using btree (activo) tablespace pg_default
where activo = true;
create trigger tr_u_cat_centros_gestores before
update on datos_maestros.cat_centros_gestores for each row execute function fn_update_at_mx();
comment on table datos_maestros.cat_centros_gestores is 'Unidades presupuestales / centros gestores SAP';