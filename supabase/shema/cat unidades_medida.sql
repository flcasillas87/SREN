-- 1. Aseguramos que la tabla de unidades esté limpia antes de crearla
drop table if exists public.cat_unidades cascade;

-- 2. Creación de cat_unidades vinculada a tu tabla cat_combustibles
create table public.cat_unidades (
  id_unidad serial not null,
  codigo character varying(20) not null,   -- Ej: 'MMBTU', 'LITRO'
  descripcion text null,
  factor_conversion_mbtu numeric(15, 8) not null, -- Precisión para cálculos energéticos
  
  -- Relación con tu tabla existente
  id_combustible integer not null,
  
  es_activo boolean null default true,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),

  -- Definición de Constraints
  constraint cat_unidades_pkey primary key (id_unidad),
  constraint cat_unidades_codigo_key unique (codigo),
  
  -- La línea clave que consultaste, vinculada a tu PK 'id_combustible'
  constraint fk_cat_unidades_combustible 
    foreign key (id_combustible) 
    references public.cat_combustibles (id_combustible) 
    on delete restrict
) TABLESPACE pg_default;

-- 3. Comentarios para documentación en el Dashboard de Supabase
comment on table public.cat_unidades is 'Unidades de medida vinculadas a tipos de combustibles específicos.';
comment on column public.cat_unidades.factor_conversion_mbtu is 'Factor multiplicador para normalizar el precio a MMBtu.';