import { importProvidersFrom } from '@angular/core';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatCardModule } from '@angular/material/card';


/**
 * Centraliza los módulos de Angular Material y las animaciones para su uso global.
 * Agrega o elimina módulos de Material aquí para mantener la consistencia en toda la app.
 */
export const provideMaterialModules = () =>
  importProvidersFrom(
    MatButtonModule,
    MatCardModule,
    MatSnackBarModule,
    MatIconModule,
    MatToolbarModule,
    MatSidenavModule,
    MatListModule
  );
