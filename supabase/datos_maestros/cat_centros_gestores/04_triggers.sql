-- =========================================================
-- Archivo: 04_triggers_cat_centros_gestores.sql
-- =========================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_cat_centros_gestores_set_updated_at
  on datos_maestros.cat_centros_gestores;

create trigger trg_cat_centros_gestores_set_updated_at
before update on datos_maestros.cat_centros_gestores
for each row
execute function public.set_updated_at();
