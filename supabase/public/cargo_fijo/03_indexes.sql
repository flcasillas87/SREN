-- =========================================================
-- Esquema: public
-- Tabla: cargo_fijo
-- Archivo: 03_indexes.sql
-- =========================================================

create index if not exists idx_cf_factura
    on public.cargo_fijo using btree (id_factura)
    tablespace pg_default;
