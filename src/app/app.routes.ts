import { Routes } from '@angular/router';
import { authGuard, publicGuard } from '@guards/auth.guard';

export const routes: Routes = [

  {
    path: '',
    canActivate: [authGuard],
    loadComponent: () => import('./shared/components/layout/layout.component').then((m) => m.LayoutComponent),
    children: [
      {
        path: '',
        loadComponent: () => import('./features/centrales-list/centrales-list.component').then((m) => m.CentralesListComponent),
      },
    ]
  },

      // auth route
      {
        path: 'auth',
        canActivate: [publicGuard],
        children: [
          {
            path: 'login',
            loadComponent: () => import('./auth/log-in/login.component').then(m => m.default),
          }
        ]
      },


      // wildcard route for 404 page
      {
        path: '**',
        loadComponent: () => import('./features/errors/not-found/not-found.component').then((m) => m.NotFoundComponent),
      },
    ];
