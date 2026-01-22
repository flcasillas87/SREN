--- =========================================================
 -- ÍNDICES
    --- =========================================================
    CREATE INDEX idx_rel_puntos_contrato ON datos_maestros.rel_contratos_puntos(id_contrato);
    CREATE INDEX idx_rel_puntos_nodo ON datos_maestros.rel_contratos_puntos(id_punto);