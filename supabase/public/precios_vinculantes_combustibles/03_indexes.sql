-- =============================================================================
-- ÍNDICES
-- =============================================================================

drop index if exists public.idx_precios_vinculantes_fecha_combustible;
drop index if exists public.idx_precios_vinculantes_central_fecha;
drop index if exists public.idx_precios_vinculantes_activo;
drop index if exists public.idx_precios_vinculantes_lookup;

create index idx_precios_vinculantes_fecha_combustible 
on public.precios_vinculantes_combustibles (fecha desc, id_combustible);

create index idx_precios_vinculantes_central_fecha 
on public.precios_vinculantes_combustibles (id_central_generacion, fecha desc);

create index idx_precios_vinculantes_activo 
on public.precios_vinculantes_combustibles (es_activo)
where es_activo = true;

create index idx_precios_vinculantes_lookup 
on public.precios_vinculantes_combustibles (
    id_combustible,
    id_central_generacion,
    fecha desc
);

