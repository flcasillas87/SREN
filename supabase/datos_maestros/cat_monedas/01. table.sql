-- =========================================================
-- Esquema: 
-- Tabla: 
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_monedas CASCADE;
CREATE TABLE datos_maestros.cat_monedas (
    codigo VARCHAR(5) PRIMARY KEY, -- 'MXN', 'USD'
    descripcion TEXT NOT NULL
);

-- Seed rápido para que las FK no fallen
INSERT INTO datos_maestros.cat_monedas (codigo, descripcion) 
VALUES ('MXN', 'Peso Mexicano'), ('USD', 'Dólar Americano')
ON CONFLICT DO NOTHING;