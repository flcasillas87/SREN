-- COPY se ejecuta desde cliente / Supabase SQL Editor
copy stg.precios_vinculantes_combustibles
from '/data/precios_vinculantes_combustibles.csv'
csv header;
