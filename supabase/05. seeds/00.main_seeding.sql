-- Orquestador de semillas
DO $$ 
BEGIN
    PERFORM datos_maestros.seed_cat_combustibles();
    PERFORM datos_maestros.seed_cat_unidades();
    PERFORM datos_maestros.seed_cat_centrales_generacion();
END $$;