-- =============================================================================
-- set_updated_at_mx()
-- =============================================================================
-- Esta función es universal, la puedes usar en cualquier tabla futura.
create or replace function public.set_updated_at_mx() returns trigger as $$ begin new.updated_at = now() at time zone 'America/Mexico_City';
return new;
end;
$$ language plpgsql;
-- =============================================================================
-- set_created_at_mx()
-- =============================================================================
-- Esta función es universal, la puedes usar en cualquier tabla futura.
create or replace function public.set_created_at_mx() returns trigger as $$ begin new.created_at = now() at time zone 'America/Mexico_City';
return new;
end;
$$ language plpgsql;