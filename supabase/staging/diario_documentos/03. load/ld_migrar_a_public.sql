-- =========================================================
-- Script: 03. Load / ld_migrar_a_public.sql
-- Objetivo: Persistir los datos transformados en la tabla final
-- =========================================================
call etl.pr_load_diario_documentos();
