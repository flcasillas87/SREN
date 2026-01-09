-- PASO 1: Carga inteligente (UPSERT)
INSERT INTO public.cat_proveedores (
    razon_social,
    rfc,
    email
)
SELECT 
    TRIM(razon_social_raw), -- Limpia espacios al inicio/final
    UPPER(TRIM(rfc_raw)),    -- RFC siempre en mayúsculas
    LOWER(TRIM(email_raw))   -- Email siempre en minúsculas
FROM staging.stg_proveedores
WHERE rfc_raw IS NOT NULL 
   OR razon_social_raw IS NOT NULL -- Evita filas vacías
ON CONFLICT (rfc) -- Si el RFC ya existe, actualiza la Razón Social y Email
DO UPDATE SET 
    razon_social = EXCLUDED.razon_social,
    email = EXCLUDED.email,
    updated_at = now();

-- PASO 2: Limpieza de la mesa de trabajo
TRUNCATE TABLE staging.stg_proveedores;