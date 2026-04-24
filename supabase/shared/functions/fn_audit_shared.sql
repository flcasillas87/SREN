-- =============================================================================
-- Función: public.fn_audit_row_mx()
-- Auditoría genérica para tablas persistentes
-- =============================================================================
CREATE OR REPLACE FUNCTION public.fn_audit_row_mx()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_actor uuid := auth.uid();
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO public.audit_cambios_tablas (
            schema_name,
            table_name,
            operation,
            old_row,
            new_row,
            changed_by
        )
        VALUES (
            TG_TABLE_SCHEMA,
            TG_TABLE_NAME,
            TG_OP,
            to_jsonb(OLD),
            NULL,
            v_actor
        );
        RETURN OLD;
    END IF;

    INSERT INTO public.audit_cambios_tablas (
        schema_name,
        table_name,
        operation,
        old_row,
        new_row,
        changed_by
    )
    VALUES (
        TG_TABLE_SCHEMA,
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP = 'UPDATE' THEN to_jsonb(OLD) ELSE NULL END,
        to_jsonb(NEW),
        v_actor
    );

    RETURN NEW;
END;
$$;
