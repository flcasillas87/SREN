import { Routes } from '@angular/router';
import { authGuard, publicGuard } from '@guards/auth.guard';

export const routes: Routes = [

  // LOGIN (público)
  {
    path: 'login',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./auth/log-in/login.component')
        .then(m => m.default),
  },

  {
    path: 'centrales',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./features/centrales/layout/centrales.component')
        .then(m => m.CentralesComponent),
  },

  {
    path: 'centrales-detail',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./features/centrales-detail/centrales-detail')
        .then(m => m.CentralesDetailComponent),
  },

    {
    path: 'central-detalle',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./features/centrales/pages/central-detalle.page')
        .then(m => m.CentralDetallePage),
  },

    {
    path: 'centrales-list',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./features/centrales-list/centrales-list.component')
        .then(m => m.CentralesListComponent),
  },

  {
    path: 'consumos-form',
    canActivate: [publicGuard],
    loadComponent: () =>
      import('./features/consumos-form/consumos-form.component')
        .then(m => m.ConsumosFormComponent),
  },



  // APP PRIVADA
  {
    path: '',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./shared/components/layout/layout.component')
        .then(m => m.LayoutComponent),
    children: [
      {
        path: '',
        loadComponent: () =>
          import('./features/centrales-list/centrales-list.component')
            .then(m => m.CentralesListComponent),
      },
    ],
  },

  // 404
  {
    path: '**',
    loadComponent: () =>
      import('./features/errors/not-found/not-found.component')
        .then(m => m.NotFoundComponent),
  },
];
