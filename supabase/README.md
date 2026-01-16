# Control Pagos DB

/control-pagos-db
│
├── 📂 supabase/
│   ├── 📂 migrations/              # Para control de versiones (si usas CLI)
│   │   └── 0001_initial_schema.sql
│   │
│   ├── 📂 catalogos/               # TABLAS MAESTRAS (Se cargan primero)
│   │   ├── 01_cat_monedas.sql
│   │   ├── 02_cat_sociedades.sql
│   │   ├── 03_cat_proveedores.sql  
│   │   ├── 04_cat_presupuesto.sql  # (Fondo, Centro Gestor, PosPre)
│   │   └── 05_cat_cuentas.sql
│   │
│   ├── 📂 transacciones/           # TABLA PRINCIPAL (Depende de los catálogos)
│   │   └── 06_diario_documentos_tpl.sql
│   │
│   └── 📂 seed_data/               # PLANTILLAS CSV PARA CARGA
│       ├── monedas.csv
│       ├── proveedores.csv
│       └── diario_operaciones.csv
│
├── 📄 .gitignore                   # Para no subir los CSV con datos reales
├── 📄 README.md                    # Instrucciones del proyecto
└── 📄 total_schema.sql             # (Opcional) Un solo archivo con todo unido

# cat        → Datos maestros (catálogos)

Combustibles
Unidades
Centrales
Regiones
Clientes
Contratos

Se cargan seeds.

# stg        → Staging + validaciones + logs
Este es el corazón del sistema.
**    Datos crudos importados (Excel, API, CSV)
    Tablas temporales
    Validaciones
    Logs
    Errores
    Auditoría técnica**


# public     → Datos finales listos para BI / operación
Aquí solo llega información limpia, validada y trazable.
Precios vinculantes finales
Suministros
Pagos
Vistas para Power BI