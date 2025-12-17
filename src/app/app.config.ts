import { ApplicationConfig, provideBrowserGlobalErrorListeners, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router'; // Importa funciones para configurar el enrutador.

import { routes } from './app.routes'; // Importa las rutas de la aplicación.
import { provideMaterialModules } from './core/material.config';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideMaterialModules(), // <-- todos los módulos Material globales
  ],
};
