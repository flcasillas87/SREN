-- =========================================================
-- Esquema: public
-- Tabla: precios_vinculantes_combustibles
-- Archivo: 05_comments.sql
-- =========================================================

comment on table public.precios_vinculantes_combustibles
    is 'Precios vinculantes de combustible por fecha y central de generación.';

comment on column public.precios_vinculantes_combustibles.id_precio_vinculante_combustible
    is 'Identificador único del precio vinculante.';

comment on column public.precios_vinculantes_combustibles.fecha
    is 'Fecha del precio vinculante.';

comment on column public.precios_vinculantes_combustibles.id_combustible
    is 'Referencia al combustible asociado.';

comment on column public.precios_vinculantes_combustibles.id_unidad_medida
    is 'Referencia a la unidad de medida del precio.';

comment on column public.precios_vinculantes_combustibles.id_central_generacion
    is 'Referencia a la central de generación.';

comment on column public.precios_vinculantes_combustibles.precio_vinculante_combustibles
    is 'Valor del precio vinculante en la unidad de medida definida.';

comment on column public.precios_vinculantes_combustibles.fuente
    is 'Fuente de información del precio.';

comment on column public.precios_vinculantes_combustibles.observaciones
    is 'Notas adicionales sobre el precio vinculante.';

comment on column public.precios_vinculantes_combustibles.es_activo
    is 'Indicador de si el registro está activo.';

comment on column public.precios_vinculantes_combustibles.created_at
    is 'Fecha y hora de creación del registro.';

comment on column public.precios_vinculantes_combustibles.updated_at
    is 'Fecha y hora de la última actualización del registro.';

comment on column public.precios_vinculantes_combustibles.created_by
    is 'Usuario que creó el registro.';

comment on column public.precios_vinculantes_combustibles.archivo_origen
    is 'Nombre del archivo de origen cuando la fila se cargó desde carga masiva.';

comment on column public.precios_vinculantes_combustibles.fecha_carga
    is 'Fecha y hora de la carga del registro en el sistema.';

comment on column public.precios_vinculantes_combustibles.usuario_carga
    is 'Usuario que realizó la carga del registro.';

comment on table public.audit_precios_vinculantes_combustibles
    is 'Auditoría de cambios del precio vinculante por registro original.';

comment on column public.audit_precios_vinculantes_combustibles.id_audit_precio_vinculante_combustible
    is 'Identificador único del registro de auditoría.';

comment on column public.audit_precios_vinculantes_combustibles.id_precio_vinculante_combustible
    is 'Referencia al precio vinculante original.';

comment on column public.audit_precios_vinculantes_combustibles.precio_anterior
    is 'Precio anterior antes del cambio.';

comment on column public.audit_precios_vinculantes_combustibles.precio_nuevo
    is 'Precio nuevo después del cambio.';

comment on column public.audit_precios_vinculantes_combustibles.usuario_cambio
    is 'Usuario que realizó el cambio de precio.';

comment on column public.audit_precios_vinculantes_combustibles.fecha_cambio
    is 'Fecha y hora en que se registró el cambio.';
