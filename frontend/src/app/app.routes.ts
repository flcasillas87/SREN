import { Routes } from '@angular/router';

import { HeaderComponent } from './shared/components/header/header.component';
import { LayoutComponent } from './shared/components/layout/layout.component';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./centrales/components/centrales.component').then((m) => m.CentralesComponent),
  },
  { path: 'header', component: HeaderComponent },
  { path: 'layout', component: LayoutComponent },
  {
    path: '**',
    loadComponent: () => import('./features/errors/not-found/not-found.component').then((m) => m.NotFoundComponent),
  },
];
