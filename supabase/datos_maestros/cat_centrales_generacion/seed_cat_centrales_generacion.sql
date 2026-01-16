CREATE OR REPLACE FUNCTION datos_maestros.seed_cat_centrales_generacion() RETURNS void AS $$ BEGIN -- =========================================================
    -- DATOS SEMILLA (SEEDING)
    -- =========================================================
insert into datos_maestros.cat_centrales_generacion (
        nombre_central,
        ubicacion_estado,
        ubicacion_municipio,
        tipo_central,
        estado_operacion,
        capacidad_mw,
        combustible_principal,
        combustible_secundario
    )
values (
        'CT Carbon II',
        'Coahuila',
        'Nava',
        'Central Termoelectrica',
        'operando',
        1400.0,
        'Carbon',
        'Diesel'
    ),
    (
        'CT Guadalupe Victoria',
        'Coahuila',
        'Villa Juárez',
        'Central Termoelectrica',
        'operando',
        320.0,
        'Gas Natural',
        'Combustoleo Diesel'
    ),
    (
        'CCC El Encino',
        'Chihuahua',
        'El Encino',
        'Central Ciclo Combinado',
        'operando',
        220.0,
        'Gas Natural',
        'Combustoleo'
    ),
    (
        'CT Emilio Portes Gil (U3)',
        'Tamaulipas',
        'Río Bravo',
        'Central Termoelectrica',
        'operando',
        300.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Emilio Portes Gil (U4)',
        'Tamaulipas',
        'Río Bravo',
        'Central Ciclo Combinado',
        'operando',
        225.0,
        'Gas Natural',
        NULL
    ),
    (
        'CT Francisco Villa',
        'Chihuahua',
        'Delicias',
        'Central Termoeléctrica',
        'operando',
        316.0,
        'Gas Natural',
        'Combustoleo Diesel (Pilotos)'
    ),
    (
        'CCC Gomez Palacio',
        'Coahuila',
        'Gomez Palacio',
        'Central Ciclo Combinado',
        'operando',
        240.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG Monclova',
        'Coahuila',
        'Monclova',
        'Central Termoelectrica',
        'operando',
        55.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG Tecnologico',
        'Nuevo Leon',
        'Monterrey',
        'Central Termoelectrica',
        'operando',
        30.0,
        'Diesel',
        NULL
    ),
    (
        'CTG Universidad',
        'Nuevo Leon',
        'Monterrey',
        'Central Termoelectrica',
        'operando',
        28.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG Leona',
        'Nuevo Leon',
        'Monterrey',
        'Central Termoelectrica',
        'operando',
        28.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG Fundidora',
        'Nuevo Leon',
        'Monterrey',
        'Central Termoelectrica',
        'operando',
        14.0,
        'Gas Natural',
        NULL
    ),
    (
        'CT Samalayuca B. Juarez',
        'Chihuahua',
        'Samalayuca',
        'Central Termoelectrica',
        'operando',
        316.0,
        'Gas Natural',
        'Combustóleo'
    ),
    (
        'CCC Samalayuca II',
        'Chihuahua',
        'Samalayuca',
        'Central Ciclo Combinado',
        'operando',
        690.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG La Laguna',
        'Coahuila',
        'Gomez Palacio',
        'Central Termoelectrica',
        'operando',
        60.0,
        'Gas Natural',
        NULL
    ),
    (
        'CTG Chavez',
        'Coahuila',
        'Francisco I. Madero',
        'Central Turbo Gas',
        'operando',
        15.0,
        'Gas Natural',
        'Diesel para el arranque'
    ),
    (
        'CTG Parque',
        'Chihuahua',
        'Cd. Juárez',
        'Central Turbo Gas',
        'operando',
        65.0,
        'Diesel',
        NULL
    ),
    (
        'CTG Industrial',
        'Chihuahua',
        'Cd. Juárez',
        'Central Turbo Gas',
        'operando',
        20.0,
        'Diesel',
        NULL
    ),
    (
        'CCC Saltillo',
        'Coahuila',
        'Ramos Arispe',
        'Central Ciclo Combinado',
        'operando',
        248.0,
        'Gas Natural',
        'Diesel'
    ),
    (
        'CCC Norte I',
        'Durango',
        'La Trinidad',
        'Central Ciclo Combinado',
        'operando',
        508.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Norte II',
        'Chihuahua',
        'El Encino',
        'Central Ciclo Combinado',
        'operando',
        450.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Norte III',
        'Chihuahua',
        'Samalayuca',
        'Central Ciclo Combinado',
        'operando',
        907.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Chihuahua II',
        'Chihuahua',
        'El Encino',
        'Central Ciclo Combinado',
        'operando',
        448.0,
        'Gas Natural',
        NULL
    ),
    (
        'CC Noreste',
        'Nuevo Leon',
        'Escobedo',
        'Central Ciclo Combinado',
        'operando',
        857.0,
        'Gas Natural',
        NULL
    ),
    (
        'CT Lopez Portillo (Rio Escondido)',
        'Coahuila',
        'Nava',
        'Central Termoelectrica',
        'operando',
        1200.0,
        'Carbon',
        'Diesel'
    ),
    (
        'CTG Huinala',
        'Nuevo Leon',
        'Pesqueria',
        'Central Termoelectrica',
        'operando',
        150.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Huinala',
        'Nuevo Leon',
        'Pesqueria',
        'Central Ciclo Combinado',
        'operando',
        377.6,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Huinala II',
        'Nuevo Leon',
        'Pesqueria',
        'Central Ciclo Combinado',
        'operando',
        260.0,
        'Gas Natural',
        NULL
    ),
    (
        'CCC Río Bravo II (Anáhuac)',
        'Tamaulipas',
        'Río Bravo',
        'Central Ciclo Combinado',
        'operando',
        495.0,
        'Gas Natural',
        'Diesel'
    ),
    (
        'CCC Chihuahua III',
        'Chihuahua',
        'Samalayuca',
        'Central Ciclo Combinado',
        'operando',
        260.0,
        'Gas Natural',
        NULL
    ),
    (
        'CT Villa de Reyes',
        'San Luis Potosi',
        'Villa de Reyes',
        'Central Termoelectrica',
        'operando',
        700.0,
        'Gas Natural',
        'Combustóleo'
    ),
    (
        'CC Villa de Reyes',
        'San Luis Potosi',
        'Villa de Reyes',
        'Central Ciclo Combinado',
        'operando',
        437.0,
        'Gas Natural',
        NULL
    ),
    (
        'CC Lerdo',
        'Coahuila',
        'Villa Juárez',
        'Central Ciclo Combinado',
        'No',
        350.0,
        'Gas Natural',
        NULL
    ),
    (
        'CT Altamira',
        'Tamaulipas',
        'Altamira',
        'Central Termoelectrica',
        'operando',
        916.0,
        'Gas Natural',
        'Combustóleo'
    ) on conflict (nombre_central) do
update
set ubicacion_estado = EXCLUDED.ubicacion_estado,
    ubicacion_municipio = EXCLUDED.ubicacion_municipio,
    tipo_central = EXCLUDED.tipo_central,
    capacidad_mw = EXCLUDED.capacidad_mw,
    estado_operacion = EXCLUDED.estado_operacion,
    combustible_principal = EXCLUDED.combustible_principal,
    combustible_secundario = EXCLUDED.combustible_secundario,
    updated_at = now() at time zone 'America/Monterrey';
RAISE NOTICE 'Semillas de cat_centrales_generacion cargadas correctamente.';
END;
$$ LANGUAGE plpgsql;