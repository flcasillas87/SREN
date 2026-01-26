import { Routes } from '@angular/router';
import { authGuard, publicGuard } from '@guards/auth.guard';

export const routes: Routes = [
  // LOGIN (público)
  {
    path: 'login',
    canActivate: [publicGuard],
    loadComponent: () => import('./auth/log-in/login.component').then((m) => m.default),
  },

  {
    path: 'centrales',
    canActivate: [publicGuard],
    loadChildren: () => import('./features/centrales/centrales.routes').then((m) => m.centralesRoutes),
  },

  // APP PRIVADA
  {
    path: '',
    canActivate: [authGuard],
    loadComponent: () => import('./shared/components/layout/layout.component').then((m) => m.LayoutComponent),
    children: [
      {
        path: '',
        loadComponent: () =>
          import('./features/centrales/pages/central-list/CentralListPage').then(
            (m) => m.CentralListPage,
          ),
      },
    ],
  },

  // 404
  {
    path: '**',
    loadComponent: () => import('./shared/errors/not-found/not-found.component').then((m) => m.NotFoundComponent),
  },
];
