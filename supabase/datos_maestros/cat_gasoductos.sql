-- =========================================================
-- Esquema: datos_maestros 
-- Tabla: cat_gasoductos
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.cat_gasoductos;
CREATE TABLE datos_maestros.cat_gasoductos (
	id_gasoducto serial4 NOT NULL,
	codigo varchar(50) NOT NULL,
	nombre varchar(150) NOT NULL,
	operador varchar(150) NULL,
	propietario varchar(150) NULL,
	tipo varchar(50) NULL,
	diametro_pulgadas numeric(5, 2) NULL,
	presion_maxima_psi numeric(10, 2) NULL,
	longitud_km numeric(10, 2) NULL,
	origen varchar(150) NULL,
	destino varchar(150) NULL,
	es_activo bool DEFAULT true NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp NULL,
	CONSTRAINT cat_gasoductos_codigo_key UNIQUE (codigo),
	CONSTRAINT cat_gasoductos_pkey PRIMARY KEY (id_gasoducto)
);

-- =========================================================
-- ÍNDICES
----------------------------------------------------------


-- =========================================================
-- TRIGGERS
-- =========================================================

