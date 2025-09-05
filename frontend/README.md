# SREN

Aplicación Angular

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you
change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use
`ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via a platform of your choice. To use this command, you need to first add a
package that implements end-to-end testing capabilities.

## Further help

To get more help on the Angular CLI use `ng help` or go check out the
[Angular CLI Overview and Command Reference](https://angular.io/cli) page.

## src/app/core

Contiene los interceptores HTTP, como auth.interceptor.ts, que se utilizan para interceptar y modificar las solicitudes
HTTP.

## src/app/shared

Contiene componentes reutilizables, directivas y pipes.

## src/app/features

Contiene módulos de características específicas de la aplicación.

## src/assets

Contiene recursos estáticos como imágenes.

## src/environments

Contiene archivos de configuración de entornos, como environment.ts y environment.prod.ts.

## src/styles

Contiene archivos de estilos globales, como styles.scss.

## src/main.ts

El punto de entrada principal de la aplicación Angular.

## NrRx

Acciones: Coloca todas las acciones relacionadas en un archivo dentro de la carpeta actions. Reducers: Coloca todos los
reducers relacionados en un archivo dentro de la carpeta reducers. Efectos: Coloca todos los efectos relacionados en un
archivo dentro de la carpeta effects. Modelos: Define los modelos de datos en la carpeta models

# Estructura de Proyecto Angular para Sistema de Precios de Gas Natural

Este documento detalla la estructura recomendada para un proyecto Angular robusto, enfocado en un sistema de gestión de
precios y costos de gas natural.

---

## 📂 Estructura de Archivos y Carpetas

```bash
src/
├── app/
│   ├── core/
│   │   ├── guards/
│   │   │   └── auth.guard.ts
│   │   ├── interceptors/
│   │   │   └── http-token.interceptor.ts
│   │   ├── services/
│   │   │   ├── auth.service.ts
│   │   │   └── api.service.ts
│   │   ├── models/
│   │   │   └── user.model.ts
│   │   └── core.module.ts
│   │
│   ├── shared/
│   │   ├── components/
│   │   │   ├── table/
│   │   │   │   ├── table.component.ts
│   │   │   │   └── table.component.html
│   │   │   └── loading-spinner/
│   │   ├── pipes/
│   │   │   └── currency-format.pipe.ts
│   │   ├── directives/
│   │   │   └── tooltip.directive.ts
│   │   └── shared.module.ts
│   │
│   ├── features/
│   │   ├── dashboard/
│   │   │   ├── components/
│   │   │   │   └── chart/
│   │   │   ├── services/
│   │   │   │   └── dashboard.service.ts
│   │   │   ├── models/
│   │   │   │   └── chart-data.model.ts
│   │   │   └── dashboard.module.ts
│   │   │
│   │   ├── prices/
│   │   │   ├── components/
│   │   │   │   ├── price-form/
│   │   │   │   └── price-list/
│   │   │   ├── services/
│   │   │   │   └── price.service.ts
│   │   │   ├── models/
│   │   │   │   └── price.model.ts
│   │   │   └── prices.module.ts
│   │   │
│   │   └── consumption/
│   │
│   ├── data/
│   │   ├── enums/
│   │   │   └── measurement-unit.enum.ts
│   │   ├── interfaces/
│   │   │   └── api-response.interface.ts
│   │   └── api/
│   │       └── api.config.ts
│   │
│   ├── app-routing.module.ts
│   └── app.module.ts
│
├── assets/
│   ├── icons/
│   ├── images/
│   └── styles/
│       ├── _variables.scss
│       └── styles.scss
│
├── environments/
│   ├── environment.ts
│   └── environment.prod.ts
│
└── index.html
```
