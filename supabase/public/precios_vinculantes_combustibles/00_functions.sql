-- =============================================================================
-- 00_functions.sql
-- Funciones de trigger para la tabla precios_vinculantes_combustibles
--
-- Contenido:
--   1. check_fecha_vinculante()  → inmutabilidad de registros con >7 días
--   2. log_cambios_precios()     → auditoría de cambios en precio vinculante
-- =============================================================================


-- =============================================================================
-- FUNCIÓN 1: check_fecha_vinculante()
-- =============================================================================
-- Propósito:
--   Proteger la integridad histórica de los registros de precios vinculantes.
--   Un registro se considera "inmutable" una vez que su fecha de precio supera
--   los 7 días de antigüedad, ya que en ese punto puede haber sido utilizado
--   en cálculos de costos, reportes regulatorios o conciliaciones con CENAGAS
--   y otras contrapartes.
--
-- Comportamiento por operación:
--   DELETE → Bloquea la eliminación total del registro si tiene >7 días.
--            Registros recientes (<=7 días) sí pueden eliminarse.
--
--   UPDATE → Permite actualizar campos administrativos (fuente, observaciones,
--            archivo_origen, etc.) en registros antiguos, pero bloquea cualquier
--            cambio en los 5 campos de negocio:
--              · fecha
--              · id_combustible
--              · id_unidad_medida
--              · id_central_generacion
--              · precio_vinculante_combustibles
--
--   INSERT → No aplica (el trigger debe configurarse solo para UPDATE y DELETE).
--
-- Nota técnica:
--   Se verifica TG_OP explícitamente antes de acceder a OLD en la rama UPDATE,
--   ya que en un INSERT OLD es NULL y causaría un error en tiempo de ejecución.
-- =============================================================================
create or replace function public.check_fecha_vinculante()
returns trigger
language plpgsql
as $$
begin

    -- --------------------------------------------------
    -- Rama DELETE
    -- Rechaza la eliminación si el registro ya superó
    -- los 7 días de antigüedad.
    -- TG_OP es una variable especial de PostgreSQL disponible dentro 
    -- de cualquier función de trigger.
    -- tg_op es una variable especial de PostgreSQL disponible dentro de cualquier
    -- función de trigger. Contiene un string que indica qué operación DML 
    --disparó el trigger.
    -- --------------------------------------------------
    if tg_op = 'DELETE' then
        if old.fecha < current_date - interval '7 days' then
            raise exception
                'Operación denegada: el registro de fecha % tiene más de 7 días y es inmutable.',
                old.fecha;
        end if;
        -- Registro reciente: permitir eliminación
        return old;
    end if;

    -- --------------------------------------------------
    -- Rama UPDATE
    -- Solo se evalúa si la operación es UPDATE, evitando
    -- acceso a OLD cuando es NULL (caso INSERT).
    -- --------------------------------------------------
    if tg_op = 'UPDATE' then

        -- Verificar si el registro supera el umbral de 7 días
        if old.fecha < current_date - interval '7 days' then

            -- Detectar cambios en cualquiera de los campos de negocio.
            -- Se usa IS DISTINCT FROM en lugar de <> para manejar correctamente
            -- comparaciones con valores NULL (NULL <> NULL = NULL, no TRUE).
            if old.fecha                          is distinct from new.fecha
            or old.id_combustible                 is distinct from new.id_combustible
            or old.id_unidad_medida               is distinct from new.id_unidad_medida
            or old.id_central_generacion          is distinct from new.id_central_generacion
            or old.precio_vinculante_combustibles is distinct from new.precio_vinculante_combustibles
            then
                raise exception
                    'Operación denegada: el registro de fecha % tiene más de 7 días y no puede cambiar datos.',
                    old.fecha;
            end if;

        end if;
        -- Registro dentro del período editable, o solo campos
        -- administrativos modificados: permitir la operación.

    end if;

    return new;
end;
$$;


-- =============================================================================
-- FUNCIÓN 2: log_cambios_precios()
-- =============================================================================
-- Propósito:
--   Mantener una bitácora completa de cada modificación al campo
--   precio_vinculante_combustibles, registrando el valor anterior,
--   el valor nuevo y el usuario responsable del cambio.
--
-- Guard IS DISTINCT FROM:
--   Se utiliza en lugar de <> para que la condición evalúe correctamente
--   incluso cuando alguno de los valores sea NULL. Si precio_anterior y
--   precio_nuevo fueran ambos NULL, <> devolvería NULL (no TRUE ni FALSE),
--   lo que podría resultar en auditorías fantasma o en omisiones.
--
-- Dependencias:
--   · Tabla: public.audit_precios_vinculantes_combustibles
--   · Función: auth.uid() — provista por Supabase Auth para identificar
--     al usuario autenticado que ejecuta la operación.
--
-- Nota técnica:
--   Esta función debe asociarse a un trigger AFTER UPDATE para que NEW
--   y OLD contengan los valores correctos al momento del insert en auditoría.
-- =============================================================================
create or replace function public.log_cambios_precios()
returns trigger
language plpgsql
as $$
begin

    -- --------------------------------------------------
    -- Guard: solo insertar en auditoría si el precio
    -- realmente cambió. Evita registros fantasma cuando
    -- el UPDATE afecta otros campos (fuente, observaciones,
    -- archivo_origen, etc.) sin tocar el precio vinculante.
    -- --------------------------------------------------
    if old.precio_vinculante_combustibles is distinct from new.precio_vinculante_combustibles then

        insert into public.audit_precios_vinculantes_combustibles (
            id_precio_vinculante_combustible,   -- referencia al registro modificado
            precio_anterior,                    -- valor antes del UPDATE
            precio_nuevo,                       -- valor después del UPDATE
            usuario_cambio                      -- usuario autenticado en Supabase
        )
        values (
            old.id_precio_vinculante_combustible,
            old.precio_vinculante_combustibles,
            new.precio_vinculante_combustibles,
            auth.uid()
        );

    end if;

    -- Retornar NEW es obligatorio en triggers AFTER UPDATE
    -- aunque el valor no sea utilizado por PostgreSQL en este punto.
    return new;

end;
$$;