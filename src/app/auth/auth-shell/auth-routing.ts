import { Routes } from '@angular/router';

export default [
  {
    path: 'sign-up',
    loadComponent: () => import('../sign-up/sign-up.component'),
  },
  {
    path: 'log-in',
    loadComponent: () => import('../log-in/login.component'),
  },
  {
    path: '**',
    redirectTo: 'log-in',
  },
] as Routes;