// jest.config.ts
import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest', // Usa ts-jest para compilar y ejecutar TypeScript
  testEnvironment: 'node', // Entorno de prueba para Node.js
  testMatch: [
    '**/?(*.)+(spec|test).[tj]s?(x)', // Patrón para encontrar archivos de prueba (e.g., .test.ts, .spec.ts)
  ],
  moduleFileExtensions: ['ts', 'js', 'json', 'node'], // Extensiones de archivo que Jest debe manejar
  roots: ['<rootDir>/src'], // Directorios donde Jest buscará archivos de prueba y código fuente
  collectCoverage: true, // Recopila información de cobertura de código
  coverageDirectory: 'coverage', // Directorio para los informes de cobertura
  coveragePathIgnorePatterns: [
    // Patrones a ignorar para la cobertura
    '/node_modules/',
    '/dist/',
    '/src/index.ts', // No necesitamos probar el punto de entrada del servidor directamente
    '/src/routes/index.ts', // No necesitamos probar la configuración de rutas
    '/src/config/', // No necesitamos probar la configuración de la DB
  ],
  // Si usas rutas con alias en tu tsconfig.json (ej. "@utils/*"):
  // moduleNameMapper: {
  //   "^@utils/(.*)$": "<rootDir>/src/utils/$1",
  //   "^@services/(.*)$": "<rootDir>/src/services/$1"
  // }
};

export default config;
