# Orden de Carga de Datos (Seed/Backup)

1. **Nivel 1 (Base):**
   - 📄 01_cat_monedas.sql -> monedas.csv
   - 📄 02_cat_sociedades.sql -> sociedades.csv

2. **Nivel 2 (Maestros):**
   - 📄 03_cat_proveedores.sql -> proveedores.csv
   - 📄 04_cat_cuentas.sql -> cuentas.csv

3. **Nivel 3 (Operativo):**
   - 📄 05_diario_documentos.sql -> diario_carga_anual.csv