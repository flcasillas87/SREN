-- =============================================================================
-- Función: public.fn_update_at_mx()
-- =============================================================================
CREATE OR REPLACE FUNCTION public.fn_update_at_mx() 
RETURNS trigger AS $$ 
BEGIN 
    NEW.updated_at = NOW() AT TIME ZONE 'America/Monterrey'; -- O 'America/Mexico_City'
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- Función: public.fn_set_created_at_mx()
-- =============================================================================
CREATE OR REPLACE FUNCTION public.fn_set_created_at_mx() 
RETURNS trigger AS $$ 
BEGIN 
    NEW.created_at = NOW() AT TIME ZONE 'America/Monterrey';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;