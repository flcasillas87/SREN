-- =========================================================
-- Esquema: datos_maestros
-- Tabla: rel_contratos_puntos
-- =========================================================
CREATE TABLE datos_maestros.rel_contratos_puntos (
    id_relacion uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    id_contrato uuid NOT NULL REFERENCES datos_maestros.cat_contratos_transporte(id_contrato) ON DELETE CASCADE,
    id_punto uuid NOT NULL REFERENCES datos_maestros.cat_puntos_entrega(id_punto),
    tipo_nodo text CHECK (tipo_nodo IN ('ENTREGA', 'RECEPCION')),
    capacidad_punto numeric(18, 4),
    created_at timestamptz DEFAULT now(),
    observaciones text null,
    archivo_origen text null,
    fecha_carga timestamp null default (now() at time zone 'America/Monterrey'),
    usuario_carga uuid null default auth.uid()
);
