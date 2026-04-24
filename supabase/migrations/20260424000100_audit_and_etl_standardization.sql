-- =============================================================================
-- Auditoría y ETL homogéneos para tablas persistentes
-- =============================================================================

create schema if not exists etl;

create table if not exists public.audit_cambios_tablas (
    id_audit_cambio_tabla bigserial primary key,
    schema_name text not null,
    table_name text not null,
    operation text not null,
    old_row jsonb null,
    new_row jsonb null,
    changed_by uuid null default auth.uid(),
    changed_at timestamp null default (now() at time zone 'America/Monterrey')
);

do $$
declare
    r record;
    v_has_updated_at boolean;
    v_has_updated_at_trigger boolean;
begin
    for r in
        select
            n.nspname as schema_name,
            c.relname as table_name,
            c.oid as table_oid
        from pg_class c
        join pg_namespace n on n.oid = c.relnamespace
        where n.nspname in ('public', 'datos_maestros')
        and c.relkind = 'r'
          and c.relname not like 'audit_%'
          and c.relname <> 'audit_cambios_tablas'
          and not (n.nspname = 'public' and c.relname = 'precios_vinculantes_combustibles')
    loop
        select exists (
            select 1
            from information_schema.columns col
            where col.table_schema = r.schema_name
              and col.table_name = r.table_name
              and col.column_name = 'updated_at'
        )
        into v_has_updated_at;

        select exists (
            select 1
            from pg_trigger tg
            join pg_proc p on p.oid = tg.tgfoid
            where tg.tgrelid = (format('%I.%I', r.schema_name, r.table_name))::regclass
              and not tg.tgisinternal
              and p.proname in ('set_updated_at_mx', 'fn_update_at_mx')
        )
        into v_has_updated_at_trigger;

        if v_has_updated_at and not v_has_updated_at_trigger then
            execute format('drop trigger if exists %I on %I.%I;',
                'tr_set_updated_at_mx',
                r.schema_name,
                r.table_name
            );

            execute format(
                'create trigger %I before update on %I.%I for each row execute function public.set_updated_at_mx();',
                'tr_set_updated_at_mx',
                r.schema_name,
                r.table_name
            );
        end if;

        execute format('drop trigger if exists %I on %I.%I;',
            'tr_audit_' || r.table_name,
            r.schema_name,
            r.table_name
        );

        execute format(
            'create trigger %I after insert or update or delete on %I.%I for each row execute function public.fn_audit_row_mx();',
            'tr_audit_' || r.table_name,
            r.schema_name,
            r.table_name
        );
    end loop;
end
$$;
