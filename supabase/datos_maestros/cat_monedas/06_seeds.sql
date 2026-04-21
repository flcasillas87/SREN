-- =========================================================
-- Esquema: datos_maestros
-- Tabla: cat_monedas
-- Archivo: 06_seeds.sql
-- =========================================================

insert into datos_maestros.cat_monedas (codigo, descripcion)
values
    ('MXN', 'Peso Mexicano'),
    ('USD', 'Dolar Americano')
on conflict (codigo) do nothing;
