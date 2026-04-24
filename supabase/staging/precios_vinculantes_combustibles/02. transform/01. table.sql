-- =========================================================
-- Esquema: staging
-- Tabla: precios_vinculantes_combustibles_normalized
-- Archivo: 01.table.sql
-- Descripcion: Estructura normalizada homologada con otros pipelines
-- =========================================================

drop table if exists staging.precios_vinculantes_combustibles_normalized cascade;

create table staging.precios_vinculantes_combustibles_normalized (
    source_row bigint not null,
    batch_id uuid not null,
    fecha date null,
    nombre_combustible text null,
    nombre_unidad_medida text null,
    nombre_central text null,
    precio_vinculante_combustibles numeric(15, 4) null,
    fuente text null,
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null,
    usuario_carga uuid null
);
