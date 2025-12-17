# SCRIPTS

Este documento explica los scripts disponibles en el `package.json` del proyecto, su propósito y cuándo deben
ejecutarse.

## 📋 Tabla de Contenidos

- [SCRIPTS](#scripts)
  - [📋 Tabla de Contenidos](#-tabla-de-contenidos)
  - [🛠 Scripts Principales](#-scripts-principales)
    - [`dev`](#dev)
    - [`build`](#build)
    - [`start`](#start)
    - [`test`](#test)
  - [Scripts de Calidad de Código](#scripts-de-calidad-de-código)
    - [`lint`](#lint)
    - [`format`](#format)
    - [`lint:fix`](#lintfix)
  - [Scripts de Prisma](#scripts-de-prisma)
    - [`prisma:generate`](#prismagenerate)
    - [`prisma:migrate`](#prismamigrate)
    - [`prisma:studio`](#prismastudio)
  - [Scripts de Configuración](#scripts-de-configuración)
    - [`prepare`](#prepare)
    - [Desarrollo diario:](#desarrollo-diario)
    - [Preparación para commit:](#preparación-para-commit)
    - [Cambios en base de datos:](#cambios-en-base-de-datos)
    - [Preparación para producción:](#preparación-para-producción)
    - [Configuración inicial:](#configuración-inicial)

## 🛠 Scripts Principales

### `dev`

```bash
npm run dev
```

📌 Función: Inicia el servidor en modo desarrollo con: 🔄 Reinicio automático con Nodemon ⚡ Ejecución directa de
TypeScript (ts-node) 📦 Soporte para módulos ES (ESM)

🚀 Uso típico: Durante el desarrollo activo cuando necesitas ver cambios en tiempo real.

🔍 Observaciones: Monitoriza cambios en archivos .ts en la carpeta src/ No requiere compilación previa

🏗 Scripts de Construcción y Producción

### `build`

```bash
npm run build
```

📌Propósito: Compila el código TypeScript a JavaScript en la carpeta dist/. 🚀 Uso típico::Antes de desplegar a
producción, Para probar el código compilado localmente

### `start`

```bash
npm run start
```

Propósito: Ejecuta la aplicación compilada desde dist/index.js. Cuándo usarlo: En entornos de producción Para probar la
versión compilada localmente

### `test`

```bash
npm run test
```

Propósito: Ejecuta los tests del proyecto (configuración con Jest requerida). Cuándo usarlo: Durante desarrollo para
verificar funcionalidad En pipelines de CI/CD

## Scripts de Calidad de Código

### `lint`

```bash
npm run lint
```

Propósito: Analiza el código en busca de problemas de estilo y posibles errores.

### `format`

```bash
npm run format
```

Propósito: Formatea automáticamente el código según las reglas de Prettier.

### `lint:fix`

```bash
npm run lint:fix
```

Propósito: Intenta corregir automáticamente problemas detectados por ESLint. Cuándo usarlos: Antes de commits En
integración continua Cuando se incorpora nuevo código

## Scripts de Prisma

### `prisma:generate`

```bash
npm run prisma:generate
```

Propósito: Genera el cliente de Prisma basado en el esquema.

### `prisma:migrate`

```bash
npm run prisma:migrate
```

Propósito: Ejecuta migraciones de base de datos y genera el cliente.

### `prisma:studio`

```bash
npm run prisma:studio
```

Propósito: Abre la interfaz web para administrar la base de datos. Cuándo usarlos: Al cambiar el esquema de la base de
datos Durante el desarrollo cuando se necesitan ajustes en los datos Al configurar el proyecto por primera vez

## Scripts de Configuración

### `prepare`

```bash
npm run prepare
```

Propósito: Configura Husky (git hooks) automáticamente. Se ejecuta tras npm install. Flujo de Trabajo Recomendado

### Desarrollo diario:

```bash
npm run dev
```

### Preparación para commit:

```bash
npm run lint:fix
npm run format
npm run test
```

### Cambios en base de datos:

```bash
npm run prisma:migrate
```

### Preparación para producción:

```bash
npm run build
npm run start
```

### Configuración inicial:

```bash
npm install
npm run prisma:generate
npm run prisma:migrate
```
