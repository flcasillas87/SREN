create schema if not exists staging;    -- Para datos crudos y temporales
create schema if not exists datos_maestros;    -- Para tablas maestras y lógica de negocio
create schema if not exists reporting;    -- Para vistas y tablas optimizadas para reportes
create schema if not exists etl;    -- Para lógica de transformación y carga de datos