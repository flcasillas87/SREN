-- =========================================================
-- Tabla: Catálogo de Trabajadores
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_trabajadores CASCADE;
CREATE TABLE datos_maestros.cat_trabajadores (
    id_trabajador uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    rfc text UNIQUE,
    curp text UNIQUE,
    rpe text UNIQUE,
    nombre text NOT NULL,
    apellido_paterno text,
    apellido_materno text,
    tipo_contrato text,
    puesto text,
    correo_electronico text UNIQUE,
    fecha_ingreso date,
    activo bool DEFAULT true,
    salario numeric(15, 2),
    grupo_organico text,
    nivel_desempeno text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);