🚀 Este repositorio contiene el código fuente para un proyecto backend en TypeScript + Express conectado a una base de datos.

📁 Estructura del Proyecto
🧰 Tecnologías Utilizadas
Backend:
index.ts # Punto de entrada principal
📁 /config
#Estructura del Proyecto
│ └── db.ts # Configuración y conexión a la base de datosdb.ts  
📁 /routes
│ ├── userRoutes.ts # Rutas específicas para usuarios
│ └── index.ts # Centraliza la exportación de todas las rutas
📁 /services
│ └── userService.ts # Lógica de negocio para usuarios
📁 /controllers
│ └── userController.ts # Manejadores de solicitudes para rutas de usuario
📁 /models
└── User.ts # Definición del modelo de datos para usuarios
