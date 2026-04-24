-- COPY se ejecuta desde cliente / Supabase SQL Editor
copy staging.stg_precios_vinculantes_combustibles (
    fecha,
    nombre_combustible,
    nombre_unidad_medida,
    nombre_central,
    precio_vinculante_combustibles,
    fuente,
    observaciones,
    archivo_origen,
    fecha_carga
)
from '/data/precios_vinculantes_combustibles.csv'
csv header;
