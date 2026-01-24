-- Índices para búsquedas rápidas por identificadores oficiales
CREATE INDEX idx_trabajadores_rfc ON datos_maestros.cat_trabajadores (UPPER(rfc));
CREATE INDEX idx_trabajadores_curp ON datos_maestros.cat_trabajadores (UPPER(curp));

-- Índice para búsquedas por nombre completo (útil para buscadores en la UI)
CREATE INDEX idx_trabajadores_nombre_completo ON datos_maestros.cat_trabajadores (apellido_paterno, apellido_materno, nombre);