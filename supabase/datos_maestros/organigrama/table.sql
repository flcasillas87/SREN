-- =========================================================
-- Tabla: Organigrama (Estructura Jerárquica)
-- =========================================================
DROP TABLE IF EXISTS datos_maestros.organigrama CASCADE;

CREATE TABLE datos_maestros.organigrama (
    id_posicion uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    nombre_puesto text NOT NULL,
    nombre_ocupante text, -- Nombre de la persona
    id_superior uuid,      -- Relación recursiva (quién es su jefe)
    area text,             -- Ej: Operaciones, Comercial, Finanzas
    nivel_jerarquico int,  -- Opcional: para facilitar ordenamiento
    activo bool DEFAULT true,
    
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Llave foránea que apunta a la propia tabla
    CONSTRAINT fk_organigrama_superior 
        FOREIGN KEY (id_superior) 
        REFERENCES datos_maestros.organigrama(id_posicion)
);