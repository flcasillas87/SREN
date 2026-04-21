-- =========================================================
-- Esquema: staging
-- Tabla: cat_centros_gestores
-- Archivo: 02_load_csv_cat_centros_gestores.sql
-- Descripción: Carga de archivo CSV a tabla de staging
-- =========================================================

truncate table staging.cat_centros_gestores;

\copy staging.cat_centros_gestores (
  codigo,
  nombre,
  sociedad_id,
  pos_pre,
  cuenta_contable,
  fondo,
  activo
)
from 'C:/ruta/cat_centros_gestores_rows.csv'
with (
  format csv,
  header true,
  encoding 'UTF8'
);
