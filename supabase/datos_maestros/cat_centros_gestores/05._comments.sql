-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_centros_gestores
-- Archivo: 05_comments_cat_centros_gestores.sql
-- =========================================================

comment on table datos_maestros.cat_centros_gestores
  is 'Catalogo maestro de centros gestores.';

comment on column datos_maestros.cat_centros_gestores.id_centro_gestor
  is 'Identificador unico del centro gestor.';

comment on column datos_maestros.cat_centros_gestores.codigo
  is 'Clave unica de negocio del centro gestor.';

comment on column datos_maestros.cat_centros_gestores.nombre
  is 'Nombre del centro gestor.';

comment on column datos_maestros.cat_centros_gestores.sociedad_id
  is 'Referencia a la sociedad asociada al centro gestor.';

comment on column datos_maestros.cat_centros_gestores.activo
  is 'Indica si el centro gestor esta activo.';

comment on column datos_maestros.cat_centros_gestores.created_at
  is 'Fecha de creacion del registro.';

comment on column datos_maestros.cat_centros_gestores.updated_at
  is 'Fecha de ultima actualizacion del registro.';

comment on column datos_maestros.cat_centros_gestores.created_by
  is 'Usuario que creo el registro.';

comment on column datos_maestros.cat_centros_gestores.updated_by
  is 'Usuario que actualizo el registro por ultima vez.';
