-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================
CREATE TABLE datos_maestros.cat_lugares_servicio (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    pais VARCHAR(3) CHECK (pais IN ('MX', 'USA')), -- Solo permite estos dos
    estado_region TEXT, -- Ej: 'Nuevo León' o 'Texas'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================




INSERT INTO public.cat_lugares_servicio (nombre, pais, estado_region) VALUES 
('', 'USA', 'Texas'),
('', 'MX', 'Nuevo León'),
('', 'MX', 'Chihuahua'),
('', 'MX', 'Tamaulipas'),
('', 'MX', 'Coahuila'),
('', 'MX', 'Veracruz'),
('', 'MX', 'Puebla'),
('', 'MX', 'Ciudad de México'),
('', 'MX', 'Jalisco');