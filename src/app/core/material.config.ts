import { importProvidersFrom } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatToolbarModule } from '@angular/material/toolbar';

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
    MatListModule,
  );
