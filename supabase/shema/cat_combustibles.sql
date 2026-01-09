create table public.cat_combustibles (
  id_combustible serial not null,
  nombre character varying(50) not null,
  descripcion text null,
  tipo text null,
  es_activo boolean null default true,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null,
  constraint cat_combustibles_pkey primary key (id_combustible),
  constraint cat_combustibles_nombre_key unique (nombre)
) TABLESPACE pg_default;