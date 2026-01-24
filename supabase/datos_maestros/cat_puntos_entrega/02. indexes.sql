-- Índice para búsquedas rápidas por nombre (el que usa el colaborador en Excel)
CREATE INDEX idx_puntos_nombre_upper ON datos_maestros.cat_puntos_entrega (UPPER(nombre_punto));

-- Índice para filtrar por sistema de transporte
CREATE INDEX idx_puntos_sistema ON datos_maestros.cat_puntos_entrega (sistema_transporte) WHERE activo = true;