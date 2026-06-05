-- =============================================================================
-- 06_seeds.sql
-- Datos de semilla para public.reporte_operativo_combustibles
-- =============================================================================

-- Insertar una fila de ejemplo de reporte operativo por combustible y central.
-- Esta semilla usa valores existentes de los catálogos de datos maestros para
-- evitar violaciones de clave foránea.

insert into public.reporte_operativo_combustibles (
    fecha_entrega,
    id_central_generacion,
    id_combustible,
    id_unidad_medida,
    volumen,
    fuente,
    observaciones,
    archivo_origen,
    es_activo
)
select
    '2026-06-01'::date,
    cg.id_central_generacion,
    c.id_combustible,
    um.id_unidad_medida,
    1250.50,
    'Suministro regular',
    'Entrega programada',
    'origen_archivo.csv',
    true
from datos_maestros.cat_centrales_generacion cg
cross join datos_maestros.cat_combustibles c
cross join datos_maestros.cat_unidades_medida um
limit 1;

-- Nota: si los catálogos aún no tienen datos, este seed no insertará nada.
-- Asegúrate de cargar primero los catálogos de datos maestros antes de poblar
-- esta tabla.

